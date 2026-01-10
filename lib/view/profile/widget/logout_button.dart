import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const LogoutButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.logout),
        label: const Text('تسجيل الخروج'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor().backgroundColor,
          foregroundColor: Colors.red,
          elevation: 0,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
