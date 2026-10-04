import 'package:flutter/material.dart';

import '../main.dart';
import 'albuns_page.dart';
import 'artista_page.dart';
import 'top_track_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppCores.primaria, Color(0xFF5B3FD6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.graphic_eq, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Catálogo Musical',
                          style: TextStyle(color: AppCores.textoPrimario, fontSize: 22, fontWeight: FontWeight.bold)),
                      Text('Dados reais via TheAudioDB',
                          style: TextStyle(color: AppCores.textoSecundario, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            _CartaoMenu(
              icone: Icons.person,
              titulo: 'Artista',
              subtitulo: 'Foto, biografia, gênero e redes sociais',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ArtistaPage()),
              ),
            ),
            const SizedBox(height: 12),
            _CartaoMenu(
              icone: Icons.music_note,
              titulo: 'Música mais tocada',
              subtitulo: 'A faixa em destaque do artista',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TopTrackPage()),
              ),
            ),
            const SizedBox(height: 12),
            _CartaoMenu(
              icone: Icons.album,
              titulo: 'Álbuns',
              subtitulo: 'Discografia completa do artista',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AlbunsPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartaoMenu extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  const _CartaoMenu({
    required this.icone,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppCores.superficie,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppCores.primaria.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icone, color: AppCores.primariaClara, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titulo, style: const TextStyle(color: AppCores.textoPrimario, fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(subtitulo, style: const TextStyle(color: AppCores.textoSecundario, fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppCores.textoSecundario),
            ],
          ),
        ),
      ),
    );
  }
}
