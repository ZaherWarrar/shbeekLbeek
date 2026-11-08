/// Older media is served from `/uploads/images/`.
/// Product photos stay in `/uploads/products/`.
/// Slider photos stay in `/uploads/sliders/` (`image_url` on the slider API).
/// Other typed folders (such as `/uploads/stores/`) still point at files
/// that were stored under `/uploads/images/`.
String? resolveMediaUrl(String? url) {
  if (url == null) return null;
  final trimmed = url.trim();
  if (trimmed.isEmpty) return url;

  return trimmed.replaceAllMapped(
    RegExp(r'/uploads/(?!images/|products/|sliders/)[^/]+/'),
    (_) => '/uploads/images/',
  );
}
