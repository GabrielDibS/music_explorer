import 'package:flutter/material.dart';

import '../main.dart';

class MensagemErro extends StatelessWidget {
  final String mensagem;

  const MensagemErro({super.key, required this.mensagem});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppCores.erro.withValues(alpha: 0.12),
        border: Border.all(color: AppCores.erro.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: AppCores.erro),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              mensagem,
              style: const TextStyle(color: AppCores.erro, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
