/// Legacy files live under `/uploads/images/`, while the API currently
/// returns typed folders such as `/uploads/stores/` and `/uploads/products/`.
String? resolveMediaUrl(String? url) {
  if (url == null) return null;
  final trimmed = url.trim();
  if (trimmed.isEmpty) return url;

  return trimmed.replaceAllMapped(
    RegExp(r'/uploads/(?!images/)[^/]+/'),
    (_) => '/uploads/images/',
  );
}
