import 'package:app/controller/profile/profile_controller.dart';
import 'package:app/view/profile/widget/logout_button.dart';
import 'package:app/view/profile/widget/profile_header.dart';
import 'package:app/view/profile/widget/profile_item.dart';
import 'package:app/view/profile/widget/profile_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F5),
      appBar: AppBar(
        title: const Text('ملفي الشخصي', style: TextStyle(fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(controller: controller),

            ProfileSection(
              title: 'الحساب',
              items: [
                ProfileItemData(title: 'سجل الطلبات', icon: Icons.history),
                ProfileItemData(
                  title: 'العناوين المحفوظة',
                  icon: Icons.location_on_outlined,
                ),
                ProfileItemData(title: 'طرق الدفع', icon: Icons.credit_card),
              ],
            ),

            ProfileSection(
              title: 'عام',
              items: [
                ProfileItemData(title: 'الإعدادات', icon: Icons.settings),
                ProfileItemData(
                  title: 'مركز المساعدة',
                  icon: Icons.help_outline,
                ),
              ],
            ),

            const SizedBox(height: 20),
            LogoutButton(onTap: controller.handleAuthAction),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
