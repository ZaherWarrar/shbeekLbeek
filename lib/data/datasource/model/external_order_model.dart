import 'package:app/data/datasource/model/order_status.dart';

class ExternalOrderModel {
  final int id;
  final int? userId;
  final double fromLat;
  final double fromLng;
  final double toLat;
  final double toLng;
  final String fromAddressDetails;
  final String toAddressDetails;
  final String orderDetails;
  final double? totalPrice;
  final OrderStatusType status;
  final DateTime? createdAt;

  const ExternalOrderModel({
    required this.id,
    this.userId,
    required this.fromLat,
    required this.fromLng,
    required this.toLat,
    required this.toLng,
    required this.fromAddressDetails,
    required this.toAddressDetails,
    required this.orderDetails,
    this.totalPrice,
    this.status = OrderStatusType.unknown,
    this.createdAt,
  });

  factory ExternalOrderModel.fromJson(Map<String, dynamic> json) {
    return ExternalOrderModel(
      id: _toInt(json['id']) ?? 0,
      userId: _toInt(json['user_id']),
      fromLat: _toDouble(json['from_lat']) ?? 0,
      fromLng: _toDouble(json['from_lng']) ?? 0,
      toLat: _toDouble(json['to_lat']) ?? 0,
      toLng: _toDouble(json['to_lng']) ?? 0,
      fromAddressDetails: json['from_address_details']?.toString() ?? '',
      toAddressDetails: json['to_address_details']?.toString() ?? '',
      orderDetails: json['order_details']?.toString() ?? '',
      totalPrice: _toDouble(json['total_price']),
      status: OrderStatusType.fromApi(json['status']?.toString()),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }

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
}
