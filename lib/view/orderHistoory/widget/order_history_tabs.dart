import 'package:app/controller/orderHistoory/order_history_tabs_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderHistoryTabs extends StatelessWidget {
  const OrderHistoryTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderHistoryTabsController>();

    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: _TabItem(
                label: 'طلبات داخلية',
                isSelected: controller.selectedTab.value == 0,
                onTap: () => controller.changeTab(0),
              ),
            ),
            Expanded(
              child: _TabItem(
                label: 'طلبات خارجية',
                isSelected: controller.selectedTab.value == 1,
                onTap: () => controller.changeTab(1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
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
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? AppColor().titleColor : Colors.grey,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 3,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isSelected ? AppColor().primaryColor : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
