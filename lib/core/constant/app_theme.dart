import 'package:flutter/material.dart';
import 'package:app/core/constant/app_color.dart';

ThemeData _buildAppTheme({
  required String fontFamily,
  TextTheme? textTheme,
}) {
  final colors = AppColor();
  final colorScheme = ColorScheme.fromSeed(
    seedColor: colors.primaryColor,
    brightness: Brightness.light,
    primary: colors.primaryColor,
    onPrimary: colors.textButomColor,
    secondary: colors.primaryColor,
    onSecondary: colors.textButomColor,
    surface: colors.backgroundColorCard,
    onSurface: colors.titleColor,
  );

  return ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colors.backgroundColor,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      foregroundColor: colors.backgroundColor,
      surfaceTintColor: colors.backgroundColor,
      backgroundColor: colors.backgroundColor,
      elevation: 0.0,
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
        color: colors.titleColor,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: colors.backgroundColorCard,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
        color: colors.titleColor,
        fontWeight: FontWeight.w700,
        fontSize: 18,
      ),
      contentTextStyle: TextStyle(
        fontFamily: fontFamily,
        color: colors.descriptionColor,
        fontSize: 14,
        height: 1.45,
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colors.primaryColor,
        textStyle: TextStyle(
          fontFamily: fontFamily,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primaryColor,
        foregroundColor: colors.textButomColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
  );
}

/// الثيم الإنجليزي
ThemeData themeEnglish = _buildAppTheme(fontFamily: 'swisscki');

/// الثيم العربي
ThemeData themeArabec = _buildAppTheme(
  fontFamily: 'Sukar',
  textTheme: const TextTheme(titleLarge: TextStyle()),
);
