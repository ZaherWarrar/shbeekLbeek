import 'package:app/controller/home/home_controller.dart';
import 'package:app/view/home_page/widget/category_type/widgets/category_items.dart';
import 'package:app/view/home_page/widget/category_type/widgets/main_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryType extends StatelessWidget {
  const CategoryType({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeControllerImp>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            MainCategory(controller: controller),
            SizedBox(height: 10),
            CategoryItems(),
          ],
        );
      },
    );
  }
}
