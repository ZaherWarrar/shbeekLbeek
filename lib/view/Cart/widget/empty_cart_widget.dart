import 'package:app/core/constant/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final padding = isSmallScreen ? 20.0 : 32.0;
    final iconSize = isSmallScreen ? 80.0 : 100.0;
    final titleFontSize = isSmallScreen ? 20.0 : 24.0;
    final bodyFontSize = isSmallScreen ? 14.0 : 16.0;
    final buttonFontSize = isSmallScreen ? 14.0 : 16.0;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: iconSize,
              color: Colors.grey[400],
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            Text(
              "السلة فارغة",
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: isSmallScreen ? 8 : 12),
            Text(
              "لم تقم بإضافة أي منتجات للسلة بعد",
              style: TextStyle(fontSize: bodyFontSize, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isSmallScreen ? 24 : 32),
            ElevatedButton(
              onPressed: () {
                Get.offAllNamed(AppRoutes.home);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 24 : 32,
                  vertical: isSmallScreen ? 12 : 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "تصفح المتاجر",
                style: TextStyle(
                  fontSize: buttonFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
