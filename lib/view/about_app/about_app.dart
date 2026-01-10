import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor().backgroundColor,
        elevation: 0,
        centerTitle: true,
        title:  Text(
          'عن التطبيق',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColor().titleColor,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 1,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تطبيق طلب الطعام',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColor().primaryColor ,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'هذا التطبيق يتيح لك طلب الطعام بسهولة من أفضل المطاعم القريبة منك، '
                    'مع تجربة استخدام بسيطة وسريعة.',
                    style: TextStyle(fontSize: 14, height: 1.6),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text('الإصدار: 1.0.0'),
                  const Text('© 2026 جميع الحقوق محفوظة'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
