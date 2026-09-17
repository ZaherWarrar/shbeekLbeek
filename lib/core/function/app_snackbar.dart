import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AppSnackbarKind { info, success, warning, error }

class AppSnackbar {
  AppSnackbar._();

  static String? _lastFingerprint;
  static DateTime? _lastShownAt;

  static const _debounce = Duration(milliseconds: 1400);
  static const _defaultDuration = Duration(milliseconds: 1600);

  static void show(
    String title,
    String message, {
    SnackPosition? snackPosition,
    Duration? duration,
    Color? backgroundColor,
    Color? colorText,
    EdgeInsets? margin,
    double? borderRadius,
  }) {
    _present(
      title: title,
      message: message,
      kind: _kindFromTitle(title),
      duration: duration,
      snackPosition: snackPosition,
      backgroundColor: backgroundColor,
      colorText: colorText,
      margin: margin,
      borderRadius: borderRadius,
    );
  }

  static void error(String message, {String title = 'خطأ'}) {
    _present(title: title, message: message, kind: AppSnackbarKind.error);
  }

  static void warning(String message, {String title = 'تنبيه'}) {
    _present(title: title, message: message, kind: AppSnackbarKind.warning);
  }

  static void success(String message, {String title = 'تم'}) {
    _present(title: title, message: message, kind: AppSnackbarKind.success);
  }

  static void _present({
    required String title,
    required String message,
    required AppSnackbarKind kind,
    Duration? duration,
    SnackPosition? snackPosition,
    Color? backgroundColor,
    Color? colorText,
    EdgeInsets? margin,
    double? borderRadius,
  }) {
    final fingerprint = '$title|$message';
    final now = DateTime.now();
    if (_lastFingerprint == fingerprint &&
        _lastShownAt != null &&
        now.difference(_lastShownAt!) < _debounce) {
      return;
    }
    _lastFingerprint = fingerprint;
    _lastShownAt = now;

    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }

    final colors = _colors(kind);
    final effectiveDuration = _clampDuration(duration ?? _defaultDuration);

    Get.showSnackbar(
      GetSnackBar(
        snackPosition: snackPosition ?? SnackPosition.TOP,
        duration: effectiveDuration,
        animationDuration: const Duration(milliseconds: 200),
        margin: margin ??
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        borderRadius: borderRadius ?? 12,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        backgroundColor: backgroundColor ?? colors.background,
        snackStyle: SnackStyle.FLOATING,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        overlayBlur: 0,
        overlayColor: Colors.transparent,
        shouldIconPulse: false,
        icon: Icon(_icon(kind), color: colorText ?? colors.foreground, size: 18),
        messageText: Text(
          message,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: colorText ?? colors.foreground,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            height: 1.25,
          ),
        ),
      ),
    );
  }

  static Duration _clampDuration(Duration duration) {
    const min = Duration(milliseconds: 900);
    const max = Duration(seconds: 3);
    if (duration < min) return min;
    if (duration > max) return max;
    return duration;
  }

  static AppSnackbarKind _kindFromTitle(String title) {
    if (title.contains('خطأ') || title.contains('فشل')) {
      return AppSnackbarKind.error;
    }
    if (title.contains('نجاح') ||
        title.contains('تم') ||
        title.contains('تسجيل الخروج')) {
      return AppSnackbarKind.success;
    }
    return AppSnackbarKind.warning;
  }

  static IconData _icon(AppSnackbarKind kind) {
    switch (kind) {
      case AppSnackbarKind.error:
        return Icons.error_outline;
      case AppSnackbarKind.success:
        return Icons.check_circle_outline;
      case AppSnackbarKind.warning:
        return Icons.info_outline;
      case AppSnackbarKind.info:
        return Icons.info_outline;
    }
  }

  static _SnackColors _colors(AppSnackbarKind kind) {
    switch (kind) {
      case AppSnackbarKind.error:
        return const _SnackColors(Color(0xE0C62828), Colors.white);
      case AppSnackbarKind.success:
        return const _SnackColors(Color(0xE02E7D32), Colors.white);
      case AppSnackbarKind.warning:
        return const _SnackColors(Color(0xE0EF6C00), Colors.white);
      case AppSnackbarKind.info:
        return const _SnackColors(Color(0xE0333333), Colors.white);
    }
  }
}

class _SnackColors {
  const _SnackColors(this.background, this.foreground);
  final Color background;
  final Color foreground;
}
