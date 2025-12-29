import 'package:app/controller/home/home_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/shared/custom_loding_page.dart';
import 'package:flutter/material.dart';

class MainCategory extends StatelessWidget {
  const MainCategory({super.key, required this.controller});
  final HomeControllerImp controller;
  @override
  Widget build(BuildContext context) {
    return CustomLodingPage(
      body: SizedBox(
        height: 40,
        child: ListView.builder(
          itemCount: controller.homeSection.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                controller.updateSection(
                  index,
                  controller.homeSection[index].name!,
                );
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
                      child: Text(
                        controller.homeSection[index].name.toString(),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      statusRequest: controller.finalSectionState,
    );
  }
}
