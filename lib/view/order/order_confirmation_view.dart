import 'dart:async';
import 'package:app/controller/order/order_controller.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/shared/custom_app_bar.dart';
import 'package:app/view/order/widget/order_actions_widget.dart';
import 'package:app/view/order/widget/order_timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderConfirmationView extends StatefulWidget {
  const OrderConfirmationView({super.key});

  @override
  State<OrderConfirmationView> createState() => _OrderConfirmationViewState();
}

class _OrderConfirmationViewState extends State<OrderConfirmationView> {
  Timer? _timer;
  int _remainingSeconds = 600;

  @override
  void initState() {
    super.initState();

    final orderController = Get.find<OrderController>();

    // الحصول على رقم الطلب من arguments أو من controller
    final orderId = Get.arguments as int? ?? orderController.currentOrderId;

    if (orderId != null) {
      orderController.currentOrderId = orderId;

      // إذا لم يكن orderCreatedAt موجوداً، نستخدم الوقت الحالي ونحفظه
      if (orderController.orderCreatedAt == null) {
        orderController.orderCreatedAt = DateTime.now();

        // 🔥 حفظ الطلب النشط عبر SessionService
        orderController.session.saveActiveOrder(
          orderId,
          orderController.orderCreatedAt!,
        );
      }
    }

    // حساب الوقت المتبقي
    _remainingSeconds = orderController.getRemainingCancelSeconds();
    if (_remainingSeconds < 0) _remainingSeconds = 0;

    // بدء العداد
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;

      final orderController = Get.find<OrderController>();

      setState(() {
        _remainingSeconds = orderController.getRemainingCancelSeconds();

        if (_remainingSeconds <= 0) {
          timer.cancel();

          if (orderController.currentOrderId != null) {
            orderController.confirmOrder(orderController.currentOrderId!);
          }
        }
      });
    });
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

    return PopScope(
      canPop: true,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        if (!didPop) Get.back();
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColor().backgroundColor,
          appBar: CustomAppBar(title: "تأكيد الطلب"),
          body: GetBuilder<OrderController>(
            builder: (controller) {
              final orderIdNullable =
                  controller.currentOrderId ?? Get.arguments as int?;

              final canCancel = _remainingSeconds > 0;
              final isLoading =
                  controller.orderState == StatusRequest.loading;

              if (orderIdNullable == null) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          "خطأ",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 20 : 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "لم يتم العثور على رقم الطلب",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => Get.back(),
                          child: const Text("العودة"),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final orderId = orderIdNullable;

              return SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: isSmallScreen ? 20 : 30),

                    // رسالة النجاح
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.green.shade300,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.check_circle,
                              size: isSmallScreen ? 48 : 64,
                              color: Colors.green),
                          SizedBox(height: isSmallScreen ? 12 : 16),
                          Text(
                            "تم إنشاء الطلب بنجاح",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 18 : 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade800,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 8 : 12),
                          Text(
                            "رقم الطلب: #$orderId",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isSmallScreen ? 24 : 30),

                    // العداد
                    OrderTimerWidget(
                      remainingSeconds: _remainingSeconds,
                      isExpired: !canCancel,
                    ),

                    SizedBox(height: isSmallScreen ? 24 : 30),

                    // معلومات
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: Colors.blue,
                              size: isSmallScreen ? 20 : 24),
                          SizedBox(width: isSmallScreen ? 8 : 12),
                          Expanded(
                            child: Text(
                              canCancel
                                  ? "يمكنك إلغاء الطلب خلال 10 دقائق من إنشائه"
                                  : "انتهى وقت الإلغاء. سيتم تأكيد الطلب تلقائيًا",
                              style: TextStyle(
                                fontSize: isSmallScreen ? 12 : 14,
                                color: Colors.blue.shade900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: isSmallScreen ? 30 : 40),

                    // أزرار التأكيد والإلغاء
                    OrderActionsWidget(
                      onConfirm: () => controller.confirmOrder(orderId),
                      onCancel: canCancel
                          ? () {
                              Get.dialog(
                                AlertDialog(
                                  title: const Text("تأكيد الإلغاء"),
                                  content: const Text(
                                      "هل أنت متأكد من إلغاء الطلب؟"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: const Text("إلغاء"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                        controller.cancelOrder(orderId);
                                      },
                                      child: const Text(
                                        "نعم، إلغاء",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          : null,
                      canCancel: canCancel,
                      isLoading: isLoading,
                    ),

                    SizedBox(height: isSmallScreen ? 20 : 30),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}