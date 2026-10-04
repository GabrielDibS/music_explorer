import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_exceptions.dart';

class AudioDbService {
  static const String _baseUrl = 'www.theaudiodb.com';
  static const String _chaveGratuita = '123';
  static const Duration _timeout = Duration(seconds: 15);

  Uri _montaUri(String endpoint, Map<String, String> query) {
    return Uri.https(_baseUrl, '/api/v1/json/$_chaveGratuita/$endpoint', query);
  }

  Future<Map<String, dynamic>> buscaArtista(String nome) {
    final uri = _montaUri('search.php', {'s': nome.trim()});
    return _getPrimeiroItem(uri, 'artists', nome);
  }

  Future<Map<String, dynamic>> musicaMaisTocada(String nome) async {
    final artista = await buscaArtista(nome);
    final uri = _montaUri('track-top10.php', {'s': nome.trim()});
    final faixa = await _getPrimeiroItem(uri, 'track', nome);
    return {
      '_imagemArtista': artista['strArtistThumb'],
      ...faixa,
    };
  }

  Future<Map<String, dynamic>> albunsDoArtista(String nome) async {
    final artista = await buscaArtista(nome);
    final uri = _montaUri('discography.php', {'s': nome.trim()});
    final resposta = await _getBruto(uri);
    final lista = resposta['album'];
    if (lista == null || lista is! List || lista.isEmpty) {
      throw ApiException('Nenhum álbum encontrado para "$nome".');
    }
    return {
      'strArtist': artista['strArtist'],
      'strArtistThumb': artista['strArtistThumb'],
      'albuns': lista.whereType<Map<String, dynamic>>().toList(),
    };
  }

  Future<Map<String, dynamic>> _getPrimeiroItem(
    Uri uri,
    String chave,
    String termoBuscado, {
    String? mensagemVazio,
  }) async {
    final decodificado = await _getBruto(uri);
    final lista = decodificado[chave];
    if (lista == null || lista is! List || lista.isEmpty) {
      throw ApiException(mensagemVazio ?? 'Nenhum resultado encontrado para "$termoBuscado".');
    }
    final primeiro = lista.first;
    if (primeiro is! Map<String, dynamic>) {
      throw const ApiException('A API retornou dados em um formato inesperado.');
    }
    return primeiro;
  }

  Future<Map<String, dynamic>> _getBruto(Uri uri) async {
    http.Response response;
    try {
      response = await http.get(uri).timeout(_timeout);
    } on SocketException {
      throw const ConnectionException();
    } on TimeoutException {
      throw const ConnectionException(
        'A consulta demorou demais para responder. Verifique sua conexão e tente novamente.',
      );
    } on HttpException {
      throw const ConnectionException();
    }

    switch (response.statusCode) {
      case 200:
        break;
      case 429:
        throw const ApiException(
          'Limite de requisições atingido (máximo de 30 por minuto no plano gratuito). Aguarde um pouco e tente novamente.',
          statusCode: 429,
        );
      case 404:
        throw const ApiException('Nenhum resultado encontrado para essa consulta.', statusCode: 404);
      default:
        if (response.statusCode >= 500) {
          throw ApiException(
            'O servidor da API está indisponível no momento (código ${response.statusCode}). Tente novamente mais tarde.',
            statusCode: response.statusCode,
          );
        }
        throw ApiException(
          'Erro ao consultar a API (código ${response.statusCode}).',
          statusCode: response.statusCode,
        );
    }

    if (response.body.trim().isEmpty) {
      throw const ApiException('A API retornou uma resposta vazia.');
    }

    dynamic decodificado;
    try {
      decodificado = json.decode(response.body);
    } on FormatException {
      throw const ApiException('A API retornou dados em um formato inesperado.');
    }

    if (decodificado is! Map<String, dynamic>) {
      throw const ApiException('A API retornou dados em um formato inesperado.');
    }
    return decodificado;
  }
}
