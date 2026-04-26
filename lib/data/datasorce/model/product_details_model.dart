class ProductDetailsModel {
  int? id;
  String? name;
  String? description;
  String? type;
  List<ProductVariationModel> variations = [];
  String? imageUrl;
  dynamic price;
  double? ratingValue;
  int? ratingCount;
  int? storeId;
  String? storeName;
  String? storeImageUrl;
  String? storeDeliveryFee;
  String? deliveryTime;
  List<String> categoryTree = [];

  ProductDetailsModel({
    this.id,
    this.name,
    this.description,
    this.type,
    this.imageUrl,
    this.price,
    this.ratingValue,
    this.ratingCount,
    this.storeId,
    this.storeName,
    this.storeImageUrl,
    this.storeDeliveryFee,
    this.deliveryTime,
  });

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static List<String> _toStringList(dynamic value) {
    if (value is List) {
      return value.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList();
    }
    return [];
  }

  int get priceInt {
    final v = price;
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.toInt();
    final d = double.tryParse(v.toString());
    if (d != null) return d.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = json['name']?.toString();
    description = json['description']?.toString();
    type = json['type']?.toString();
    imageUrl = json['image_url']?.toString();
    price = json['price'];
    ratingValue = _toDouble(json['rating_value'] ?? json['rating']);
    ratingCount = _toInt(json['rating_count']);
    storeId = _toInt(json['store_id'] ?? json['storeId']);
    storeName = (json['store_name'] ?? json['storeName'])?.toString();
    storeImageUrl = (json['store_image_url'] ??
            json['storeImageUrl'] ??
            json['store_image'] ??
            json['store_logo_url'] ??
            json['storeLogoUrl'])
        ?.toString();
    storeDeliveryFee =
        (json['store_delivery_fee'] ?? json['delivery_fee'] ?? json['storeDeliveryFee'])
            ?.toString();
    deliveryTime = json['delivery_time']?.toString();
    categoryTree = _toStringList(json['category_tree']);

    final v = json['variations'];
    if (v is List) {
      variations = v
          .map((e) => e is Map<String, dynamic> ? ProductVariationModel.fromJson(e) : null)
          .whereType<ProductVariationModel>()
          .toList();
    }
  }
}

class ProductVariationModel {
  int? id;
  String? name;

  ProductVariationModel({this.id, this.name});

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  ProductVariationModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = json['name']?.toString();
  }
}

class RecommendedProductModel {
  int? id;
  String? name;
  String? imageUrl;
  dynamic price;
  int? storeId;
  String? storeName;
  String? storeImageUrl;
  String? storeDeliveryFee;

  RecommendedProductModel({
    this.id,
    this.name,
    this.imageUrl,
    this.price,
    this.storeId,
    this.storeName,
    this.storeImageUrl,
    this.storeDeliveryFee,
  });

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  int get priceInt {
    final v = price;
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.toInt();
    final d = double.tryParse(v.toString());
    if (d != null) return d.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  RecommendedProductModel.fromJson(Map<String, dynamic> json) {
    // يدعم أكثر من شكل للـ API (id / product_id / product{id})
    final nested = json['product'];
    final nestedMap = nested is Map<String, dynamic>
        ? nested
        : nested is Map
            ? Map<String, dynamic>.from(nested)
            : <String, dynamic>{};

    id = _toInt(json['id'] ?? json['product_id'] ?? nestedMap['id']);
    name = (json['name'] ?? nestedMap['name'])?.toString();
    imageUrl = (json['image_url'] ?? nestedMap['image_url'])?.toString();
    price = json['price'] ?? nestedMap['price'];

    storeId = _toInt(json['store_id'] ?? nestedMap['store_id']);
    storeName = (json['store_name'] ?? nestedMap['store_name'])?.toString();
    storeImageUrl =
        (json['store_image_url'] ?? nestedMap['store_image_url'])?.toString();
    storeDeliveryFee =
        (json['store_delivery_fee'] ?? nestedMap['store_delivery_fee'])?.toString();
  }
}

