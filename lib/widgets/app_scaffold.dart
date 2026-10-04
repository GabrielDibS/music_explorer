import 'package:flutter/material.dart';

import '../main.dart';

class AppScaffold extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final Widget body;

  const AppScaffold({
    super.key,
    required this.titulo,
    required this.icone,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppCores.primaria.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icone, color: AppCores.primariaClara, size: 20),
            ),
            const SizedBox(width: 10),
            Text(titulo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: body,
        ),
      ),
    );
  }
}
