import 'package:app/controller/wallet/wallet_controller.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/shared/custom_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletController>(
      init: WalletController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor().backgroundColor,
          appBar: AppBar(
            title: const Text(
              'المحفظة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
            backgroundColor: AppColor().backgroundColor,
            elevation: 0,
            foregroundColor: AppColor().titleColor,
          ),
          body: CustomRefresh(
            statusRequest: controller.statusRequest,
            fun: () => controller.fetchBalance(),
            body: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 46,
                            width: 46,
                            decoration: BoxDecoration(
                              color: AppColor().primaryColor.withValues(
                                    alpha: 0.12,
                                  ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.account_balance_wallet_outlined,
                              color: AppColor().primaryColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'الرصيد الحالي',
                                  style: TextStyle(
                                    color: AppColor().descriptionColor,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  controller.statusRequest ==
                                          StatusRequest.success
                                      ? '${controller.balance} ل.س'
                                      : '—',
                                  style: TextStyle(
                                    color: AppColor().titleColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'اسحب للأسفل لتحديث الرصيد.',
                      style: TextStyle(color: AppColor().descriptionColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

