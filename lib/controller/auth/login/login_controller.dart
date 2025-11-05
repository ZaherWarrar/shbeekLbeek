import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/function/handelingdata.dart';
import 'package:app/data/datasorce/remot/login_data.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

abstract class LoginController extends GetxController {
 dynamic  login();
  dynamic chingeshow();
  dynamic goRegister();
}

class LoginControllerImb extends LoginController {
  // =================     Text form fild var    ===============================
  GlobalKey<FormState> formStat = GlobalKey<FormState>();
  late TextEditingController email;
  late TextEditingController password;
  late TextEditingController phoneNumber;
  bool showpassword = true;
  // =================     Data response var ===================================
  LoginData loginData = LoginData(Get.find());
  StatusRequest? statusRequest;
  List data = [];
  // ================     login function =======================================
  @override
   login() async {
    var formData = formStat.currentState;
    // ==============       status valid =======================================
    if ((formData?.validate() ?? false)) {
      statusRequest = StatusRequest.loading;
      update();
      var response = await loginData.loginData(
        email.text,
        password.text,
        phoneNumber.text,
      );
      statusRequest = handelingData(response);

      if (StatusRequest.success == statusRequest) {
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

  // ===============   chinge status show password =============================
  @override
  chingeshow() {
    update();
    if (showpassword) {
      showpassword = false;
      update();
    } else {
      showpassword = true;
      update();
    }
  }

  @override
  goRegister() {
    Get.offAllNamed(AppRoutes.register);
  }

  // ===============  on init function =========================================
  @override
  void onInit() async {
    email = TextEditingController();
    password = TextEditingController();
    phoneNumber = TextEditingController();
    super.onInit();
  }

  //  =============   dispose function =========================================
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    phoneNumber.dispose();
    super.dispose();
  }
}
