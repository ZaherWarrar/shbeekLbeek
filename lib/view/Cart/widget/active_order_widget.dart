import 'dart:async';
import 'package:app/controller/order/order_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActiveOrderWidget extends StatefulWidget {
  const ActiveOrderWidget({super.key});

  @override
  State<ActiveOrderWidget> createState() => _ActiveOrderWidgetState();
}

class _ActiveOrderWidgetState extends State<ActiveOrderWidget> {
  Timer? _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    // loadActiveOrder يتم استدعاؤه في OrderController.onInit()
    _updateRemainingSeconds();
    _startTimer();
  }

  void _updateRemainingSeconds() {
    final orderController = Get.find<OrderController>();
    _remainingSeconds = orderController.getRemainingCancelSeconds();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _updateRemainingSeconds();
          if (_remainingSeconds <= 0) {
            timer.cancel();
            // التحقق من التأكيد التلقائي
            final orderController = Get.find<OrderController>();
            orderController.checkTimerAndAutoConfirm();
          }
        });
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final padding = isSmallScreen ? 16.0 : 20.0;

    return GetBuilder<OrderController>(
      builder: (orderController) {
        final orderId = orderController.currentOrderId;
        final canCancel = _remainingSeconds > 0;

        if (orderId == null) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // بطاقة الطلب النشط
              Card(
                color: AppColor().backgroundColorCard,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // العنوان
                      Row(
                        children: [
                          Icon(
                            Icons.shopping_bag,
                            color: Colors.orange,
                            size: isSmallScreen ? 24 : 28,
                          ),
                          SizedBox(width: isSmallScreen ? 8 : 12),
                          Text(
                            "طلب قيد المعالجة",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 18 : 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isSmallScreen ? 12 : 16),

                      // رقم الطلب
                      Text(
                        "رقم الطلب: #$orderId",
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 12 : 16),

                      // العداد التنازلي
                      Container(
                        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                        decoration: BoxDecoration(
                          color: canCancel
                              ? Colors.orange.shade50
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: canCancel
                                ? Colors.orange.shade300
                                : Colors.grey.shade400,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              canCancel ? Icons.timer : Icons.timer_off,
                              color: canCancel ? Colors.orange : Colors.grey,
                              size: isSmallScreen ? 24 : 28,
                            ),
                            SizedBox(width: isSmallScreen ? 8 : 12),
                            Text(
                              canCancel
                                  ? "الوقت المتبقي للإلغاء"
                                  : "انتهى وقت الإلغاء",
                              style: TextStyle(
                                fontSize: isSmallScreen ? 12 : 14,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: isSmallScreen ? 8 : 12),
                            Text(
                              _formatTime(_remainingSeconds),
                              style: TextStyle(
                                fontSize: isSmallScreen ? 24 : 32,
                                fontWeight: FontWeight.bold,
                                color: canCancel ? Colors.orange : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 12 : 16),

                      // معلومات إضافية
                      Container(
                        padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue,
                              size: isSmallScreen ? 18 : 20,
                            ),
                            SizedBox(width: isSmallScreen ? 8 : 12),
                            Expanded(
                              child: Text(
                                canCancel
                                    ? "يمكنك إلغاء الطلب خلال 10 دقائق من إنشائه"
                                    : "سيتم تأكيد الطلب تلقائياً قريباً",
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 11 : 13,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 12 : 16),

                      // زر عرض التفاصيل
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(
                              vertical: isSmallScreen ? 12 : 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Get.toNamed(
                              AppRoutes.orderConfirmation,
                              arguments: orderId,
                            );
                          },
                          child: Text(
                            "عرض التفاصيل",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
