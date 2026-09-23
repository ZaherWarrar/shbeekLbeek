import 'package:app/core/function/resolve_media_url.dart';
import 'package:app/data/datasource/model/order_status.dart';

class OrderHisModel {
  int? id;
  int? userId;
  String? phoneNumber;
  String? address;
  String? addressDescription;
  String? discount;
  String? createdAt;
  String? updatedAt;
  int? deliveryId;
  String? delvierdDatetime;
  double? latitude;
  double? longitude;
  List<OrderItemModel>? items;
  
  String? restaurantName;
  OrderStatusType status = OrderStatusType.unknown;
  DateTime? date;
  double? total;

  OrderHisModel({
    this.id,
    this.userId,
    this.phoneNumber,
    this.address,
    this.addressDescription,
    this.discount,
    this.createdAt,
    this.updatedAt,
    this.deliveryId,
    this.delvierdDatetime,
    this.latitude,
    this.longitude,
    this.items,
    this.restaurantName,
    this.status = OrderStatusType.unknown,
    this.date,
    this.total,
  });

  OrderHisModel.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    userId = _toInt(json['user_id']);
    phoneNumber = json['phone_number'];
    address = json['address'];
    addressDescription = json['address_description'];
    discount = json['discount']?.toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deliveryId = _toInt(json['delivery_id']);
    delvierdDatetime = json['delvierd_datetime']?.toString();
    latitude = _toDouble(json['latitude']);
    longitude = _toDouble(json['longitude']);
    if (json['items'] != null) {
      items = <OrderItemModel>[];
      json['items'].forEach((v) {
        items!.add(OrderItemModel.fromJson(v));
      });
    }
    total = _calculateTotal(items);
    restaurantName = _firstProductName(items) ?? _buildFallbackName(id);
    status = OrderStatusType.fromApi(json['status']?.toString());
    date = _parseDate(createdAt) ?? _parseDate(updatedAt);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['phone_number'] = phoneNumber;
    data['address'] = address;
    data['address_description'] = addressDescription;
    data['discount'] = discount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['delivery_id'] = deliveryId;
    data['delvierd_datetime'] = delvierdDatetime;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  static double _calculateTotal(List<OrderItemModel>? items) {
    if (items == null || items.isEmpty) return 0;
    double total = 0;
    for (final item in items) {
      final price = double.tryParse(item.singlePrice ?? '0') ?? 0;
      final qty = item.quantity ?? 0;
      total += price * qty;
    }
    return total;
  }

  static String? _firstProductName(List<OrderItemModel>? items) {
    if (items == null) return null;
    for (final item in items) {
      final name = item.product?.name;
      if (name != null && name.trim().isNotEmpty) {
        return name;
      }
    }
    return null;
  }

  static String _buildFallbackName(int? id) {
    if (id == null || id == 0) {
      return 'طلب';
    }
    return 'طلب #$id';
  }

  static DateTime? _parseDate(String? value) {
    if (value == null) return null;
    return DateTime.tryParse(value);
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }
}

class OrderItemModel {
  int? id;
  int? orderId;
  int? productId;
  String? singlePrice;
  int? quantity;
  String? createdAt;
  String? updatedAt;
  OrderProductModel? product;

  OrderItemModel({
    this.id,
    this.orderId,
    this.productId,
    this.singlePrice,
    this.quantity,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  OrderItemModel.fromJson(Map<String, dynamic> json) {
    id = OrderHisModel._toInt(json['id']);
    orderId = OrderHisModel._toInt(json['order_id']);
    productId = OrderHisModel._toInt(json['product_id']);
    singlePrice = json['single_price']?.toString();
    quantity = OrderHisModel._toInt(json['quantity']);
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product = json['product'] != null
        ? OrderProductModel.fromJson(json['product'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['product_id'] = productId;
    data['single_price'] = singlePrice;
    data['quantity'] = quantity;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

class OrderProductModel {
  int? id;
  int? categoryId;
  int? storeId;
  String? name;
  String? description;
  String? imageFilePath;
  int? regularPrice;
  int? salePrice;
  String? saleStart;
  String? saleEnd;
  String? createdAt;
  String? updatedAt;
  String? imageUrl;

  OrderProductModel({
    this.id,
    this.categoryId,
    this.storeId,
    this.name,
    this.description,
    this.imageFilePath,
    this.regularPrice,
    this.salePrice,
    this.saleStart,
    this.saleEnd,
    this.createdAt,
    this.updatedAt,
    this.imageUrl,
  });

  OrderProductModel.fromJson(Map<String, dynamic> json) {
    id = OrderHisModel._toInt(json['id']);
    categoryId = OrderHisModel._toInt(json['category_id']);
    storeId = OrderHisModel._toInt(json['store_id']);
    name = json['name'];
    description = json['description'];
    imageFilePath = json['image_file_path'];
    regularPrice = OrderHisModel._toInt(json['regular_price']);
    salePrice = OrderHisModel._toInt(json['sale_price']);
    saleStart = json['sale_start']?.toString();
    saleEnd = json['sale_end']?.toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageUrl = resolveMediaUrl(json['image_url']?.toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['store_id'] = storeId;
    data['name'] = name;
    data['description'] = description;
    data['image_file_path'] = imageFilePath;
    data['regular_price'] = regularPrice;
    data['sale_price'] = salePrice;
    data['sale_start'] = saleStart;
    data['sale_end'] = saleEnd;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['image_url'] = imageUrl;
    return data;
  }
}
