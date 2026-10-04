import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import 'chip_info.dart';

String? _linkValido(dynamic valor, {String prefixo = ''}) {
  final texto = valorOuNulo(valor);
  if (texto == null) return null;

  if (texto.length < 4) return null;
  if (RegExp(r'^[0-9]+$').hasMatch(texto)) return null;

  final completo = texto.startsWith('http') ? texto : '$prefixo$texto';
  final uri = Uri.tryParse(completo);
  if (uri == null || !uri.hasAuthority || uri.host.isEmpty) return null;
  return completo;
}

class LinksSociais extends StatelessWidget {
  final String? website;
  final String? facebook;
  final String? twitter;
  final String? lastFm;

  const LinksSociais({
    super.key,
    this.website,
    this.facebook,
    this.twitter,
    this.lastFm,
  });

  @override
  Widget build(BuildContext context) {
    final links = <_Link>[
      if (_linkValido(website) != null) _Link('Site', Icons.language, _linkValido(website)!),
      if (_linkValido(facebook, prefixo: 'https://facebook.com/') != null)
        _Link('Facebook', Icons.facebook, _linkValido(facebook, prefixo: 'https://facebook.com/')!),
      if (_linkValido(twitter, prefixo: 'https://twitter.com/') != null)
        _Link('Twitter', Icons.alternate_email, _linkValido(twitter, prefixo: 'https://twitter.com/')!),
      if (_linkValido(lastFm) != null) _Link('Last.fm', Icons.bar_chart, _linkValido(lastFm)!),
    ];

    if (links.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: links
          .map(
            (l) => OutlinedButton.icon(
              onPressed: () => _abrir(context, l.url),
              icon: Icon(l.icone, size: 16),
              label: Text(l.nome),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppCores.primariaClara,
                side: BorderSide(color: AppCores.primaria.withValues(alpha: 0.4)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          )
          .toList(),
    );
  }

  Future<void> _abrir(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    try {
      final abriu = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!abriu && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o link.')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o link.')),
        );
      }
    }
  }
}

class _Link {
  final String nome;
  final IconData icone;
  final String url;
  const _Link(this.nome, this.icone, this.url);
}
