import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/core/constant/app_theme.dart';
import 'package:app/core/services/services.dart';

class Changelocal extends GetxController {
  Locale? language;
  MyServices myServices = Get.find();
  ThemeData appTheme = themeEnglish;
  changelang(String langcode) {
    Locale locale = Locale(langcode);
    appTheme = langcode == "ar" ? themeArabec : themeEnglish;
    myServices.sharedPreferences.setString("language", langcode);
    Get.updateLocale(locale);
    Get.changeTheme(appTheme);
  }

  @override
  void onInit() {
    String? sharedPreLang = myServices.sharedPreferences.getString("language");
    if (sharedPreLang == "ar") {
      language = Locale("ar");
      appTheme = themeArabec;
    } else if (sharedPreLang == "en") {
      language = Locale("en");
      appTheme = themeEnglish;
    } else {
      final deviceLocaleCode = Get.deviceLocale?.languageCode ?? 'en';
      language = Locale(deviceLocaleCode);
      appTheme = deviceLocaleCode == 'ar' ? themeArabec : themeEnglish;
    }
    super.onInit();
  }
}
