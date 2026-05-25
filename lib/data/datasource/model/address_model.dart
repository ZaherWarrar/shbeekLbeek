class AddressModel {
  final String id;
  final String title;
  final String description;
  final double lat;
  final double lng;
  final bool isDefault;

  AddressModel({
    required this.id,
    required this.title,
    required this.description,
    required this.lat,
    required this.lng,
    this.isDefault = false,
  });

  // تحويل إلى Map للـ JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'lat': lat,
      'lng': lng,
      'isDefault': isDefault,
    };
  }

  // إنشاء من Map
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }
}
