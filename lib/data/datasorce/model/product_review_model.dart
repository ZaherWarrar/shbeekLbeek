class ProductReviewsResponseModel {
  int? productId;
  List<ProductReviewModel> reviews = [];
  double? averageRating;
  int? totalReviews;

  ProductReviewsResponseModel({
    this.productId,
    List<ProductReviewModel>? reviews,
    this.averageRating,
    this.totalReviews,
  }) {
    if (reviews != null) this.reviews = reviews;
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  ProductReviewsResponseModel.fromJson(Map<String, dynamic> json) {
    productId = _toInt(json['product_id'] ?? json['productId']);
    averageRating = _toDouble(json['average_rating'] ?? json['averageRating']);
    totalReviews = _toInt(json['total_reviews'] ?? json['totalReviews']);

    final list = json['reviews'];
    if (list is List) {
      reviews = list
          .map((e) => e is Map<String, dynamic> ? ProductReviewModel.fromJson(e) : null)
          .whereType<ProductReviewModel>()
          .toList();
    }
  }
}

class ProductReviewModel {
  int? id;
  int? userId;
  int? productId;
  int? rating;
  String? text;
  String? createdAt;
  ReviewUserModel? user;

  ProductReviewModel({
    this.id,
    this.userId,
    this.productId,
    this.rating,
    this.text,
    this.createdAt,
    this.user,
  });

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  ProductReviewModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    userId = _toInt(json['user_id'] ?? json['userId']);
    productId = _toInt(json['product_id'] ?? json['productId']);
    rating = _toInt(json['rating']);
    text = json['text']?.toString();
    createdAt = (json['created_at'] ?? json['createdAt'])?.toString();
    final u = json['user'];
    if (u is Map<String, dynamic>) {
      user = ReviewUserModel.fromJson(u);
    }
  }
}

class ReviewUserModel {
  int? id;
  String? name;
  String? avatarUrl;

  ReviewUserModel({this.id, this.name, this.avatarUrl});

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  ReviewUserModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = json['name']?.toString();
    avatarUrl = (json['avatar_url'] ?? json['avatarUrl'])?.toString();
  }
}

