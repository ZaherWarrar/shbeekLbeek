import 'package:app/core/services/session_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool padded;
  final bool enabled;

  const LogoutButton({
    super.key,
    required this.onTap,
    this.padded = true,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = Get.find<SessionService>().isLoggedIn;

    final button = ElevatedButton.icon(
      onPressed: enabled ? onTap : null,
      icon: Icon(isLoggedIn ? Icons.logout : Icons.login, size: 18),
      label: Text(
        isLoggedIn ? 'تسجيل الخروج' : 'تسجيل الدخول',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isLoggedIn ? Colors.red.shade50 : Colors.green.shade50,
        foregroundColor: isLoggedIn ? Colors.red : Colors.green,
        elevation: 0,
        minimumSize: Size(padded ? double.infinity : 0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    if (!padded) return button;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: button,
    );
  }
}
