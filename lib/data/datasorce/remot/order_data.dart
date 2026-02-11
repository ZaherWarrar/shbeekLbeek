import 'package:app/core/class/crud.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/link_api.dart';
import 'package:get/get.dart';

class OrderData {
  final Crud crud;
  final SessionService session = Get.find<SessionService>();

  OrderData(this.crud);

  // ================================
  // تجهيز الهيدر مع التوكن
  // ================================
  Map<String, String> _getHeaders() {
    final token = session.token;

    final headers = <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }

    return headers;
  }

  // ================================
  // إنشاء طلب جديد
  // ================================
  Future<Object> createOrderData(Map<String, dynamic> orderData) async {
    final headers = _getHeaders();

    final response = await crud.postData(
      ApiLinks.createOrder,
      orderData,
      headers: headers,
    );

    return response.fold((l) => l, (r) => r);
  }

  // ================================
  // تأكيد الطلب
  // ================================
  Future<Object> confirmOrderData(int orderId) async {
    final headers = _getHeaders();

    final response = await crud.getData(
      "${ApiLinks.confirmOrder}/$orderId",
      {},
      headers: headers,
    );

    return response.fold((l) => l, (r) => r);
  }

  // ================================
  // إلغاء الطلب
  // ================================
  Future<Object> cancelOrderData(int orderId) async {
    final headers = _getHeaders();

    final response = await crud.getData(
      "${ApiLinks.cancelOrder}/$orderId",
      {},
      headers: headers,
    );

    return response.fold((l) => l, (r) => r);
  }
}