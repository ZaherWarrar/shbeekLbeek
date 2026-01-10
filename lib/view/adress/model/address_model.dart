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
}
