import 'package:app/controller/category/category_type_controller.dart';
import 'package:app/view/home_page/widget/category_type/widgets/card_item.dart';
import 'package:flutter/material.dart';

class CategoryItems extends StatelessWidget {
  const CategoryItems({super.key, required this.controller});
  final CategoryTypeControllerImb controller;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
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
    );
  }
}
