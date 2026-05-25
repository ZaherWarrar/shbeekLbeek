import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';

class ShopCategoryTabsRow extends StatelessWidget {
  const ShopCategoryTabsRow({
    super.key,
    required this.tabs,
    required this.selectedId,
    required this.onSelect,
  });

  final List<({int? id, String name})> tabs;
  final int? selectedId;
  final void Function(int? categoryId) onSelect;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final horizontalPadding = width < 360 ? 10.0 : 14.0;
    final verticalPadding = width < 360 ? 6.0 : 8.0;
    final fontSize = width < 360 ? 12.0 : 14.0;
    final spacing = width < 360 ? 6.0 : 10.0;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, _) => SizedBox(width: spacing),
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final isSelected = tab.id == selectedId;

          return GestureDetector(
            onTap: () => onSelect(tab.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColor().primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected
                      ? AppColor().primaryColor
                      : Colors.grey.shade300,
                ),
              ),
              child: Center(
                child: Text(
                  tab.name,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.black87,
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
