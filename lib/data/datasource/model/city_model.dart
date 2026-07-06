class CityModel {
  final int id;
  final String name;
  final String? imageUrl;

  const CityModel({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: _toInt(json['id']) ?? 0,
      name: json['name']?.toString() ?? '',
      imageUrl: json['image_url']?.toString(),
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }
}
