import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';

/// كرت الخاتمة لسياسة الخصوصية
class FooterCard extends StatelessWidget {
  const FooterCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 16, bottom: 24),
      elevation: 1,
      color: AppColor().backgroundColor, // خلفية برتقالية خفيفة
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children:  [
            Icon(Icons.info_outline, color: AppColor().primaryColor, size: 28),
            SizedBox(height: 8),
            Text(
              'باستخدامك لهذا التطبيق، فإنك توافق على سياسة الخصوصية هذه.',
              style: TextStyle(
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'لأي استفسار، يرجى التواصل معنا عبر صفحة "تواصل معنا".',
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: AppColor().titleColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
