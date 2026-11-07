import 'dart:async';

import 'package:app/controller/auth/otp/otp_sms_retriever.dart';
import 'package:app/controller/profile/account_controller.dart';
import 'package:app/core/constant/phone_auth_contract.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/function/handling_data.dart';
import 'package:app/controller/notifications/notifications_controller.dart';
import 'package:app/core/shared/notifications/notification_api.dart';
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
  late StatusRequest statusRequest;

  final pinController = TextEditingController();
  final smsRetriever = OtpSmsRetriever();

  final OtpData otpData = OtpData(Get.find());
  final session = Get.find<SessionService>();

  Timer? _resendTimer;

  bool get canResend =>
      PhoneAuthContract.resendConfirmed &&
      resendSecondsLeft.value == 0 &&
      !isResending.value &&
      !isLoading.value;

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
    super.onInit();
    _startResendCooldown();
  }

  Future<void> verifyOtp() async {
    if (isLoading.value) return;
    if (otpCode.value.length != 6) {
      otpCode.value = pinController.text;
    }
    if (otpCode.value.length != 6) {
      AppSnackbar.show("تنبيه", "الرجاء إدخال رمز التفعيل الكامل");
      return;
    }

    isLoading.value = true;

    try {
      final reply = await otpData.otpData(otpCode.value, phoneNumber);
      if (reply.failure != null) {
        AppSnackbar.show('تعذر التحقق', reply.failure!);
        return;
      }
      final response = reply.payload;
      statusRequest = reply.httpSucceeded
          ? StatusRequest.success
          : StatusRequest.failure;

      if (statusRequest == StatusRequest.success &&
          response is Map<String, dynamic>) {
        final token = response['token'];
        final userValue = response['user'];
        final userId = userValue is Map<String, dynamic>
            ? userValue['id']
            : null;
        final validId =
            (userId is int && userId > 0) ||
            (userId is String && userId.trim().isNotEmpty);
        if (token is! String ||
            token.trim().isEmpty ||
            userValue is! Map<String, dynamic> ||
            !validId ||
            response['success'] == false ||
            response['status'] == false ||
            response['error'] != null ||
            response['errors'] != null) {
          AppSnackbar.show('خطأ', 'استجابة التحقق لا تتضمن بيانات جلسة صالحة');
          return;
        }
        final user = Map<String, dynamic>.from(userValue);
        await session.saveLogin(token: token, userId: user['id'].toString());
        await session.acceptVerifiedUser(user);

        // ====== حفظ بيانات المستخدم ======
        if (response.containsKey('user')) {
          if (user['email'] is String) {
            await session.saveUserEmail(user['email']);
          }

          if (user['role'] is String) {
            await session.saveUserRole(user['role']);
          }

          if (user['status'] is String) {
            await session.saveUserStatus(user['status']);
          }
        }

        // المستخدم لم يعد ضيف
        await session.setGuest(false);

        if (Get.isRegistered<NotificationsController>()) {
          await Get.find<NotificationsController>().loadNotifications();
        }
        NotificationApi.syncDeviceToken();

        AppSnackbar.show('نجاح', 'تم التحقق بنجاح');
        if (await Get.find<AccountController>().ensureName()) {
          Get.offAllNamed(AppRoutes.start);
        }
      } else {
        AppSnackbar.show('فشل', 'تعذر التحقق من الرمز. لم يتم تسجيل الدخول.');
      }
    } catch (_) {
      AppSnackbar.show('خطأ', 'تعذر التحقق. أعد المحاولة.');
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() {
    Get.offAllNamed(AppRoutes.login);
  }

  Future<void> resendOtp() async {
    if (!canResend) return;
    if (!PhoneAuthContract.resendConfirmed) {
      AppSnackbar.show('تنبيه', 'إعادة إرسال الرمز غير متاحة حالياً.');
      return;
    }

    isResending.value = true;
    try {
      final response = await otpData.resendOtp(phoneNumber);
      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success) {
        AppSnackbar.show("21".tr, "22".tr);
        _startResendCooldown();
      } else if (statusRequest == StatusRequest.offlinefailure) {
        AppSnackbar.show('خطأ', 'لا يوجد اتصال بالإنترنت، تأكد من اتصالك');
      } else {
        AppSnackbar.show('فشل', 'تعذر إعادة إرسال الرمز، حاول مرة أخرى');
      }
    } catch (_) {
      AppSnackbar.show('خطأ', 'تعذر إرسال الرمز. أعد المحاولة لاحقاً.');
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
