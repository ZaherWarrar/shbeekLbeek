enum PlaceCategory {
  area,
  restaurant,
  pharmacy,
  mosque,
  hospital,
  store,
  other,
}

class PlacePrediction {
  const PlacePrediction({
    required this.placeId,
    required this.description,
    required this.mainText,
    required this.secondaryText,
    this.latitude,
    this.longitude,
    this.category = PlaceCategory.other,
    this.isGooglePlace = false,
    this.distanceMeters,
  });

  final String placeId;
  final String description;
  final String mainText;
  final String secondaryText;
  final double? latitude;
  final double? longitude;
  final PlaceCategory category;
  final bool isGooglePlace;
  final double? distanceMeters;

  bool get hasCoordinates =>
      latitude != null && longitude != null && latitude != 0 && longitude != 0;

  PlacePrediction copyWith({double? distanceMeters}) {
    return PlacePrediction(
      placeId: placeId,
      description: description,
      mainText: mainText,
      secondaryText: secondaryText,
      latitude: latitude,
      longitude: longitude,
      category: category,
      isGooglePlace: isGooglePlace,
      distanceMeters: distanceMeters ?? this.distanceMeters,
    );
  }
}

class PlaceDetails {
  const PlaceDetails({
    required this.latitude,
    required this.longitude,
    required this.formattedAddress,
  });

  final double latitude;
  final double longitude;
  final String formattedAddress;
}
