import 'package:app/controller/auth/otp/otp_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/function/fontsize.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpResendButton extends GetView<OtpController> {
  const OtpResendButton({super.key});

  @override
  Widget build(BuildContext context) {
    final fontSize = getResponsiveFontSize(context, fontSize: 20);

    return Obx(() {
      final waiting = controller.resendSecondsLeft.value > 0;
      final busy = controller.isResending.value;

      return TextButton(
        onPressed: controller.canResend ? controller.resendOtp : null,
        child: busy
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                waiting ? controller.resendCountdownText : '23'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize,
                  color: waiting ? Colors.grey : AppColor().descriptionColor,
                ),
              ),
      );
    });
  }
}
