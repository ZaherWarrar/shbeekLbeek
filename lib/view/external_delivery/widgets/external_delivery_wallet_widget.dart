import 'package:app/controller/external_delivery/external_delivery_controller.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/view/shared/wallet_payment_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExternalDeliveryWalletWidget extends StatelessWidget {
  const ExternalDeliveryWalletWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ExternalDeliveryController>(
      builder: (controller) {
        return WalletPaymentTile(
          useWallet: controller.useWallet,
          canUseWallet: controller.canUseWallet,
          isLoggedIn: controller.isLoggedIn,
          isLoading: controller.walletStatus == StatusRequest.loading,
          statusMessage: controller.walletStatusMessage,
          walletBalance: controller.walletBalance,
          onToggle: controller.toggleUseWallet,
          onLogin: () => Get.toNamed(AppRoutes.login),
        );
      },
    );
  }
}
