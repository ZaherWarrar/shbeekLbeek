import 'package:flutter/material.dart';
import 'package:app/core/constant/app_color.dart';

/// الثيم الإنجليزي
ThemeData themeEnglish = ThemeData(
  fontFamily: "swisscki",
  appBarTheme: AppBarTheme(
    foregroundColor: AppColor().backgroundColor,
    surfaceTintColor: AppColor().backgroundColor,
    backgroundColor: AppColor().backgroundColor,
    elevation: 0.0,
    titleTextStyle: TextStyle(
      fontFamily: "swisscki",
      color: AppColor().titleColor,
      fontSize: 22, // ثابت بدل w * 0.08
      fontWeight: FontWeight.bold,
    ),
  ),
);

/// الثيم العربي
ThemeData themeArabec = ThemeData(
  fontFamily: "Sukar",
  textTheme: const TextTheme(
    titleLarge: TextStyle(),
  ),
  appBarTheme: AppBarTheme(
    foregroundColor: AppColor().backgroundColor,
    surfaceTintColor: AppColor().backgroundColor,
    backgroundColor: AppColor().backgroundColor,
    elevation: 0.0,
    titleTextStyle: TextStyle(
      fontFamily: "Sukar",
      color: AppColor().titleColor,
      fontSize: 22, // ثابت بدل w * 0.08
      fontWeight: FontWeight.bold,
    ),
  ),
);