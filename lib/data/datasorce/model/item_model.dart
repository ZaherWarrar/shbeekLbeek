class ItemModel {
  int? id;
  String? name;
  String? logoUrl;
  String? imageUrl;
  String? deliveryFee;
  String? minOrder;
  String? categoryName;
  double? rating;
  int? productsCount;

  ItemModel({
    this.id,
    this.name,
    this.logoUrl,
    this.imageUrl,
    this.deliveryFee,
    this.minOrder,
    this.categoryName,
    this.rating,
    this.productsCount,
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

  ItemModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = json['name']?.toString();
    logoUrl = json['logo_url']?.toString();
    imageUrl = json['image_url']?.toString();
    deliveryFee = json['delivery_fee']?.toString();
    minOrder = json['min_order']?.toString();
    categoryName = json['category_name']?.toString();
    rating = _toDouble(json['rating']);
    productsCount = _toInt(json['products_count']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['logo_url'] = logoUrl;
    data['image_url'] = imageUrl;
    data['delivery_fee'] = deliveryFee;
    data['min_order'] = minOrder;
    data['category_name'] = categoryName;
    data['rating'] = rating;
    data['products_count'] = productsCount;
    return data;
  }
}

class InnerCategory {
  int? id;
  String? name;
  String? description;

  InnerCategory({this.id, this.name, this.description});

  InnerCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name']?.toString();
    description = json['description']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    return data;
  }
}

class Products {
  int? id;
  String? name;
  String? imageUrl;

  /// دعم API الجديد: price قد يكون رقم أو نص
  dynamic price;

  /// دعم التوافق مع السلة الحالية
  int? regularPrice;
  int? salePrice;

  InnerCategory? innerCategory;

  Products({
    this.id,
    this.name,
    this.price,
    this.regularPrice,
    this.salePrice,
    this.imageUrl,
    this.innerCategory,
  });

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    regularPrice = json['regular_price'];
    salePrice = json['sale_price'];
    imageUrl = json['image_url'];
    price = json['price'];

    final ic = json['inner_category'];
    if (ic is Map<String, dynamic>) {
      innerCategory = InnerCategory.fromJson(ic);
    } else {
      innerCategory = null;
    }

    // إذا API الجديد يعطي price فقط، نخزنه كـ regularPrice ليتوافق مع السلة الحالية
    regularPrice ??= _parsePriceToInt(price);
  }

  static int? _parsePriceToInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    final s = value.toString();
    final d = double.tryParse(s);
    if (d != null) return d.toInt();
    return int.tryParse(s);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['regular_price'] = regularPrice;
    data['sale_price'] = salePrice;
    data['image_url'] = imageUrl;
    data['price'] = price;
    if (innerCategory != null) {
      data['inner_category'] = innerCategory!.toJson();
    }
    return data;
  }
}
