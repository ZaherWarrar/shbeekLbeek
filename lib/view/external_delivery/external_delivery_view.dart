import 'package:app/binding/external_delivery_binding.dart';
import 'package:app/controller/external_delivery/external_delivery_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/shared/custom_button.dart';
import 'package:app/view/external_delivery/widgets/external_delivery_form.dart';
import 'package:app/view/external_delivery/widgets/external_delivery_map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExternalDeliveryView extends StatelessWidget {
  const ExternalDeliveryView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ExternalDeliveryController>()) {
      ExternalDeliveryBinding().dependencies();
    }

    return GetBuilder<ExternalDeliveryController>(
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColor().backgroundColor,
            appBar: AppBar(
              title: const Text(
                'توصيل خارجي',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              backgroundColor: AppColor().backgroundColor,
              elevation: 0,
              centerTitle: true,
              automaticallyImplyLeading: false,
              iconTheme: IconThemeData(color: AppColor().titleColor),
            ),
            body: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: SizedBox(
                    height: 280,
                    child: ExternalDeliveryMap(),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColor().backgroundColor,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'بيانات التوصيل',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: AppColor().titleColor,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const ExternalDeliveryForm(),
                          const SizedBox(height: 20),
                          CustomButton(
                            hi: 48,
                            we: double.infinity,
                            fontsize: 16,
                            padding: 12,
                            title: 'تأكيد الطلب',
                            onTap: controller.validateAndSubmit,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
