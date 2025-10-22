import 'package:flutter/material.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/shared/custom_loding_page.dart';

class CustomRefresh extends StatelessWidget {
  const CustomRefresh({
    super.key,
    required this.body,
    required this.fun,
    required this.statusRequest,
  });
  final Widget body;
  final Future<dynamic> Function() fun;
  final StatusRequest statusRequest;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: AppColor().backgroundColor,
      displacement: 0,
      color: AppColor().primaryColor,
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 2));
        await fun();
      },
      child: CustomLodingPage(statusRequest: statusRequest, body: body),
    );
  }
}
