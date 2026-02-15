import 'package:app/core/class/crud.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/link_api.dart';
import 'package:get/get.dart';

class CouponsData {
  final Crud crud;
  final SessionService session = Get.find<SessionService>();

  CouponsData(this.crud);

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

  Future<Object> couponsData() async {
    var response = await crud.getData(
      ApiLinks.coupons,
      {},
      headers: _getHeaders(),
    );
    return response.fold((l) => l, (r) => r);
  }

  /// التحقق السريع من الكوبون (Check Coupon) — GET /api/coupons/check/{code}
  Future<Object> couponsCheckData(String code) async {
    final url = "${ApiLinks.couponCheck}$code";
    var response = await crud.getData(
      url,
      {},
      headers: _getHeaders(),
    );
    return response.fold((l) => l, (r) => r);
  }
}
