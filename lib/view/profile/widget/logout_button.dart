import 'package:app/controller/profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const LogoutButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    return Obx(() {
      final isLoggedIn = controller.isLoggedIn.value;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(isLoggedIn ? Icons.logout : Icons.login),
          label: Text(isLoggedIn ? 'تسجيل الخروج' : 'تسجيل الدخول'),
          style: ElevatedButton.styleFrom(
            backgroundColor: isLoggedIn
                ? Colors.red.shade50
                : Colors.green.shade50,
            foregroundColor: isLoggedIn ? Colors.red : Colors.green,
            elevation: 0,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),

          ),
        ),
      );
    });
  }
}
