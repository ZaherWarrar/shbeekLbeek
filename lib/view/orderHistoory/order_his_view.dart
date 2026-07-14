import 'package:app/binding/order_history_binding.dart';
import 'package:app/controller/orderHistoory/order_history_tabs_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/view/orderHistoory/widget/external_order_list.dart';
import 'package:app/view/orderHistoory/widget/order_history_tabs.dart';
import 'package:app/view/orderHistoory/widget/order_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<OrderHistoryTabsController>()) {
      OrderHistoryBinding().dependencies();
    }

    final tabsController = Get.find<OrderHistoryTabsController>();

    return Scaffold(
      backgroundColor: AppColor().backgroundColor,
      appBar: AppBar(
        title: const Text(
          'سجل الطلبات',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: AppColor().backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColor().titleColor),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const OrderHistoryTabs(),
          Expanded(
            child: Obx(
              () => tabsController.selectedTab.value == 0
                  ? const OrderList()
                  : const ExternalOrderList(),
            ),
          ),
        ],
      ),
    );
  }
}
