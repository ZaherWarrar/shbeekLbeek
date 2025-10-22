// import 'package:admin_app/core/function/fontsize.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/main.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog(
      {super.key,
      required this.title,
      required this.botum,
      required this.des,
      required this.count});
  final String title, botum, des;
  final int count;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(w * 0.05)),
      height: h*0.4,
      width: w * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: h * 0.015, right: w * 0.05),
            child: FittedBox(
              child: Text(
                title,
                style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontFamily: "Sukar",
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: w * 0.08),
            child: FittedBox(
              child: Text(
                des,
                style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Colors.black,
                    fontFamily: "Sukar",
                    fontWeight: FontWeight.w400,
                    fontSize: 15),
              ),
            ),
          ),
          Divider(),
          MaterialButton(
            onPressed: () {
              if (count == 1) {
                Get.back();
              } else if (count > 1) {
                Get.back();
                Get.back();
              }
            },
            child: Center(
              child: FittedBox(
                child: Text(
                  botum,
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.blue,
                      fontFamily: "Sukar",
                      fontWeight: FontWeight.w500,
                      fontSize: 25),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
