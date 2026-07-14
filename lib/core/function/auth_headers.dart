import 'package:app/core/services/session_service.dart';
import 'package:get/get.dart';

/// تجهيز هيدر الطلبات المحمية بـ Bearer token.
class AuthHeaders {
  AuthHeaders._();

  static SessionService get _session => Get.find<SessionService>();

  static bool get hasToken {
    final token = _session.token;
    return token != null && token.isNotEmpty;
  }

  static Map<String, String> build() {
    final token = _session.token;
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }
}
