import 'package:app/controller/home/home_controller.dart';
import 'package:app/core/shared/custom_refresh.dart';
import 'package:app/view/home_page/widget/category_type/widgets/card_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryItems extends StatelessWidget {
  const CategoryItems({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CardItem.listHeight,
      child: GetBuilder<HomeControllerImp>(
        builder: (controller) {
          final items = controller.finalSection[controller.sectionName];
          return CustomRefresh(
            statusRequest: controller.finalSectionState,
            fun: () => controller.fetchHomeSection(),
            body: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: items?.length ?? 0,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return CardItem(controller: controller, index: index);
              },
            ),
          );
        },
      ),
    );
  }
}
