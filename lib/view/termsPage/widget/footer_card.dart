import 'package:flutter/material.dart';

/// خاتمة صفحة الشروط والأحكام
class TermsFooterCard extends StatelessWidget {
  const TermsFooterCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 16, bottom: 24),
      elevation: 1,
      color: const Color(0xFFFFF6EE),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            Icon(
              Icons.info_outline,
              color: Colors.orange,
              size: 28,
            ),
            SizedBox(height: 8),
            Text(
              'استمرارك باستخدام التطبيق يعني موافقتك على الشروط والأحكام.',
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
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
