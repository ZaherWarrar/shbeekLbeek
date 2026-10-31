import 'package:app/view/auth/widgets/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class GoToLogin extends StatelessWidget {
  const GoToLogin({super.key, required this.onTap});
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 5,
      children: [
        Text(
          "17".tr,
          style: const TextStyle(
            color: AuthColors.label,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            "1".tr,
            style: const TextStyle(
              color: AuthColors.purple,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
