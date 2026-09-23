import 'package:app/controller/auth/register/register_controller.dart';
import 'package:app/view/auth/register/widgets/go_to_login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/core/function/app_snackbar.dart';
import 'package:lottie/lottie.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/constant/app_images.dart';
import 'package:app/core/shared/custom_app_bar.dart';
import 'package:app/core/shared/custom_button.dart';
import 'package:app/core/shared/custom_text_form_fild.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    if (Get.isRegistered<RegisterControllerImb>()) {
      Get.delete<RegisterControllerImb>();
    }
    Get.put(RegisterControllerImb());
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
              top: screenHeight * 0.05,
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
            ),
            color: AppColor().backgroundColor,
            height: screenHeight,
            width: screenWidth,
            child: Form(
              key: controller.formStat,
              child: ListView(
                children: [
                  SizedBox(
                    height: screenHeight * 0.2,
                    child: Image.asset(Assets.imagesLogo, fit: BoxFit.contain),
                  ),

                  SizedBox(height: screenHeight * 0.05),

                  // ✅ حقل الاسم مع Validation فوري
                  CustomTextFormFild(
                    hint: "2".tr,
                    controller: controller.name,
                    valid: controller.validateName,
                    lable: "3".tr,
                    iconData: Icons.person_outline,
                    scure: false,
                    onChanged: (value) {
                      controller.validateNameOnChange(value ?? '');
                    },
                    errorText: controller.nameError.value.isNotEmpty
                        ? controller.nameError.value
                        : null,
                    maxLength: 50,
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // ✅ حقل رقم الهاتف مع Validation فوري
                  CustomTextFormFild(
                    hint: "10".tr,
                    controller: controller.phoneNumber,
                    valid: controller.validatePhone,
                    lable: "11".tr,
                    iconData: Icons.phone_outlined,
                    scure: false,
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      controller.validatePhoneOnChange(value ?? '');
                    },
                    errorText: controller.phoneError.value.isNotEmpty
                        ? controller.phoneError.value
                        : null,
                    maxLength: 10,
                  ),

                  SizedBox(height: 8),

                  // ✅ نص مساعد لتوضيح صيغة الرقم المطلوبة
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "📱 رقم هاتف سوري يبدأ بـ 09 (مثال: 0991234567)",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),

                  SizedBox(height: 18),

                  GoToLogin(onTap: () => controller.goToLogin()),

                  SizedBox(height: screenHeight * 0.03),

                  // ✅ Checkbox الموافقة على سياسة الخصوصية
                  CheckboxListTile(
                    value: controller.isAgree,
                    activeColor: AppColor().primaryColor,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    onChanged: controller.toggleAgree,
                    title: Text.rich(
                      TextSpan(
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                        children: [
                          const TextSpan(text: "أوافق على "),
                          TextSpan(
                            text: "الشروط والأحكام",
                            style: TextStyle(
                              color: AppColor().primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.toNamed("/terms");
                              },
                          ),
                          const TextSpan(text: " و "),
                          TextSpan(
                            text: "سياسة الخصوصية",
                            style: TextStyle(
                              color: AppColor().primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.toNamed("/privacy");
                              },
                          ),
                        ],
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),

                  // ✅ عرض رسالة خطأ إذا لم يوافق على الشروط
                  if (!controller.isAgree && controller.showAgreeError.value)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, right: 12),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "⚠️ يجب الموافقة على الشروط والأحكام",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                    ),

                  SizedBox(height: screenHeight * 0.02),

                  // ✅ زر التسجيل مع دعم isEnabled و showLoading
                  CustomButton(
                    hi: screenHeight * 0.05,
                    we: screenWidth * 0.8,
                    fontsize: 25,
                    padding: 10,
                    title: "16".tr,
                    isEnabled: controller.isFormValid(),
                    showLoading:
                        controller.statusRequest == StatusRequest.loading,
                    onTap: () {
                      // ✅ التحقق من صحة النموذج
                      if (!controller.formStat.currentState!.validate()) {
                        AppSnackbar.show(
                          "تنبيه",
                          "يرجى تصحيح الأخطاء في الحقول",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.orange.shade100,
                          colorText: Colors.orange.shade900,
                          duration: const Duration(seconds: 3),
                        );
                        return;
                      }

                      // ✅ التحقق من الموافقة على الشروط
                      if (!controller.isAgree) {
                        controller.showAgreeError.value = true;
                        controller.update();
                        AppSnackbar.show(
                          "تنبيه",
                          "يجب الموافقة على سياسة الخصوصية أولاً",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.orange.shade100,
                          colorText: Colors.orange.shade900,
                          duration: const Duration(seconds: 3),
                        );
                        return;
                      }

                      // ✅ إخفاء خطأ الموافقة
                      controller.showAgreeError.value = false;
                      controller.update();

                      // ✅ استدعاء التسجيل
                      controller.register();
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
