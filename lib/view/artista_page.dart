import 'package:flutter/material.dart';

import '../main.dart';
import '../service/api_exceptions.dart';
import '../service/audiodb_service.dart';
import '../utils/validators.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/carregando_view.dart';
import '../widgets/chip_info.dart';
import '../widgets/galeria_imagens.dart';
import '../widgets/links_sociais.dart';
import '../widgets/mensagem_erro.dart';

class ArtistaPage extends StatefulWidget {
  final String? nomeInicial;

  const ArtistaPage({super.key, this.nomeInicial});

  @override
  State<ArtistaPage> createState() => _ArtistaPageState();
}

class _ArtistaPageState extends State<ArtistaPage> {
  final _controller = TextEditingController();
  final _apiService = AudioDbService();

  String? _erroValidacao;
  String? _erroApi;
  Map<String, dynamic>? _resultado;
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    final nome = widget.nomeInicial;
    if (nome != null && nome.trim().isNotEmpty) {
      _controller.text = nome;
      WidgetsBinding.instance.addPostFrameCallback((_) => _consultar());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _consultar() async {
    final erro = Validators.nomeArtista(_controller.text);
    setState(() => _erroValidacao = erro);
    if (erro != null) return;

    setState(() {
      _carregando = true;
      _erroApi = null;
      _resultado = null;
    });

    try {
      final dado = await _apiService.buscaArtista(_controller.text.trim());
      setState(() => _resultado = dado);
    } on ConnectionException catch (e) {
      setState(() => _erroApi = e.toString());
    } on ApiException catch (e) {
      setState(() => _erroApi = e.toString());
    } catch (_) {
      setState(() => _erroApi = 'Ocorreu um erro inesperado. Tente novamente.');
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      titulo: 'Artista',
      icone: Icons.person,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'Nome do artista',
              hintText: 'Ex: Coldplay',
              errorText: _erroValidacao,
              prefixIcon: const Icon(Icons.search),
            ),
            style: const TextStyle(fontSize: 17),
            enabled: !_carregando,
            onSubmitted: (_) => _consultar(),
            onChanged: (_) {
              if (_erroValidacao != null) setState(() => _erroValidacao = null);
            },
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _carregando ? null : _consultar,
            child: const Text('Buscar artista'),
          ),
          if (_carregando) const CarregandoView(mensagem: 'Buscando artista...'),
          if (!_carregando && _erroApi != null) MensagemErro(mensagem: _erroApi!),
          if (!_carregando && _resultado != null) _conteudo(),
        ],
      ),
    );
  }

  Widget _conteudo() {
    final dado = _resultado!;
    final bio = valorOuNulo(dado['strBiographyPT']) ?? valorOuNulo(dado['strBiography']);
    final local = [
      if (valorOuNulo(dado['strCountry']) != null) dado['strCountry'],
      if (valorOuNulo(dado['intFormedYear']) != null) 'desde ${dado['intFormedYear']}',
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GaleriaImagens(urls: [
            dado['strArtistThumb'],
            dado['strArtistFanart'],
            dado['strArtistFanart2'],
            dado['strArtistFanart3'],
            dado['strArtistFanart4'],
            dado['strArtistWideThumb'],
            dado['strArtistBanner'],
            dado['strArtistClearart'],
            dado['strArtistCutout'],
            dado['strArtistLogo'],
          ]),
          const SizedBox(height: 16),
          Text(
            dado['strArtist']?.toString() ?? '',
            style: const TextStyle(color: AppCores.textoPrimario, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          if (local.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(local, style: const TextStyle(color: AppCores.textoSecundario, fontSize: 14)),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChipInfo(rotulo: 'Gênero', valor: dado['strGenre']),
              ChipInfo(rotulo: 'Humor', valor: dado['strMood']),
              ChipInfo(rotulo: 'Estilo', valor: dado['strStyle']),
              ChipInfo(rotulo: 'Tema', valor: dado['strTheme']),
              ChipInfo(rotulo: 'Popularidade', valor: dado['intPopularity']),
              ChipInfo(rotulo: 'Spotify ID', valor: dado['strSpotifyID']),
            ],
          ),
          const SizedBox(height: 14),
          LinksSociais(
            website: dado['strWebsite'],
            facebook: dado['strFacebook'],
            twitter: dado['strTwitter'],
            lastFm: dado['strLastFMChart'],
          ),
          if (bio != null) ...[
            const SizedBox(height: 16),
            Text(
              'Biografia',
              style: TextStyle(color: AppCores.textoSecundario, fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(bio, style: const TextStyle(color: AppCores.textoPrimario, fontSize: 15, height: 1.4)),
          ],
        ],
      ),
    );
  }
}
