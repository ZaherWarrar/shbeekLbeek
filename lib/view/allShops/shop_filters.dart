import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';

class FiltersRowWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onSelect;

  FiltersRowWidget({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<String> filters = ["الكل", "مطاعم", "حصري", "عروض", "الأعلى"];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final double horizontalPadding = width < 360
        ? 10
        : width < 600
        ? 14
        : 18;

    final double verticalPadding = width < 360
        ? 6
        : width < 600
        ? 8
        : 10;

    final double fontSize = width < 360
        ? 11
        : width < 600
        ? 13
        : 14;

    final double spacing = width < 360
        ? 6
        : width < 600
        ? 10
        : 12;

    return SizedBox(
      height: 45, // ⬅ أصغر
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, _) => SizedBox(width: spacing),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () => onSelect(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColor().primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(18), // ⬅ أصغر
                border: Border.all(
                  color: isSelected
                      ? AppColor().primaryColor
                      : Colors.grey.shade300,
                ),
              ),
              child: Center(
                child: Text(
                  filters[index],
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
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
