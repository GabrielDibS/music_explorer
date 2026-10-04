import 'package:flutter/material.dart';

import '../main.dart';
import '../service/api_exceptions.dart';
import '../service/audiodb_service.dart';
import '../utils/validators.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/carregando_view.dart';
import '../widgets/chip_info.dart';
import '../widgets/imagem_resultado.dart';
import '../widgets/mensagem_erro.dart';

class AlbunsPage extends StatefulWidget {
  const AlbunsPage({super.key});

  @override
  State<AlbunsPage> createState() => _AlbunsPageState();
}

class _AlbunsPageState extends State<AlbunsPage> {
  final _controller = TextEditingController();
  final _apiService = AudioDbService();

  String? _erroValidacao;
  String? _erroApi;
  Map<String, dynamic>? _resultado;
  bool _carregando = false;

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
      final dado = await _apiService.albunsDoArtista(_controller.text.trim());
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
      titulo: 'Álbuns',
      icone: Icons.album,
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
            child: const Text('Buscar álbuns'),
          ),
          if (_carregando) const CarregandoView(mensagem: 'Buscando álbuns...'),
          if (!_carregando && _erroApi != null) MensagemErro(mensagem: _erroApi!),
          if (!_carregando && _resultado != null) _conteudo(),
        ],
      ),
    );
  }

  Widget _conteudo() {
    final dado = _resultado!;
    final albuns = (dado['albuns'] as List).cast<Map<String, dynamic>>();

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${dado['strArtist'] ?? ''} · ${albuns.length} álbum${albuns.length == 1 ? '' : 'ns'}',
            style: const TextStyle(color: AppCores.textoPrimario, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'A API gratuita retorna no máximo 1 álbum por consulta.',
            style: TextStyle(color: AppCores.textoSecundario, fontSize: 12, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: albuns.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.78,
            ),
            itemBuilder: (context, i) {
              final album = albuns[i];
              final capa = valorOuNulo(album['strAlbumThumb']) ?? dado['strArtistThumb'] as String?;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ImagemResultado(url: capa, aspectRatio: 1),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    album['strAlbum']?.toString() ?? 'Álbum sem nome',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppCores.textoPrimario, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    valorOuNulo(album['intYearReleased']) ?? '---',
                    style: const TextStyle(color: AppCores.textoSecundario, fontSize: 12),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
