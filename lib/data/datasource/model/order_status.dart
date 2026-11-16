import 'package:flutter/material.dart';

enum OrderStatusType {
  pending,
  accepted,
  rejected,
  delivered,
  unknown;

  static OrderStatusType fromApi(String? raw) {
    final value = raw?.trim() ?? '';
    switch (value.toLowerCase()) {
      case 'pending':
      case 'new':
      case 'created':
      case 'waiting':
      case 'unconfirmed':
      case 'طلب جديد':
      case 'جديد':
        return OrderStatusType.pending;
      case 'accepted':
      case 'confirmed':
      case 'confirm':
      case 'processing':
      case 'preparing':
      case 'طلب مؤكد':
      case 'مؤكد':
      case 'قيد التنفيذ':
      case 'قيد التحضير':
        return OrderStatusType.accepted;
      case 'rejected':
      case 'canceled':
      case 'cancelled':
      case 'cancel':
      case 'طلب ملغي':
      case 'طلب ملغى':
      case 'ملغي':
      case 'ملغى':
        return OrderStatusType.rejected;
      case 'delivered':
      case 'completed':
      case 'complete':
      case 'done':
      case 'تم التوصيل':
      case 'تم التسليم':
      case 'مكتمل':
        return OrderStatusType.delivered;
      default:
        return OrderStatusType.unknown;
    }
  }

  /// حقل status غالباً يبقى pending. التأكيد والإلغاء يُكتبان داخل العنوان،
  /// والتوصيل يُعرف من delvierd_datetime.
  static OrderStatusType resolve({
    String? rawStatus,
    String? address,
    String? deliveredAt,
  }) {
    final fromField = fromApi(rawStatus);
    if (fromField == OrderStatusType.accepted ||
        fromField == OrderStatusType.rejected ||
        fromField == OrderStatusType.delivered) {
      return fromField;
    }

    final addressValue = address ?? '';
    if (addressValue.contains('طلب ملغي') ||
        addressValue.contains('طلب ملغى')) {
      return OrderStatusType.rejected;
    }

    final delivered = deliveredAt?.trim() ?? '';
    if (delivered.isNotEmpty && delivered.toLowerCase() != 'null') {
      return OrderStatusType.delivered;
    }

    if (addressValue.contains('طلب مؤكد')) {
      return OrderStatusType.accepted;
    }

    if (fromField == OrderStatusType.pending) {
      return OrderStatusType.pending;
    }
    return OrderStatusType.unknown;
  }

  String get label {
    switch (this) {
      case OrderStatusType.pending:
        return 'طلب جديد';
      case OrderStatusType.accepted:
        return 'قيد التنفيذ';
      case OrderStatusType.rejected:
        return 'طلب ملغي';
      case OrderStatusType.delivered:
        return 'تم التوصيل';
      case OrderStatusType.unknown:
        return 'غير معروف';
    }
  }

  Color get color {
    switch (this) {
      case OrderStatusType.pending:
        return Colors.blueGrey;
      case OrderStatusType.accepted:
        return Colors.orange;
      case OrderStatusType.rejected:
        return Colors.red;
      case OrderStatusType.delivered:
        return Colors.green;
      case OrderStatusType.unknown:
        return Colors.grey;
    }
  }

  IconData get icon {
    switch (this) {
      case OrderStatusType.pending:
        return Icons.fiber_new;
      case OrderStatusType.accepted:
        return Icons.access_time;
      case OrderStatusType.rejected:
        return Icons.cancel_outlined;
      case OrderStatusType.delivered:
        return Icons.check_circle;
      case OrderStatusType.unknown:
        return Icons.help_outline;
    }
  }

  bool get isInProgress =>
      this == OrderStatusType.pending || this == OrderStatusType.accepted;

  int get sortPriority {
    switch (this) {
      case OrderStatusType.pending:
        return 0;
      case OrderStatusType.accepted:
        return 1;
      case OrderStatusType.delivered:
        return 2;
      case OrderStatusType.rejected:
        return 3;
      case OrderStatusType.unknown:
        return 4;
    }
  }
}
