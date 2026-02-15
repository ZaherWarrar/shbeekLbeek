import 'package:app/controller/auth/otp/otp_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/function/fontsize.dart';
import 'package:app/core/shared/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().backgroundColor,
      appBar: CustomAppBar(title: "18".tr),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "19".tr,
              style: TextStyle(
                color: AppColor().descriptionColor,
                fontSize: getResponsiveFontSize(context, fontSize: 20),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            //========= حقل إدخال OTP =========
            Directionality(
              textDirection: TextDirection.ltr,
              child: Pinput(
                length: 6,
                onChanged: (value) => controller.otpCode.value = value,
                onCompleted: (value) => controller.otpCode.value = value,
                defaultPinTheme: PinTheme(
                  width: 50,
                  height: 60,
                  textStyle: TextStyle(
                    fontSize: getResponsiveFontSize(context, fontSize: 20),
                    color: Colors.black,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 50),

            //========= زر التحقق =========
            Obx(() {
              return ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.verifyOtp(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor().primaryColor,
                  foregroundColor: AppColor().textButomColor,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('20'.tr),
              );
            }),

            const SizedBox(height: 20),

            //========= إعادة إرسال OTP =========
            TextButton(
              onPressed: () {
                Get.snackbar("21".tr, "22".tr);
                // TODO: استدعاء API لإعادة إرسال OTP
              },
              child: Text(
                "23".tr,
                style: TextStyle(
                  fontSize: getResponsiveFontSize(context, fontSize: 20),
                  color: AppColor().descriptionColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
