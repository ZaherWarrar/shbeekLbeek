/// عنوان العرض هو `image_url` كما يرجعه الخادم.
/// `image_file_path` مسار تخزين نسبي وليس رابطاً صالحاً للصورة.
String? resolveMediaUrl(String? url) {
  if (url == null) return null;
  final trimmed = url.trim();
  if (trimmed.isEmpty) return null;
  return trimmed;
}
