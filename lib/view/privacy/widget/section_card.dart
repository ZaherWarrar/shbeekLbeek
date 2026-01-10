import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';

/// كرت لعرض كل قسم من سياسة الخصوصية
class SectionCard extends StatelessWidget {
  final String title;
  final List<String> content;

  const SectionCard({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 12),
      elevation: 1,
      color: AppColor().backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// عنوان القسم
            Text(
              title,
              style:  TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColor().primaryColor, // هوية التطبيق
              ),
            ),

            const SizedBox(height: 10),

            /// النقاط
            ...content.map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Icon(
                      Icons.circle,
                      size: 6,
                      color: AppColor().primaryColor,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        e,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
