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
  // =================     Text form fild var    ===============================
  GlobalKey<FormState> formStat = GlobalKey<FormState>();
  late TextEditingController name;
  late TextEditingController phoneNumber;
  // =================     Data response var ===================================
  RegisterData registerData = RegisterData(Get.find());
  StatusRequest statusRequest = StatusRequest.none;
  @override
  register() async {
    update();
    var formData = formStat.currentState;
    // ==============       status valid =======================================
    if ((formData?.validate() ?? false)) {
      statusRequest = StatusRequest.loading;
      update();
      var response = await registerData.registerData(
        name.text,
        phoneNumber.text,
      );
      statusRequest = handelingData(response);

      if (StatusRequest.success == statusRequest) {
        Get.offAllNamed(
          AppRoutes.otp,
          arguments: {"phone_number": phoneNumber.text},
        );
      } else {
        statusRequest = StatusRequest.failure;
        Get.defaultDialog(
          title: "فشل تسجيل الدخول",
          content: Text("الحساب أو كلمة المرور غير صحيحان!"),
        );
      }
      update();
    }
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
