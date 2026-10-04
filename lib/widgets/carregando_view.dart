import 'package:flutter/material.dart';

import '../main.dart';

class CarregandoView extends StatelessWidget {
  final String mensagem;

  const CarregandoView({
    super.key,
    this.mensagem = 'Consultando, aguarde...',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppCores.primariaClara),
            strokeWidth: 3.5,
          ),
          const SizedBox(height: 12),
          Text(
            mensagem,
            style: const TextStyle(color: AppCores.textoSecundario, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
