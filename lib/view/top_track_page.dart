import 'package:flutter/material.dart';

import '../main.dart';
import '../service/api_exceptions.dart';
import '../service/audiodb_service.dart';
import '../utils/validators.dart';
import '../utils/youtube.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/carregando_view.dart';
import '../widgets/chip_info.dart';
import '../widgets/imagem_resultado.dart';
import '../widgets/mensagem_erro.dart';

class TopTrackPage extends StatefulWidget {
  const TopTrackPage({super.key});

  @override
  State<TopTrackPage> createState() => _TopTrackPageState();
}

class _TopTrackPageState extends State<TopTrackPage> {
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
      final dado = await _apiService.musicaMaisTocada(_controller.text.trim());
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
      titulo: 'Música mais tocada',
      icone: Icons.music_note,
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
            child: const Text('Buscar faixa mais tocada'),
          ),
          if (_carregando) const CarregandoView(mensagem: 'Buscando faixa...'),
          if (!_carregando && _erroApi != null) MensagemErro(mensagem: _erroApi!),
          if (!_carregando && _resultado != null) _conteudo(),
        ],
      ),
    );
  }

  Widget _conteudo() {
    final dado = _resultado!;
    final imagem = valorOuNulo(dado['strTrackThumb']) ??
        miniaturaYoutube(dado['strMusicVid'] as String?) ??
        valorOuNulo(dado['_imagemArtista']);

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ImagemResultado(url: imagem),
          const SizedBox(height: 14),
          Text(
            dado['strTrack']?.toString() ?? '',
            style: const TextStyle(color: AppCores.textoPrimario, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(
            dado['strAlbum']?.toString() ?? '',
            style: const TextStyle(color: AppCores.textoSecundario, fontSize: 15),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChipInfo(rotulo: 'Gênero', valor: dado['strGenre']),
              ChipInfo(rotulo: 'Humor', valor: dado['strMood']),
            ],
          ),
          if (valorOuNulo(dado['strMusicVid']) != null) ...[
            const SizedBox(height: 14),
            Text('Link do videoclipe', style: TextStyle(color: AppCores.textoSecundario, fontSize: 13)),
            const SizedBox(height: 4),
            SelectableText(
              dado['strMusicVid'].toString(),
              style: const TextStyle(color: AppCores.primariaClara, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }
}
