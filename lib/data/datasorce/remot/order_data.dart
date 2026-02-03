import 'package:app/core/class/crud.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/services/shaerd_preferances.dart';
import 'package:app/link_api.dart';

class OrderData {
  Crud crud;
  UserPreferences userPreferences = UserPreferences();

  OrderData(this.crud);

  // الحصول على headers مع Authorization token (مطلوب لإنشاء الطلب وجميع طلبات الطلبات)
  Future<Map<String, String>> _getHeaders() async {
    final token = await userPreferences.getToken();
    final headers = <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }
    return headers;
  }

  // إنشاء طلب جديد — إرسال التوكن في الهيدر (Authorization: Bearer {token}) مطلوب من الـ API
  Future<Object> createOrderData(Map<String, dynamic> orderData) async {
    final headers = await _getHeaders();
    // التأكد من إرسال Authorization في الهيدر عند إنشاء الطلب
    if (!headers.containsKey("Authorization")) {
      return StatusRequest.unauthorized;
    }
    var response = await crud.postData(
      ApiLinks.createOrder,
      orderData,
      headers: headers,
    );
    // fold: إذا كان Left (خطأ) يرجع StatusRequest، إذا كان Right (نجاح) يرجع البيانات
    return response.fold((l) => l, (r) => r);
  }

  // تأكيد الطلب
  Future<Object> confirmOrderData(int orderId) async {
    final headers = await _getHeaders();
    var response = await crud.getData(
      "${ApiLinks.confirmOrder}/$orderId",
      {},
      headers: headers,
    );
    return response.fold((l) => l, (r) => r);
  }

  // إلغاء الطلب
  Future<Object> cancelOrderData(int orderId) async {
    final headers = await _getHeaders();
    var response = await crud.getData(
      "${ApiLinks.cancelOrder}/$orderId",
      {},
      headers: headers,
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<Object> myOrdersData() async {
    final headers = await _getHeaders();
    var response = await crud.getData(ApiLinks.myOrders, {}, headers: headers);
    return response.fold((l) => l, (r) => r);
  }
}
