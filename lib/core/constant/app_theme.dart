import 'package:flutter/material.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/main.dart';

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
            fontSize: w * 0.08,
            fontWeight: FontWeight.bold)));
ThemeData themeArabec = ThemeData(
    fontFamily: "Sukar",
    textTheme: TextTheme(titleLarge: TextStyle()),
    appBarTheme: AppBarTheme(
        foregroundColor: AppColor().backgroundColor,
        surfaceTintColor: AppColor().backgroundColor,
        backgroundColor: AppColor().backgroundColor,
        elevation: 0.0,
        titleTextStyle: TextStyle(
            fontFamily: "Sukar",
            color: AppColor().titleColor,
            fontSize: w * 0.08,
            fontWeight: FontWeight.bold)));
