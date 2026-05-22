import 'package:app/core/constant/app_color.dart';
import 'package:app/data/datasorce/model/product_details_model.dart';
import 'package:flutter/material.dart';

class ProductVariationSelector extends StatelessWidget {
  const ProductVariationSelector({
    super.key,
    required this.variations,
    required this.selectedVariations,
    required this.onToggle,
  });

  final List<ProductVariationModel> variations;
  final List<ProductVariationModel> selectedVariations;
  final ValueChanged<ProductVariationModel> onToggle;

  bool _isSelected(ProductVariationModel v) {
    return selectedVariations.any((e) => e.id == v.id && e.name == v.name);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;
        final maxWidth = constraints.maxWidth;
        final twoColumn = maxWidth >= 320;
        final cardWidth = twoColumn ? (maxWidth - spacing) / 2 : maxWidth;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: variations.map((v) {
            return SizedBox(
              width: cardWidth,
              child: _VariationOptionCard(
                label: v.name ?? '',
                isSelected: _isSelected(v),
                onTap: () => onToggle(v),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _VariationOptionCard extends StatelessWidget {
  const _VariationOptionCard({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColor();
    final displayLabel = label.trim().isEmpty ? 'خيار' : label.trim();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
          decoration: BoxDecoration(
            color: isSelected
                ? colors.primaryColor.withValues(alpha: 0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? colors.primaryColor : Colors.grey.shade300,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? colors.primaryColor.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.03),
                blurRadius: isSelected ? 8 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 28,
                width: 28,
                decoration: BoxDecoration(
                  color: isSelected
                      ? colors.primaryColor
                      : colors.primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  isSelected
                      ? Icons.check_rounded
                      : Icons.tune_rounded,
                  size: 16,
                  color: isSelected ? Colors.white : colors.primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  displayLabel,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? colors.primaryColor : colors.titleColor,
                    height: 1.25,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: isSelected
                    ? Icon(
                        Icons.radio_button_checked_rounded,
                        key: const ValueKey('on'),
                        size: 18,
                        color: colors.primaryColor,
                      )
                    : Icon(
                        Icons.radio_button_off_rounded,
                        key: const ValueKey('off'),
                        size: 18,
                        color: Colors.grey.shade400,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
