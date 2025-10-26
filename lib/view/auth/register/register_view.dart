import 'package:app/controller/auth/register/register_controller.dart';
import 'package:app/view/auth/register/widgets/go_to_login.dart';
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
import 'package:app/main.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RegisterControllerImb());
    return Scaffold(
      backgroundColor: AppColor().backgroundColor,
      appBar: CustomAppBar(title: "15".tr),
      body: GetBuilder<RegisterControllerImb>(
        builder: (controller) {
          if (controller.statusRequest == StatusRequest.loading) {
            return Center(
              child: Lottie.asset(Assets.imagesLoding, width: 100, height: 100),
            );
          }
          return Container(
            padding: EdgeInsets.only(
              top: h * 0.05,
              left: w * 0.05,
              right: w * 0.05,
            ),
            color: AppColor().backgroundColor,
            height: h,
            width: w,
            child: Form(
              key: controller.formStat,
              child: ListView(
                children: [
                  SizedBox(
                    height: h * 0.2,
                    width: w * 0.05,
                    child: Image.asset(Assets.imagesLogo, fit: BoxFit.contain),
                  ),
                  SizedBox(height: h * 0.05),
                  CustomTextFormFild(
                    hint: "2".tr,
                    controller: controller.name,
                    valid: (val) {
                      return validTextForm(val ?? '', "name", 100, 3);
                    },
                    lable: "3".tr,
                    iconData: Icons.email_outlined,
                    scure: false,
                  ),

                  SizedBox(height: h * 0.05),
                  CustomTextFormFild(
                    hint: "10".tr,
                    controller: controller.phoneNumber,
                    valid: (val) {
                      return validTextForm(val ?? '', "num", 100, 3);
                    },
                    lable: "11".tr,
                    iconData: Icons.phone_outlined,
                    scure: false,
                  ),
                  SizedBox(height: 15),
                  GoToLogin(onTap: () => controller.goToLogin()),

                  SizedBox(height: h * 0.05),
                  CustomButton(
                    hi: h * 0.05,
                    we: w * 0.2,
                    fontsize: 25,
                    padding: 10,
                    title: "16".tr,
                    onTap: () => controller.goToOtp(),
                    //controller.register(),
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
