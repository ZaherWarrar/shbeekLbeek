class ShopsCardModel {
  final int id;
  final String name;
  final String describtion;
  final String image;
  final double rating;
  final int minDeliveryTime;
  final int maxDeliveryTime;

  ShopsCardModel({
    required this.id,
    required this.name,
    required this.describtion,
    required this.image,
    required this.rating,
    required this.minDeliveryTime,
    required this.maxDeliveryTime,
  });
}
