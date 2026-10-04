String? extrairIdYoutube(String? link) {
  if (link == null || link.trim().isEmpty) return null;

  final uri = Uri.tryParse(link.trim());
  if (uri == null) return null;

  final v = uri.queryParameters['v'];
  if (v != null && v.isNotEmpty) return v;

  if (uri.host.contains('youtu.be') && uri.pathSegments.isNotEmpty) {
    return uri.pathSegments.first;
  }

  return null;
}

String? miniaturaYoutube(String? link) {
  final id = extrairIdYoutube(link);
  if (id == null) return null;
  return 'https://img.youtube.com/vi/$id/hqdefault.jpg';
}
