import 'package:app/controller/auth/otp/otp_controller.dart';
import 'package:app/core/constant/app_color.dart';
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
          children: [
            const SizedBox(height: 40),
            const Text(
              "أدخل رمز التفعيل المرسل الى رقمك: ",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            //=========الباكيج تبعيت  otp ====
            Pinput(
              length: 6,
              onChanged: (value) => controller.otpCode.value = value,
              onCompleted: (value) => controller.otpCode.value = value,
              defaultPinTheme: PinTheme(
                width: 50,
                height: 60,
                textStyle: const TextStyle(fontSize: 22, color: Colors.black),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 20),
            Obx(() {
              return ElevatedButton(
                onPressed: controller.isloading.value
                    ? null
                    : () => controller.verifyOtp(),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: controller.isloading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('تأكيد'),
              );
            }),
            const SizedBox(height: 20),

            TextButton(
              onPressed: () {
                Get.snackbar("resend..", "message has been sent");
                //=========api اعادة ارسال الotp====
              },
              child: const Text("resend the code"),
            ),
          ],
        ),
      ),
    );
  }
}
