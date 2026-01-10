import 'package:flutter/material.dart';

/// مقدمة صفحة الشروط والأحكام
class TermsIntroCard extends StatelessWidget {
  const TermsIntroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Icon(
              Icons.gavel_outlined,
              color: Colors.orange,
              size: 26,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'يرجى قراءة الشروط والأحكام بعناية قبل استخدام التطبيق. '
                'استخدامك للتطبيق يعني موافقتك الكاملة على هذه الشروط.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
