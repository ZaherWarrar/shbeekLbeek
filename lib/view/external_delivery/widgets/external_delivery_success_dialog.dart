import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExternalDeliverySuccessDialog extends StatelessWidget {
  const ExternalDeliverySuccessDialog({super.key});

  static Future<void> show() {
    return Get.dialog<void>(
      const ExternalDeliverySuccessDialog(),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: AppColor().backgroundColorCard,
      contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColor().primaryColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              size: 36,
              color: AppColor().primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'تم بنجاح',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColor().titleColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'تم انشاء الطلب بنجاح سيتم التواصل معك لتأكيد الطلب',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: AppColor().descriptionColor,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor().primaryColor,
                foregroundColor: AppColor().textButomColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: () => Get.back(),
              child: const Text(
                'حسناً',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
