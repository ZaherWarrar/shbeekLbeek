import 'package:flutter/material.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/function/fontsize.dart';

class CustomInfo extends StatelessWidget {
  const CustomInfo({super.key, required this.titel, required this.text});
  final String titel, text;
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      alignment: Alignment.centerRight,
      fit: BoxFit.scaleDown,
      child: Row(
        children: [
          Text(
            titel,
            style: TextStyle(
              color: AppColor().titleColor,
              fontSize: getResponsiveFontSize(context, fontSize: 25),
            ),
          ),
          Text(
            text,
            style: TextStyle(
              color: AppColor().descriptionColor,
              fontSize: getResponsiveFontSize(context, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
