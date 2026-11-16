import 'package:app/core/class/crud.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/link_api.dart';
import 'package:get/get.dart';

class OrderRequestFailure {
  const OrderRequestFailure(this.status, {this.message});

  final StatusRequest status;
  final String? message;
}

/// أول رسالة تحقق من `errors`، وإلا `message` إذا لم تكن صفحة الخطأ العامة.
String? readOrderErrorMessage(dynamic body) {
  if (body is! Map) return null;

  final errors = body['errors'];
  if (errors is Map) {
    for (final value in errors.values) {
      if (value is List && value.isNotEmpty) {
        return _shortServerText(value.first.toString());
      }
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty) return _shortServerText(text);
    }
  }

  final message = body['message']?.toString().trim() ?? '';
  if (message.isEmpty || message == 'Server Error') return null;
  return _shortServerText(message);
}

String _shortServerText(String value) {
  final line = value.split('\n').first.trim();
  if (line.length <= 180) return line;
  return '${line.substring(0, 177)}...';
}

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


  // إنشاء طلب جديد — إرسال التوكن في الهيدر (Authorization: Bearer {token}) مطلوب من الـ API
  Future<Object> createOrderData(Map<String, dynamic> orderData) async {
    final headers =  _getHeaders();
    // التأكد من إرسال Authorization في الهيدر عند إنشاء الطلب
    if (!headers.containsKey("Authorization")) {
      return StatusRequest.unauthorized;
    }
    final response = await crud.postJson(
      ApiLinks.createOrder,
      orderData,
      headers: headers,
    );

    if (response.failure != null) {
      return OrderRequestFailure(
        response.failure!,
        message: readOrderErrorMessage(response.body),
      );
    }
    return response.body ?? StatusRequest.failure;
  }

  // ================================
  // تأكيد الطلب
  // ================================
  Future<Object> confirmOrderData(int orderId) async {
    final headers = _getHeaders();
    if (!headers.containsKey("Authorization")) {
      return StatusRequest.unauthorized;
    }

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
    if (!headers.containsKey("Authorization")) {
      return StatusRequest.unauthorized;
    }

    final response = await crud.getData(
      "${ApiLinks.cancelOrder}/$orderId",
      {},
      headers: headers,
    );

    return response.fold((l) => l, (r) => r);
  }


  Future<Object> myOrdersData() async {
    final headers = _getHeaders();
    if (!headers.containsKey("Authorization")) {
      return StatusRequest.unauthorized;
    }
    var response = await crud.getData(ApiLinks.myOrders, {}, headers: headers);
    return response.fold((l) => l, (r) => r);
  }
}
