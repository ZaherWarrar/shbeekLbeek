import 'package:app/controller/profile/profile_controller.dart';
import 'package:app/core/constant/app_color.dart';
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
      backgroundColor: AppColor().backgroundColor,
      appBar: AppBar(
        title: const Text(
          'ملفي الشخصي',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: AppColor().backgroundColor,
        elevation: 0,
        foregroundColor: AppColor().titleColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(controller: controller),

            ProfileSection(
              title: 'الحساب',
              items: [
                ProfileItemData(title: 'سجل الطلبات', icon: Icons.history,route:'/OrderHistoryPage'),
                ProfileItemData(
                  title: 'العناوين المحفوظة',
                  icon: Icons.location_on_outlined,
                  route: '/AddressList'
                ),
                ProfileItemData(title: 'طرق الدفع', icon: Icons.credit_card,route: '/PaymentBinding'),
              ],
            ),

            ProfileSection(
              title: 'عام',
              items: [
                ProfileItemData(title: 'الإعدادات', icon: Icons.settings),
              ],
            ),

            ProfileSection(
              title: 'الدعم والمعلومات',
              items: [
                ProfileItemData(
                  title: 'سياسة الخصوصية',
                  icon: Icons.privacy_tip_outlined,
                  route: '/privacy',
                ),
                ProfileItemData(
                  title: 'الشروط والأحكام',
                  icon: Icons.description_outlined,
                  route: '/terms',
                ),
                ProfileItemData(
                  title: 'تواصل معنا',
                  icon: Icons.support_agent,
                  route: '/contact',
                ),
                ProfileItemData(
                  title: 'عن التطبيق',
                  icon: Icons.info_outline,
                  route: '/about',
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
