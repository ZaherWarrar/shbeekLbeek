import 'package:app/data/datasorce/model/item_model.dart';

class StoreModel {
  int? id;
  String? name;
  String? logoUrl;
  String? imageUrl;
  String? deliveryFee;
  String? minOrder;
  int? categoryId;
  String? categoryName;
  double? rating;
  int? productsCount;
  List<Products>? products;

  StoreModel({
    this.id,
    this.name,
    this.logoUrl,
    this.imageUrl,
    this.deliveryFee,
    this.minOrder,
    this.categoryId,
    this.categoryName,
    this.rating,
    this.productsCount,
    this.products,
  });

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  StoreModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = json['name']?.toString();
    logoUrl = json['logo_url']?.toString();
    imageUrl = json['image_url']?.toString();
    deliveryFee = json['delivery_fee']?.toString();
    minOrder = json['min_order']?.toString();
    categoryId = _toInt(json['category_id']);
    categoryName = json['category_name']?.toString();
    rating = _toDouble(json['rating']);
    productsCount = _toInt(json['products_count']);

    final p = json['products'];
    if (p is List) {
      products = p
          .map((e) => e is Map<String, dynamic> ? Products.fromJson(e) : null)
          .whereType<Products>()
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['logo_url'] = logoUrl;
    data['image_url'] = imageUrl;
    data['delivery_fee'] = deliveryFee;
    data['min_order'] = minOrder;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['rating'] = rating;
    data['products_count'] = productsCount;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

