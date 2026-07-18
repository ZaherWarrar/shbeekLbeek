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
    this.isEnabled = true,
    this.showLoading = false,
  });

  final double hi, we, fontsize, padding;
  final String title;
  final VoidCallback onTap;
  final bool isEnabled;
  final bool showLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: hi,
      width: we,
      child: ElevatedButton(
        onPressed: isEnabled && !showLoading ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled 
              ? AppColor().primaryColor 
              : Colors.grey.shade400,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade400,
          disabledForegroundColor: Colors.grey.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.symmetric(vertical: padding),
        ),
        child: showLoading
            ? SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  textAlign: TextAlign.center,
                  title,
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: getResponsiveFontSize(context, fontSize: fontsize),
                  ),
                ),
              ),
      ),
    );
  }
}