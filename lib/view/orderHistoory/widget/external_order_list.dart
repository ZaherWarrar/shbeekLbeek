import 'package:app/controller/orderHistoory/external_orders_controller.dart';
import 'package:app/controller/orderHistoory/order_history_sort_utils.dart';
import 'package:app/core/shared/custom_refresh.dart';
import 'package:app/view/orderHistoory/widget/external_order_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExternalOrderList extends GetView<ExternalOrdersController> {
  const ExternalOrderList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExternalOrdersController>(
      builder: (controller) {
        final orders = sortOrdersByStatus(
          orders: controller.orders,
          statusOf: (order) => order.status,
          dateOf: (order) => order.createdAt,
        );

        return CustomRefresh(
          statusRequest: controller.orderState,
          fun: () => controller.fetchOrders(requireAuth: true),
          body: orders.isEmpty
              ? SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: const Center(child: Text('لا يوجد طلبات خارجية بعد')),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return ExternalOrderCard(order: orders[index]);
                  },
                ),
        );
      },
    );
  }
}
