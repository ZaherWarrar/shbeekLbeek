import 'package:flutter/material.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/function/fontsize.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.hi,
    required this.we,
    required this.fontsize,
    required this.padding,
    required this.title,
    required this.onTap,
  });
  final double hi, we, fontsize, padding;
  final String title;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: hi,
        width: we,
        decoration: BoxDecoration(
          color: AppColor().primaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: padding),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              textAlign: TextAlign.center,
              title,
              style: TextStyle(
                decoration: TextDecoration.none,
                color: Colors.white,
                fontSize: getResponsiveFontSize(context, fontSize: fontsize),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
