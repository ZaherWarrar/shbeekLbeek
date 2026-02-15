import 'package:app/core/constant/app_color.dart';
import 'package:app/core/shared/custom_app_bar.dart';
import 'package:flutter/material.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColor();

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      appBar: CustomAppBar(title: "تفاصيل الطلب"),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            _buildProductCard(colors),
            const SizedBox(height: 12),
            _buildProductCard(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(AppColor colors) {
    return Card(
      color: colors.backgroundColorCard,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // صورة المنتج
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTa9Qq1rV_svdydH5u3O8r5ZmT8udMBnSuKeA&s",
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            // النصوص
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "اسم المنتج",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colors.titleColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "الوصف تبعه   ",
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.descriptionColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "السعر: 25.00 \$",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
