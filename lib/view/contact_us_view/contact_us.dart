import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor().backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'تواصل معنا',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColor().titleColor,
          ),
        ),
        iconTheme: IconThemeData(color: AppColor().titleColor),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _ContactCard(
            icon: Icons.email_outlined,
            title: 'البريد الإلكتروني',
            value: 'support@app.com',
          ),
          _ContactCard(
            icon: Icons.phone_outlined,
            title: 'رقم الهاتف',
            value: '+963 999 999 999',
          ),
          _ContactCard(
            icon: Icons.schedule_outlined,
            title: 'أوقات العمل',
            value: 'يومياً من 9 صباحاً حتى 10 مساءً',
          ),
        ],
      ),
    );
  }
}

/// كرت تواصل
class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, color: AppColor().primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(value),
      ),
    );
  }
}
