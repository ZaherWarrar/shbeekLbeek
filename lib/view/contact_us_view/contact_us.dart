import 'package:app/controller/settings/app_settings_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AppSettingsController>();

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
      body: GetBuilder<AppSettingsController>(
        initState: (_) {
          if (!controller.settingsLoaded) {
            controller.loadSettings();
          }
        },
        builder: (controller) {
          final numbers = controller.contactNumbers;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (!controller.settingsLoaded)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (numbers.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    'لا تتوفر أرقام تواصل حالياً',
                    style: TextStyle(color: AppColor().descriptionColor),
                  ),
                )
              else
                ...numbers.map(
                  (number) => _ContactCard(
                    icon: Icons.phone_outlined,
                    title: 'رقم التواصل',
                    value: number,
                    onTap: () => controller.callNumber(number),
                  ),
                ),
              const _ContactCard(
                icon: Icons.email_outlined,
                title: 'البريد الإلكتروني',
                value: 'support@app.com',
              ),
              const _ContactCard(
                icon: Icons.schedule_outlined,
                title: 'أوقات العمل',
                value: 'يومياً من 9 صباحاً حتى 10 مساءً',
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  const _ContactCard({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColor().primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(value),
        trailing: onTap == null
            ? null
            : Icon(Icons.call, color: AppColor().primaryColor),
      ),
    );
  }
}
