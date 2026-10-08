List<int> versionParts(String value) {
  return value
      .split(RegExp(r'[^\d]+'))
      .where((part) => part.isNotEmpty)
      .map((part) => int.tryParse(part) ?? 0)
      .toList();
}

bool isSameVersion(String a, String b) {
  final left = versionParts(a);
  final right = versionParts(b);
  final length = left.length > right.length ? left.length : right.length;
  for (var i = 0; i < length; i++) {
    final leftPart = i < left.length ? left[i] : 0;
    final rightPart = i < right.length ? right[i] : 0;
    if (leftPart != rightPart) return false;
  }
  return true;
}

bool isNewerVersion(String remote, String local) {
  final left = versionParts(remote);
  final right = versionParts(local);
  final length = left.length > right.length ? left.length : right.length;
  for (var i = 0; i < length; i++) {
    final remotePart = i < left.length ? left[i] : 0;
    final localPart = i < right.length ? right[i] : 0;
    if (remotePart > localPart) return true;
    if (remotePart < localPart) return false;
  }
  return false;
}
