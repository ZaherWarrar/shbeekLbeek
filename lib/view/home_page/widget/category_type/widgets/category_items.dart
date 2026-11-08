import 'package:app/controller/home/home_controller.dart';
import 'package:app/view/home_page/widget/category_type/widgets/card_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryItems extends StatelessWidget {
  const CategoryItems({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeControllerImp>(
      builder: (controller) {
        final items = controller.currentSectionItems;
        if (items.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: CardItem.listHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              return CardItem(controller: controller, index: index);
            },
          ),
        );
      },
    );
  }
}
