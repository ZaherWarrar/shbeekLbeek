import 'package:get/get.dart';

class RestaurantModel {
  final int id;
  final String name;
  final String image;
  final double rating;
  final String category;
  RxBool isFavorite;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.category,
    required bool isFavorite,
  }) : isFavorite = isFavorite.obs;
}
