import 'package:flutter/material.dart';

class OrderActionsWidget extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool canCancel;
  final bool isLoading;

  const OrderActionsWidget({
    super.key,
    required this.onConfirm,
    this.onCancel,
    required this.canCancel,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Column(
      children: [
        // زر التأكيد
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 14 : 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isLoading ? null : onConfirm,
            child: isLoading
                ? SizedBox(
                    height: isSmallScreen ? 20 : 24,
                    width: isSmallScreen ? 20 : 24,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    "تأكيد الطلب",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
        SizedBox(height: isSmallScreen ? 12 : 16),
        // زر الإلغاء
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: canCancel ? Colors.red : Colors.grey,
              padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 14 : 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: (canCancel && !isLoading && onCancel != null)
                ? onCancel
                : null,
            child: Text(
              "إلغاء الطلب",
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
