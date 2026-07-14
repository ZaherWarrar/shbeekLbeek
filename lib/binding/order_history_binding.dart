import 'package:app/controller/orderHistoory/external_orders_controller.dart';
import 'package:app/controller/orderHistoory/order_his_controller.dart';
import 'package:app/controller/orderHistoory/order_history_tabs_controller.dart';
import 'package:get/get.dart';

class OrderHistoryBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<OrderHistoryTabsController>()) {
      Get.put(OrderHistoryTabsController());
    }
    if (!Get.isRegistered<OrderHisController>()) {
      Get.put(OrderHisController());
    }
    if (!Get.isRegistered<ExternalOrdersController>()) {
      Get.put(ExternalOrdersController());
    }
  }
}
