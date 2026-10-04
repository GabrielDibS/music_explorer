import 'package:flutter/material.dart';

import '../main.dart';

class ImagemResultado extends StatelessWidget {
  final String? url;
  final double aspectRatio;
  final BorderRadius? borderRadius;

  const ImagemResultado({
    super.key,
    required this.url,
    this.aspectRatio = 4 / 3,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final urlAtual = url;
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Container(
          color: AppCores.superficieClara,
          child: urlAtual == null || urlAtual.isEmpty
              ? _placeholder()
              : Image.network(
                  urlAtual,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(color: AppCores.primariaClara),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => _placeholder(),
                ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return const Center(
      child: Icon(Icons.music_note, color: Color(0xFF454B5E), size: 48),
    );
  }
}
