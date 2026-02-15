import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    _NavItem(Icons.home_outlined, 'الرئيسية'),
    _NavItem(Icons.receipt_long, 'الطلبات'),
    _NavItem(Icons.favorite_border, 'المفضلة'),
    _NavItem(Icons.person_outline, 'الحساب'),
  ];

  @override
  Widget build(BuildContext context) {
    // final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(.08),
            blurRadius: 18,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // final itemWidth = constraints.maxWidth / _items.length;

          return Stack(
            alignment: Alignment.center,
            children: [
              /// 🔘 BUTTONS
              Row(
                children: List.generate(
                  _items.length,
                  (index) => Expanded(
                    child: GestureDetector(
                      onTap: () => onTap(index),
                      behavior: HitTestBehavior.opaque,
                      child: _NavButton(
                        item: _items[index],
                        isSelected: currentIndex == index,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/* ---------- BUTTON ---------- */

class _NavButton extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;

  const _NavButton({required this.item, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedSlide(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          offset: isSelected
              ? const Offset(0, -0.15)
              : Offset.zero, // 👈 تطلع أكثر لفوق
          child: AnimatedScale(
            duration: const Duration(milliseconds: 300),
            scale: isSelected ? 1.2 : 1.0, // 👈 تكبير أكثر وقت الاختيار
            child: Icon(
              item.icon,
              size: 26, // 👈  تكبر حجم الأيقونة شوي
              color: isSelected ? Colors.orange : Colors.grey,
            ),
          ),
        ),
        const SizedBox(height: 2),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 250),
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? Colors.orange : Colors.grey,
          ),
          child: Text(item.label),
        ),
      ],
    );
  }
}

/* ---------- MODEL ---------- */

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem(this.icon, this.label);
}
