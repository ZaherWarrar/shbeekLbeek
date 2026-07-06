import 'package:app/data/datasource/model/order_status.dart';
import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final OrderStatusType status;

  @override
  Widget build(BuildContext context) {
    final color = status.color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
