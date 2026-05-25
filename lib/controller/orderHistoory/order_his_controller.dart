import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/function/handling_data.dart';
import 'package:app/data/datasource/remot/order_data.dart';
import 'package:app/data/datasource/model/order_his_model.dart';
import 'package:get/get.dart';

class OrderHisController extends GetxController {
  OrderData orderData = OrderData(Get.find());

  StatusRequest orderState = StatusRequest.none;
  List<OrderHisModel> orders = [];

  Future<void> fetchOrders() async {
    orderState = StatusRequest.loading;
    update();

    var response = await orderData.myOrdersData();
    orderState = handlingData(response);
    if (orderState == StatusRequest.success) {
      final orderList = _extractOrders(response);
      orders =
          orderList.map((item) => OrderHisModel.fromJson(item)).toList();
    } else {
      orders = [];
    }
    update();
  }

  List<Map<String, dynamic>> _extractOrders(dynamic response) {
    if (response is Map && response['orders'] is List) {
      return (response['orders'] as List)
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    if (response is List) {
      return response
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return [];
  }

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }
}
