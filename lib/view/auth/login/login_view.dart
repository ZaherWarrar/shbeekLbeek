import 'package:app/controller/auth/login/login_controller.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/view/auth/login/widgets/go_to_register.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/constant/app_images.dart';
import 'package:app/core/function/valid_function.dart';
import 'package:app/core/shared/custom_app_bar.dart';
import 'package:app/core/shared/custom_button.dart';
import 'package:app/core/shared/custom_text_form_fild.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    if (Get.isRegistered<LoginControllerImb>()) {
      Get.delete<LoginControllerImb>();
    }
    Get.put(LoginControllerImb());
    
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: AppColor().backgroundColor,
      appBar: CustomAppBar(title: "1".tr),
      body: GetBuilder<LoginControllerImb>(
        builder: (controller) {
          if (controller.statusRequest == StatusRequest.loading) {
            return Center(
              child: Lottie.asset(Assets.imagesLoding, width: 100, height: 100),
            );
          }
          return Container(
            padding: EdgeInsets.only(
              top: screenHeight * 0.05,
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
            ),
            color: AppColor().backgroundColor,
            child: Form(
              key: controller.formStat,
              child: ListView(
                children: [
                  SizedBox(
                    height: screenHeight * 0.2,
                    width: screenWidth * 0.5,
                    child: Image.asset(Assets.imagesLogo, fit: BoxFit.contain),
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  CustomTextFormFild(
                    hint: "2".tr,
                    controller: controller.email,
                    valid: (val) {
                      return validTextForm(val ?? '', "email", 100, 3);
                    },
                    lable: "3".tr,
                    iconData: Icons.email_outlined,
                    scure: false,
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  CustomTextFormFild(
                    hint: "10".tr,
                    controller: controller.phoneNumber,
                    valid: (val) {
                      return validTextForm(val ?? '', "name", 100, 3);
                    },
                    lable: "11".tr,
                    iconData: Icons.email_outlined,
                    scure: false,
                  ),
                  SizedBox(height: screenHeight * 0.05),
                  GetBuilder<LoginControllerImb>(
                    builder: (controller) => CustomTextFormFild(
                      hint: "5".tr,
                      controller: controller.password,
                      valid: (val) {
                        return validTextForm(val ?? '', "password", 30, 5);
                      },
                      lable: '4'.tr,
                      iconData: Icons.lock_outline,
                      scure: controller.showpassword,
                      onTap: () => controller.chingeshow(),
                    ),
                  ),
                  SizedBox(height: 15),
                  GoToRegister(onTap: () => controller.goRegister()),

                  SizedBox(height: screenHeight * 0.05),
                  CustomButton(
                    hi: screenHeight * 0.05,
                    we: screenWidth * 0.2,
                    fontsize: 25,
                    padding: 10,
                    title: "1".tr,
                    onTap: () async {
                      await controller.login();
                    },
                  ),

                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    color: Colors.grey,
                    child: Text("الدخول كضيف"),
                    onPressed: () {
                      Get.toNamed(AppRoutes.chooseCity);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}