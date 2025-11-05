import 'package:app/controller/category/category_type_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';

class MainCategory extends StatelessWidget {
  const MainCategory({super.key, required this.controller});
  final CategoryTypeControllerImb controller;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        itemCount: controller.data.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              controller.selectType(index);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                height: 30,
                width: 100,
                decoration: BoxDecoration(
                  color: controller.selectedType == index
                      ? AppColor().primaryColor
                      : AppColor().backgroundColorCard,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(controller.data[index]["category"]),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
