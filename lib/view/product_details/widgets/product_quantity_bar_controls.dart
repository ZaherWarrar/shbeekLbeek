import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';

class ProductQuantityBarControls extends StatelessWidget {
  const ProductQuantityBarControls({
    super.key,
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onDecrease,
            icon: Icon(Icons.remove, color: AppColor().primaryColor),
          ),
          Text(
            '$quantity',
            style: TextStyle(
              color: AppColor().titleColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          IconButton(
            onPressed: onIncrease,
            icon: Icon(Icons.add, color: AppColor().primaryColor),
          ),
        ],
      ),
    );
  }
}
