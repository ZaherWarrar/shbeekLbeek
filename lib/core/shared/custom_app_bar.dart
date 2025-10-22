import 'package:flutter/material.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/function/fontsize.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: AppColor().titleColor,
      backgroundColor: AppColor().backgroundColor,
      surfaceTintColor: AppColor().backgroundColor,
      elevation: 0.0,
      centerTitle: true,

      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          title,
          style: TextStyle(
            fontSize: getResponsiveFontSize(context, fontSize: 45),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}
