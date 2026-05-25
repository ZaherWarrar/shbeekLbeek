import 'package:get/get.dart';

class RestaurantModel {
  final int id;
  final String name;
  final String image;
  final double rating;
  final String category;
  final String favoriteType;
  RxBool isFavorite;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.category,
    this.favoriteType = 'product',
    required bool isFavorite,
  }) : isFavorite = isFavorite.obs;

  factory RestaurantModel.fromFavoriteJson(Map<String, dynamic> json) {
    final favoritableType = json['favoritable_type']?.toString() ?? '';
    final type = _normalizeFavoriteType(favoritableType);
    final favoritable = json['favoritable'];
    final favoritableMap = favoritable is Map<String, dynamic>
        ? favoritable
        : favoritable is Map
        ? Map<String, dynamic>.from(favoritable)
        : <String, dynamic>{};

    final idValue = favoritableMap['id'];
    final id = idValue is int ? idValue : int.tryParse('$idValue') ?? 0;

    final name = favoritableMap['name']?.toString() ?? '';
    final image = favoritableMap['image_url']?.toString() ?? '';
    final category = type == 'product'
        ? favoritableMap['price']?.toString() ?? ''
        : favoritableMap['type']?.toString() ?? '';
    final isFavorite = favoritableMap['is_favorite'] == true;

    return RestaurantModel(
      id: id,
      name: name,
      image: image,
      rating: 0,
      category: category,
      favoriteType: type,
      isFavorite: isFavorite,
    );
  }

  static String _normalizeFavoriteType(String value) {
    final lower = value.toLowerCase();
    if (lower.contains('product')) {
      return 'product';
    }
    if (lower.contains('category')) {
      return 'category';
    }
    return value.isEmpty ? 'product' : value;
  }

  Map<String, dynamic> toLocalJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'rating': rating,
      'category': category,
      'favoriteType': favoriteType,
      'isFavorite': isFavorite.value,
    };
  }

  factory RestaurantModel.fromLocalJson(Map<String, dynamic> json) {
    final idValue = json['id'];
    final parsedId = idValue is int ? idValue : int.tryParse('$idValue') ?? 0;
    final ratingValue = json['rating'];
    final parsedRating = ratingValue is num
        ? ratingValue.toDouble()
        : double.tryParse('$ratingValue') ?? 0.0;
    final isFavoriteValue = json['isFavorite'];
    final parsedIsFavorite =
        isFavoriteValue is bool ? isFavoriteValue : isFavoriteValue == true;

    return RestaurantModel(
      id: parsedId,
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      rating: parsedRating,
      category: json['category']?.toString() ?? '',
      favoriteType: json['favoriteType']?.toString() ?? 'product',
      isFavorite: parsedIsFavorite,
    );
  }
}
