import 'dart:async';

import 'package:app/controller/auth/otp/otp_sms_retriever.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/function/handling_data.dart';
import 'package:app/controller/notifications/notifications_controller.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/data/datasource/remot/otp_data.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:app/core/function/app_snackbar.dart';

class OtpController extends GetxController {
  static const int resendCooldownSeconds = 60;

  var otpCode = ''.obs;

  /// حالة التحميل للزر
  var isLoading = false.obs;
  final isResending = false.obs;
  final resendSecondsLeft = resendCooldownSeconds.obs;

  late String phoneNumber;
  String userName = '';
  late StatusRequest statusRequest;

  final pinController = TextEditingController();
  final smsRetriever = OtpSmsRetriever();

  final OtpData otpData = OtpData(Get.find());
  final session = Get.find<SessionService>();

  Timer? _resendTimer;

  bool get canResend =>
      resendSecondsLeft.value == 0 && !isResending.value && !isLoading.value;

  String get resendCountdownText {
    final minutes = resendSecondsLeft.value ~/ 60;
    final seconds = resendSecondsLeft.value % 60;
    final time = '$minutes:${seconds.toString().padLeft(2, '0')}';
    return '24'.trParams({'time': time});
  }

  @override
  void onInit() {
    final args = Get.arguments as Map?;
    phoneNumber = args?['phone_number']?.toString() ?? '';
    userName = args?['name']?.toString() ?? '';
    super.onInit();
    _startResendCooldown();
  }

  Future<void> verifyOtp() async {
    if (otpCode.value.length != 6) {
      otpCode.value = pinController.text;
    }
    if (otpCode.value.length != 6) {
      AppSnackbar.show("تنبيه", "الرجاء إدخال رمز التفعيل الكامل");
      return;
    }

    isLoading.value = true;

    try {
      final response = await otpData.otpData(otpCode.value, phoneNumber);
      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success &&
          response is Map<String, dynamic>) {
        // ====== حفظ التوكن ======
        if (response.containsKey('token')) {
          await session.saveLogin(
            token: response['token'].toString(),
            userId: response['user']['id'].toString(),
          );
        }

        // ====== حفظ بيانات المستخدم ======
        if (response.containsKey('user')) {
          final user = response['user'] as Map<String, dynamic>;

          if (user.containsKey('name')) {
            await session.saveUserName(user['name']);
          }

          if (user.containsKey('email')) {
            await session.saveUserEmail(user['email']);
          }

          if (user.containsKey('role')) {
            await session.saveUserRole(user['role']);
          }

          if (user.containsKey('status')) {
            await session.saveUserStatus(user['status']);
          }
        }

        // المستخدم لم يعد ضيف
        await session.setGuest(false);

        if (Get.isRegistered<NotificationsController>()) {
          await Get.find<NotificationsController>().loadNotifications();
        }

        AppSnackbar.show('نجاح', 'تم التحقق بنجاح');
        Get.offAllNamed(AppRoutes.start);
      } else {
        AppSnackbar.show('فشل', 'رمز غير صالح');
      }
    } catch (e) {
      AppSnackbar.show('خطأ', 'حدث خطأ غير معروف: ${e.toString()}');
    }

    isLoading.value = false;
  }

  Future<void> resendOtp() async {
    if (!canResend) return;

    isResending.value = true;
    try {
      final response = await otpData.resendOtp(
        phoneNumber,
        name: userName,
      );
      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success) {
        AppSnackbar.show("21".tr, "22".tr);
        _startResendCooldown();
      } else if (statusRequest == StatusRequest.offlinefailure) {
        AppSnackbar.show('خطأ', 'لا يوجد اتصال بالإنترنت، تأكد من اتصالك');
      } else {
        AppSnackbar.show('فشل', 'تعذر إعادة إرسال الرمز، حاول مرة أخرى');
      }
    } catch (e) {
      AppSnackbar.show('خطأ', 'حدث خطأ غير معروف: ${e.toString()}');
    } finally {
      isResending.value = false;
    }
  }

  void _startResendCooldown() {
    _resendTimer?.cancel();
    resendSecondsLeft.value = resendCooldownSeconds;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSecondsLeft.value <= 1) {
        resendSecondsLeft.value = 0;
        timer.cancel();
        _resendTimer = null;
        return;
      }
      resendSecondsLeft.value--;
    });
  }

  @override
  void onClose() {
    _resendTimer?.cancel();
    _resendTimer = null;
    pinController.dispose();
    smsRetriever.dispose();
    super.onClose();
  }
}
