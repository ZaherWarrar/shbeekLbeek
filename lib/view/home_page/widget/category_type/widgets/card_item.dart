import 'package:app/controller/category/category_type_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/function/fontsize.dart';
import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  const CardItem({super.key, required this.controller, required this.index});
  final CategoryTypeControllerImb controller;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: AppColor().backgroundColorCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            child: Image.asset(
              controller.dataCategory[index]["image"],
              height: 130,
              width: 300,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                controller.dataCategory[index]["title"],
                style: TextStyle(
                  fontSize: getResponsiveFontSize(context, fontSize: 25),
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                controller.dataCategory[index]["dis"],
                style: TextStyle(
                  fontSize: getResponsiveFontSize(context, fontSize: 15),
                  color: AppColor().descriptionColor,
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                children: [
                  Icon(
                    Icons.star_border,
                    color: AppColor().primaryColor,
                    size: 20,
                  ),
                  SizedBox(width: 5),
                  Text(
                    controller.dataCategory[index]["rate"].toString(),
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(context, fontSize: 20),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "(${controller.dataCategory[index]["count"]})",
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(context, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
