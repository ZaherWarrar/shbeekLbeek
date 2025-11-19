import 'package:app/controller/home/home_controller.dart';
import 'package:app/core/shared/custom_loding_page.dart';
import 'package:app/view/home_page/widget/category_type/widgets/card_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryItems extends StatelessWidget {
  const CategoryItems({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 158,
      child: GetBuilder<HomeControllerImp>(
        builder: (controller) {
          return CustomLodingPage(
            body: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.dataCategory.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CardItem(controller: controller, index: index),
                  ),
                );
              },
            ),
            statusRequest: controller.newArrivalStat,
          );
        },
      ),
    );
  }
}
