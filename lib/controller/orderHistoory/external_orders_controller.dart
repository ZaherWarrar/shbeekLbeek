import 'package:app/core/class/crud.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/function/handling_data.dart';
import 'package:app/data/datasource/model/external_order_model.dart';
import 'package:app/data/datasource/remot/external_orders_data.dart';
import 'package:get/get.dart';

class ExternalOrdersController extends GetxController {
  final ExternalOrdersData _data = ExternalOrdersData(Get.find<Crud>());

  StatusRequest orderState = StatusRequest.none;
  List<ExternalOrderModel> orders = [];

  Future<void> fetchOrders({bool requireAuth = false}) async {
    orderState = StatusRequest.loading;
    update();

    final result = await _data.fetchExternalOrders();
    final status = handlingData(result);

    if (status != StatusRequest.success || result is! List<ExternalOrderModel>) {
      orderState = result is StatusRequest ? result : StatusRequest.failure;
      orders = [];
      update();

      if (requireAuth && orderState == StatusRequest.unauthorized) {
        Get.snackbar('تنبيه', 'يجب تسجيل الدخول لعرض الطلبات الخارجية');
        Get.toNamed(AppRoutes.login);
      }
      return;
    }

    orders = result;
    orderState = StatusRequest.success;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }
}
