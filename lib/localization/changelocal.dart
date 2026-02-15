import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/core/constant/app_theme.dart';
import 'package:app/core/services/session_service.dart';

class Changelocal extends GetxController {
  Locale? language;
  ThemeData appTheme = themeArabec;

  final session = Get.find<SessionService>();

  void changelang(String langcode) async {
    // حفظ اللغة في SessionService
    await session.saveLanguage(langcode);

    // تغيير اللغة في التطبيق
    language = Locale(langcode);
    appTheme = themeArabec;

    Get.updateLocale(language!);
    Get.changeTheme(appTheme);

    update();
  }

  @override
  void onInit() {
    super.onInit();

    // تحميل اللغة المحفوظة
    final savedLang = session.language ?? "ar";

    language = Locale(savedLang);
    appTheme = themeArabec;

    // إذا أول تشغيل وما في لغة محفوظة → نحفظ العربية
    session.saveLanguage(savedLang);

    update();
  }
}