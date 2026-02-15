import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/services/session_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final session = Get.find<SessionService>();

    final cityId = session.cityId;

    // ❌ إذا ما اختار مدينة → روح لصفحة اختيار المدينة
    if (cityId == null) {
      return const RouteSettings(name: AppRoutes.chooseCity);
    }

    // ✅ إذا اختار مدينة → يدخل على الـ Home مباشرة
    return const RouteSettings(name: AppRoutes.home);
  }
}