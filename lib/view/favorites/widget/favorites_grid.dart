import 'package:app/view/favorites/widget/favorites_tabs/favorites_tabs_model.dart';
import 'package:app/view/favorites/widget/restaurant_card.dart';
import 'package:flutter/material.dart';

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
        mainAxisExtent: RestaurantCard.cardExtent,
      ),
      itemBuilder: (context, index) {
        return RestaurantCard(item: items[index]);
      },
    );
  }
}
