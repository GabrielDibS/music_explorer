import 'package:flutter/material.dart';

import '../main.dart';
import 'imagem_resultado.dart';

class GaleriaImagens extends StatefulWidget {
  final List<String?> urls;

  const GaleriaImagens({super.key, required this.urls});

  @override
  State<GaleriaImagens> createState() => _GaleriaImagensState();
}

class _GaleriaImagensState extends State<GaleriaImagens> {
  final _controller = PageController();
  int _pagina = 0;

  List<String> get _urlsValidas => widget.urls
      .where((u) => u != null && u.trim().isNotEmpty)
      .cast<String>()
      .toList();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _irPara(int pagina) {
    _controller.animateToPage(
      pagina,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final urls = _urlsValidas;
    if (urls.isEmpty) {
      return const ImagemResultado(url: null);
    }

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 4 / 3,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _controller,
                  itemCount: urls.length,
                  onPageChanged: (i) => setState(() => _pagina = i),
                  itemBuilder: (context, i) => ImagemResultado(
                    url: urls[i],
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                if (urls.length > 1) ...[
                  if (_pagina > 0)
                    Positioned(
                      left: 4,
                      top: 0,
                      bottom: 0,
                      child: Center(child: _botaoSeta(Icons.chevron_left, () => _irPara(_pagina - 1))),
                    ),
                  if (_pagina < urls.length - 1)
                    Positioned(
                      right: 4,
                      top: 0,
                      bottom: 0,
                      child: Center(child: _botaoSeta(Icons.chevron_right, () => _irPara(_pagina + 1))),
                    ),
                ],
              ],
            ),
          ),
        ),
        if (urls.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              urls.length,
              (i) => GestureDetector(
                onTap: () => _irPara(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _pagina ? 18 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _pagina ? AppCores.primaria : AppCores.superficieClara,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _botaoSeta(IconData icone, VoidCallback onTap) {
    return Material(
      color: Colors.black.withValues(alpha: 0.45),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icone, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}
