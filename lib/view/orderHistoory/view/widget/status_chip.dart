import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final bool isActive;

  const StatusChip({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColor().primaryColor : Colors.green;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(
            isActive ? Icons.access_time : Icons.check_circle,
            size: 14,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            isActive ? "قيد التنفيذ" : "مكتمل",
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
