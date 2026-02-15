import 'package:app/core/constant/app_color.dart';
import 'package:app/view/payment/controller/payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widget/payment_method_card.dart';
import 'widget/confirm_payment_button.dart';

class PaymentPage extends GetView<PaymentController> {
  const PaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor().backgroundColor,
        appBar: AppBar(
          title: const Text(
            'طريقة الدفع',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppColor().backgroundColor,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    itemCount: controller.methods.length,
                    itemBuilder: (context, index) {
                      return PaymentMethodCard(method: controller.methods[index]);
                    },
                  );
                }),
              ),
              const SizedBox(height: 12),
              const ConfirmPaymentButton(),
            ],
          ),
        ),
      ),
    );
  }
}
