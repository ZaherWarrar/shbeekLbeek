import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';

/// كرت المقدمة لصفحة سياسة الخصوصية
class IntroCard extends StatelessWidget {
  const IntroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: AppColor().backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            /// أيقونة
            Icon(
              Icons.privacy_tip_outlined,
              color: AppColor().primaryColor,
              size: 26,
            ),
            SizedBox(width: 12),

            /// النص
            Expanded(
              child: Text(
                'نحن نحترم خصوصيتك ونلتزم بحماية بياناتك الشخصية. '
                'توضح هذه السياسة كيفية جمع واستخدام وحماية المعلومات عند استخدامك للتطبيق.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: AppColor().titleColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
