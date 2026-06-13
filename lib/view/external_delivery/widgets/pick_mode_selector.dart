import 'package:app/controller/external_delivery/external_delivery_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PickModeSelector extends StatelessWidget {
  const PickModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExternalDeliveryController>();

    return Obx(() {
      final mode = controller.pickMode.value;
      return Row(
        children: [
          Expanded(
            child: _ModeChip(
              label: 'من',
              isSelected: mode == PickMode.from,
              onTap: () => controller.setPickMode(PickMode.from),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _ModeChip(
              label: 'إلى',
              isSelected: mode == PickMode.to,
              onTap: () => controller.setPickMode(PickMode.to),
            ),
          ),
        ],
      );
    });
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColor().primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? AppColor().primaryColor
                : Colors.grey.shade300,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
