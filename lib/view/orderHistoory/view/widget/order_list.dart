import 'package:app/core/shared/custom_refresh.dart';
import 'package:app/view/orderDetails/order_details_view.dart';
import 'package:app/view/orderHistoory/controller/order_his_controller.dart';
import 'package:app/view/orderHistoory/model/order_his_model.dart';
import 'package:app/view/orderHistoory/view/widget/order_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderList extends GetView<OrderHisController> {
  const OrderList({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderHisController>(
      builder: (controller) {
        final activeOrders = controller.orders
            .where((o) => o.status == OrderHisModel.statusActive)
            .toList();

        final completedOrders = controller.orders
            .where((o) => o.status != OrderHisModel.statusActive)
            .toList();

        final orders = [...activeOrders, ...completedOrders];

        return CustomRefresh(
          statusRequest: controller.orderState,
          fun: () => controller.fetchOrders(),
          body: orders.isEmpty
              ? SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: const Center(child: Text("لا يوجد طلبات بعد")),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Get.to(OrderDetailsView(orderId: index)),
                      child: OrderCard(order: orders[index], index: index),
                    );
                  },
                ),
        );
      },
    );
  }
}
