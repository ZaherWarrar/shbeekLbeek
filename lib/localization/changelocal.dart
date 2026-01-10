import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/core/constant/app_theme.dart';
import 'package:app/core/services/services.dart';

class Changelocal extends GetxController {
  Locale? language;
  MyServices myServices = Get.find();
  ThemeData appTheme = themeEnglish;
  // ignore: strict_top_level_inference
  changelang(String langcode) {
    Locale locale = Locale(langcode);
    appTheme = themeArabec;
    myServices.sharedPreferences.setString("language", langcode);
    Get.updateLocale(locale);
    Get.changeTheme(appTheme);
  }

  @override
  void onInit() {
    // فرض اللغة العربية و RTL بشكل دائم
    language = const Locale("ar");
    appTheme = themeArabec;
    // حفظ اللغة العربية في SharedPreferences
    myServices.sharedPreferences.setString("language", "ar");
    super.onInit();
  }
}
