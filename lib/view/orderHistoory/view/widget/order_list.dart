import 'package:app/view/orderHistoory/controller/order_his_controller.dart';
import 'package:app/view/orderHistoory/view/widget/order_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderList extends GetView<OrderHisController> {
  const OrderList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final activeOrders =
          controller.orders.where((o) => o.status == "نشط").toList();

      final completedOrders =
          controller.orders.where((o) => o.status != "نشط").toList();

      final orders = [...activeOrders, ...completedOrders];

      if (orders.isEmpty) {
        return const Center(
          child: Text("لا يوجد طلبات بعد"),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return OrderCard(order: orders[index], index: index);
        },
      );
    });
  }
}
