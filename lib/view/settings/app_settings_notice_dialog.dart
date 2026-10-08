import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSettingsNoticeDialog extends StatelessWidget {
  const AppSettingsNoticeDialog({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = AppColor();
    final maxHeight = MediaQuery.sizeOf(context).height * 0.45;

    return AlertDialog(
      backgroundColor: colors.backgroundColorCard,
      title: Text(
        title,
        style: TextStyle(
          color: colors.titleColor,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: SingleChildScrollView(
          child: Text(
            message,
            style: TextStyle(
              color: colors.descriptionColor,
              height: 1.5,
              fontSize: 15,
            ),
          ),
        ),
      ),
      actions: [
        if (onAction != null)
          TextButton(
            onPressed: Get.back,
            child: const Text('لاحقاً'),
          ),
        ElevatedButton(
          onPressed: onAction ?? Get.back,
          child: Text(actionLabel ?? 'حسناً'),
        ),
      ],
    );
  }
}
