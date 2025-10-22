import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/core/function/fontsize.dart';

class CustomStatus extends StatelessWidget {
  const CustomStatus({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
            children: [
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: text == "active"
                      ? Colors.greenAccent
                      : Colors.redAccent,
                ),
              ),
              SizedBox(width: 5),
              Text(
                text == "active" ? "14".tr : "15".tr,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: getResponsiveFontSize(context, fontSize: 20),
                ),
              ),
            ],
          );
  }
}
