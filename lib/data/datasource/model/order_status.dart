import 'package:flutter/material.dart';

enum OrderStatusType {
  pending,
  accepted,
  rejected,
  delivered,
  unknown;

  static OrderStatusType fromApi(String? raw) {
    switch (raw?.toLowerCase().trim()) {
      case 'pending':
        return OrderStatusType.pending;
      case 'accepted':
        return OrderStatusType.accepted;
      case 'rejected':
        return OrderStatusType.rejected;
      case 'delivered':
        return OrderStatusType.delivered;
      default:
        return OrderStatusType.unknown;
    }
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
