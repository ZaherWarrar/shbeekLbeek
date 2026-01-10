import 'dart:async';
import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/controller/order/order_controller.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartFloatingButton extends StatefulWidget {
  const CartFloatingButton({super.key});

  @override
  State<CartFloatingButton> createState() => _CartFloatingButtonState();
}

class _CartFloatingButtonState extends State<CartFloatingButton> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        // تحديث الـ UI كل ثانية لإعادة بناء GetBuilder
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(
      builder: (orderController) {
        // التحقق من وجود طلب نشط
        if (orderController.hasActiveOrder() &&
            orderController.currentOrderId != null) {
          // عرض العداد إذا كان هناك طلب نشط
          final remainingSeconds = orderController.getRemainingCancelSeconds();
          final timeText = _formatTime(remainingSeconds);

          return Stack(
            clipBehavior: Clip.none,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.orange,
                onPressed: () {
                  Get.toNamed(AppRoutes.cartView);
                },
                child: const Icon(Icons.shopping_cart, color: Colors.white),
              ),
              Positioned(
                right: -8,
                top: -8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: remainingSeconds > 0 ? Colors.orange : Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 50,
                    minHeight: 20,
                  ),
                  child: Text(
                    timeText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
        }

        // عرض عدد المنتجات إذا لم يكن هناك طلب نشط
        return GetBuilder<CartController>(
          builder: (cartController) {
            final itemCount = cartController.itemCount;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.orange,
                  onPressed: () {
                    Get.toNamed(AppRoutes.cartView);
                  },
                  child: const Icon(Icons.shopping_cart, color: Colors.white),
                ),
                if (itemCount > 0)
                  Positioned(
                    right: -8,
                    top: -8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        itemCount > 99 ? '99+' : itemCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
