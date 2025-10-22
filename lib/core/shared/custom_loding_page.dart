import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/app_images.dart';
import 'package:app/core/shared/custom_dialog.dart';

class CustomLodingPage extends StatelessWidget {
  const CustomLodingPage({super.key, required this.statusRequest, required this.body});
  final StatusRequest statusRequest;
  final Widget body;
  @override
  Widget build(BuildContext context) {
    if (statusRequest == StatusRequest.loading) {
      return Center(
          child: Lottie.asset(Assets.imagesLoding, width: 100, height: 100));
    } else if (statusRequest == StatusRequest.offlinefailure) {
      return CustomDialog(
        des: "يوجد خطأ في السيرفر الرجاء المحاولة مرة اخرى",
        botum: "حسناً",
        title: "عفواً",
        count: 1,
      );
    } else if (statusRequest == StatusRequest.serverException) {
      return CustomDialog(
        des: "يوجد خطأ في السيرفر الرجاء المحاولة مرة اخرى",
        botum: "حسناً",
        title: "عفواً",
        count: 1,
      );
    } else {
      return body;
    }
  }
}
