import 'dart:async';
import 'package:app/controller/order/order_controller.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/shared/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/view/order/widget/order_timer_widget.dart';
import 'package:app/view/order/widget/order_actions_widget.dart';

class OrderConfirmationView extends StatefulWidget {
  const OrderConfirmationView({super.key});

  @override
  State<OrderConfirmationView> createState() => _OrderConfirmationViewState();
}

class _OrderConfirmationViewState extends State<OrderConfirmationView> {
  Timer? _timer;
  int _remainingSeconds = 600; // 10 دقائق بالثواني

  @override
  void initState() {
    super.initState();
    final orderController = Get.find<OrderController>();

    // loadActiveOrder يتم استدعاؤه في OrderController.onInit()
    // الحصول على orderId من arguments أو من controller
    final orderId = Get.arguments as int? ?? orderController.currentOrderId;
    if (orderId != null) {
      orderController.currentOrderId = orderId;
      // إذا لم يكن orderCreatedAt موجوداً، نستخدم الوقت الحالي ونحفظه
      if (orderController.orderCreatedAt == null) {
        orderController.orderCreatedAt = DateTime.now();
        // حفظ الطلب النشط
        orderController.userPreferences.saveActiveOrder(
          orderId,
          orderController.orderCreatedAt!,
        );
      }
    }

    // حساب الوقت المتبقي
    _remainingSeconds = orderController.getRemainingCancelSeconds();
    if (_remainingSeconds <= 0) {
      _remainingSeconds = 0;
    }

    // بدء العداد التنازلي
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        final orderController = Get.find<OrderController>();
        // تحديث الوقت المتبقي من controller
        _remainingSeconds = orderController.getRemainingCancelSeconds();

        setState(() {
          if (_remainingSeconds > 0) {
            // الوقت لا يزال متبقي
          } else {
            timer.cancel();
            // تأكيد الطلب تلقائياً عند انتهاء العداد
            if (orderController.currentOrderId != null) {
              orderController.confirmOrder(orderController.currentOrderId!);
            }
          }
        });
      }
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
      onPopInvoked: (didPop) {
        if (didPop) return;
        // السماح بالرجوع للصفحة السابقة
        Get.back();
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
              final isLoading = controller.orderState == StatusRequest.loading;

              if (orderIdNullable == null) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          "خطأ",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 20 : 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "لم يتم العثور على رقم الطلب",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => Get.back(),
                          child: Text("العودة"),
                        ),
                      ],
                    ),
                  ),
                );
              }

              // بعد التحقق، orderIdNullable لا يمكن أن يكون null
              final orderId = orderIdNullable;

              return SingleChildScrollView(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: isSmallScreen ? 20 : 30),

                    // رسالة الترحيب
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
                          Icon(
                            Icons.check_circle,
                            size: isSmallScreen ? 48 : 64,
                            color: Colors.green,
                          ),
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

                    // العداد التنازلي
                    OrderTimerWidget(
                      remainingSeconds: _remainingSeconds,
                      isExpired: !canCancel,
                    ),

                    SizedBox(height: isSmallScreen ? 24 : 30),

                    // معلومات مهمة
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue,
                            size: isSmallScreen ? 20 : 24,
                          ),
                          SizedBox(width: isSmallScreen ? 8 : 12),
                          Expanded(
                            child: Text(
                              canCancel
                                  ? "يمكنك إلغاء الطلب خلال 10 دقائق من إنشائه"
                                  : "انتهى وقت الإلغاء. يمكنك فقط تأكيد الطلب",
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
                      onConfirm: () {
                        controller.confirmOrder(orderId);
                      },
                      onCancel: canCancel
                          ? () {
                              // عرض تأكيد قبل الإلغاء
                              Get.dialog(
                                AlertDialog(
                                  title: Text("تأكيد الإلغاء"),
                                  content: Text("هل أنت متأكد من إلغاء الطلب؟"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: Text("إلغاء"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                        controller.cancelOrder(orderId);
                                      },
                                      child: Text(
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
