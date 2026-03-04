import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/function/handelingdata.dart';
import 'package:app/data/datasorce/remot/register_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class RegisterController extends GetxController {
  // ignore: strict_top_level_inference
  register();
  // ignore: strict_top_level_inference
  goToLogin();
  // ignore: strict_top_level_inference
  goToOtp();
}

class RegisterControllerImb extends RegisterController {
  // ================= Text form fields =================
  GlobalKey<FormState> formStat = GlobalKey<FormState>();
  late TextEditingController name;
  late TextEditingController phoneNumber;

  // ================= Privacy agreement =================
  bool isAgree = false;

  void toggleAgree(bool? value) {
    isAgree = value ?? false;
    update();
  }

  // ================= Data response =================
  RegisterData registerData = RegisterData(Get.find());
  StatusRequest statusRequest = StatusRequest.none;

  @override
  register() async {
    var formData = formStat.currentState;

    // ✅ تحقق من الفورم
    if (!(formData?.validate() ?? false)) {
      return;
    }

    // ✅ تحقق من الموافقة على سياسة الخصوصية
    if (!isAgree) {
      Get.snackbar(
        "تنبيه",
        "يجب الموافقة على سياسة الخصوصية أولاً",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    statusRequest = StatusRequest.loading;
    update();

    var response = await registerData.registerData(name.text, phoneNumber.text);

    statusRequest = handelingData(response);

    if (statusRequest == StatusRequest.success) {
      Get.offAllNamed(
        AppRoutes.otp,
        arguments: {"phone_number": phoneNumber.text},
      );
    } else {
      statusRequest = StatusRequest.failure;

      Get.defaultDialog(
        title: "فشل التسجيل",
        middleText: "حدث خطأ أثناء إنشاء الحساب، حاول مرة أخرى",
      );
    }

    update();
  }

  @override
  void onInit() {
    name = TextEditingController();
    phoneNumber = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    name.dispose();
    phoneNumber.dispose();
    super.dispose();
  }

  @override
  goToLogin() {
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  goToOtp() {
    Get.offAllNamed(AppRoutes.otp);
  }
}
