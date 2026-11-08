import 'package:app/controller/profile/profile_controller.dart';
import 'package:app/controller/profile/account_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/constant/routes/app_routes.dart';
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
      body: GetBuilder<ProfileController>(
        init: controller,
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              children: [
                ProfileHeader(controller: controller),

                ProfileSection(
                  title: 'الحساب',
                  items: [
                    // ProfileItemData(
                    //   title: 'سجل الطلبات',
                    //   icon: Icons.history,
                    //   route: AppRoutes.ordhis,
                    // ),
                    ProfileItemData(
                      title: 'الإشعارات',
                      icon: Icons.notifications_outlined,
                      route: AppRoutes.notifications,
                    ),
                    ProfileItemData(
                      title: 'العناوين المحفوظة',
                      icon: Icons.location_on_outlined,
                      route: AppRoutes.addrslis,
                    ),
                    ProfileItemData(
                      title: 'المحفظة',
                      icon: Icons.account_balance_wallet_outlined,
                      route: AppRoutes.wallet,
                    ),
                    if (controller.showChangeCity)
                      ProfileItemData(
                        title: 'تغيير المدينة',
                        icon: Icons.map_outlined,
                        route: AppRoutes.chooseCity,
                      ),
                  ],
                ),

                // ProfileSection(
                //   title: 'عام',
                //   items: [
                //     ProfileItemData(title: 'الإعدادات', icon: Icons.settings),
                //   ],
                // ),
                ProfileSection(
                  title: 'الدعم والمعلومات',
                  items: [
                    ProfileItemData(
                      title: 'سياسة الخصوصية',
                      icon: Icons.privacy_tip_outlined,
                      route: AppRoutes.privacy,
                    ),
                    ProfileItemData(
                      title: 'الشروط والأحكام',
                      icon: Icons.description_outlined,
                      route: AppRoutes.terms,
                    ),
                    ProfileItemData(
                      title: 'تواصل معنا',
                      icon: Icons.support_agent,
                      route: AppRoutes.contact,
                    ),
                    ProfileItemData(
                      title: 'عن التطبيق',
                      icon: Icons.info_outline,
                      route: AppRoutes.about,
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                GetBuilder<AccountController>(
                  builder: (account) {
                    final busy = account.deleting || account.leaving;
                    if (!account.session.isLoggedIn) {
                      return LogoutButton(onTap: controller.handleAuthAction);
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: busy
                                      ? null
                                      : () => account.requestDeletion(),
                                  icon: busy
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.delete_outline,
                                          size: 18,
                                        ),
                                  label: const Text(
                                    'حذف الحساب',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade700,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: Colors.red.shade200,
                                    elevation: 0,
                                    minimumSize: const Size(0, 48),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: LogoutButton(
                                  onTap: controller.handleAuthAction,
                                  padded: false,
                                  enabled: !busy,
                                ),
                              ),
                            ],
                          ),
                          if (account.deleteError != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              account.deleteError!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
