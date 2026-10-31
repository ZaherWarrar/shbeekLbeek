/// Older media is served from `/uploads/images/`.
/// Product photos are served from `/uploads/products/` and must stay there.
/// Other typed folders (such as `/uploads/stores/`) still point at files
/// that were stored under `/uploads/images/`.
String? resolveMediaUrl(String? url) {
  if (url == null) return null;
  final trimmed = url.trim();
  if (trimmed.isEmpty) return url;

  return trimmed.replaceAllMapped(
    RegExp(r'/uploads/(?!images/|products/)[^/]+/'),
    (_) => '/uploads/images/',
  );
}
