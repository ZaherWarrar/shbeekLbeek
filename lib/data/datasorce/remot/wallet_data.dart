import 'package:app/core/class/crud.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/link_api.dart';
import 'package:get/get.dart';

class WalletData {
  final Crud crud;
  final SessionService session = Get.find<SessionService>();

  WalletData(this.crud);

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

  Future<Object> fetchBalance() async {
    final headers = _getHeaders();
    if (!headers.containsKey("Authorization")) {
      return StatusRequest.unauthorized;
    }
    final response = await crud.getData(
      ApiLinks.userBalance,
      {},
      headers: headers,
    );
    return response.fold((l) => l, (r) => r);
  }
}

