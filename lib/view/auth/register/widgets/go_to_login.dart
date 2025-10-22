import 'package:app/core/constant/app_color.dart';
import 'package:app/core/function/fontsize.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class GoToLogin extends StatelessWidget {
  const GoToLogin({super.key, required this.onTap});
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "17".tr,
          style: TextStyle(
            color: AppColor().descriptionColor,
            fontSize: getResponsiveFontSize(context, fontSize: 15),
          ),
        ),
        SizedBox(width: 5),
        GestureDetector(
          onTap: onTap,
          child: Text(
            "1".tr,
            style: TextStyle(
              color: AppColor().primaryColor,
              fontSize: getResponsiveFontSize(context, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}
