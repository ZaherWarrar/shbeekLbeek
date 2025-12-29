import 'package:app/core/constant/app_color.dart';
import 'package:app/main.dart';
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
    return SizedBox(
      height: w * 0.12,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: w * 0.04),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => SizedBox(width: w * 0.025),
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () => onSelect(index),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.05,
                vertical: w * 0.025,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColor().primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey.shade300,
                ),
              ),
              child: Center(
                child: Text(
                  filters[index],
                  style: TextStyle(
                    fontSize: w * 0.035,
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
