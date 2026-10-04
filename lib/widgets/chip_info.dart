import 'package:flutter/material.dart';

import '../main.dart';

String? valorOuNulo(dynamic valor) {
  if (valor == null) return null;
  final texto = valor.toString().trim();
  if (texto.isEmpty || texto == '...') return null;
  return texto;
}

class ChipInfo extends StatelessWidget {
  final String rotulo;
  final dynamic valor;

  const ChipInfo({super.key, required this.rotulo, required this.valor});

  @override
  Widget build(BuildContext context) {
    final texto = valorOuNulo(valor) ?? '---';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppCores.superficieClara,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppCores.primaria.withValues(alpha: 0.25)),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: AppCores.textoSecundario),
          children: [
            TextSpan(text: '$rotulo: ', style: const TextStyle(fontWeight: FontWeight.w600)),
            TextSpan(text: texto, style: const TextStyle(color: AppCores.textoPrimario)),
          ],
        ),
      ),
    );
  }
}
