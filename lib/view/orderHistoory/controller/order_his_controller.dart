import 'package:app/view/orderHistoory/model/order_his_model.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class OrderHisController extends GetxController {
  RxList<OrderHisModel> orders = <OrderHisModel>[].obs;

  void fetchOrders() async {
    // هنا يتم جلب البيانات من الـ backend
    orders.value = [
      OrderHisModel(restaurantName: "ماكدونالدز", status: "مكتمل", date: DateTime.now(), total: 45.0),
      OrderHisModel(restaurantName: "البيك", status: "نشط", date: DateTime.now(), total: 60.0),
    ];
  }
}