import 'package:app/view/favorets/widget/favorates_tabs/favorates_tabs_model.dart';
import 'package:flutter/material.dart';
import 'restaurant_card.dart';

class FavoritesGrid extends StatelessWidget {
  final List<RestaurantModel> items;
  final int crossAxisCount;

  const FavoritesGrid({
    super.key,
    required this.items,
    required this.crossAxisCount,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        return RestaurantCard(
          item: items[index],
          index: index,
        );
      },
    );
  }
}
