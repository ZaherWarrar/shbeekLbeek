import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/phone_auth_contract.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/data/datasource/remot/login_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginControllerImb extends GetxController {
  final formStat = GlobalKey<FormState>();
  final phoneNumber = TextEditingController();
  final LoginData loginData = LoginData(Get.find());
  StatusRequest statusRequest = StatusRequest.none;
  bool agreed = false;
  String? error;

  String? validatePhone(String? value) {
    if (!RegExp(r'^09[0-9]{8}$').hasMatch(value?.trim() ?? '')) {
      return 'أدخل رقم هاتف صحيحاً من 10 أرقام يبدأ بـ 09';
    }
    return null;
  }

  void setAgreement(bool value) {
    agreed = value;
    error = null;
    update();
  }

  Future<void> login() async {
    if (statusRequest == StatusRequest.loading) return;
    if (!(formStat.currentState?.validate() ?? false)) return;
    if (!agreed) {
      error = 'يجب الموافقة على سياسة الخصوصية والشروط والأحكام';
      update();
      return;
    }
    if (!PhoneAuthContract.confirmed) {
      error = PhoneAuthContract.unavailableMessage;
      update();
      return;
    }
    statusRequest = StatusRequest.loading;
    error = null;
    update();
    try {
      final reply = await loginData.loginData(phoneNumber.text.trim());
      if (PhoneAuthContract.loginReplyConfirmed && reply.loginSucceeded) {
        Get.offAllNamed(
          AppRoutes.otp,
          arguments: {'phone_number': phoneNumber.text.trim()},
        );
      } else {
        error =
            reply.failure ??
            'تعذر إرسال الرمز. لم يؤكد الخادم إمكانية المتابعة بهذا الرقم.';
      }
    } catch (_) {
      error = 'تعذر إرسال الرمز. تحقق من الاتصال وأعد المحاولة.';
    } finally {
      statusRequest = StatusRequest.none;
      update();
    }
  }

  Future<void> continueAsGuest() async {
    if (statusRequest == StatusRequest.loading) return;
    await Get.find<SessionService>().setGuest(true);
    Get.offAllNamed(AppRoutes.start);
  }

  @override
  void onClose() {
    phoneNumber.dispose();
    super.onClose();
  }
}
