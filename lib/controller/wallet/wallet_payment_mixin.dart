import 'package:app/core/class/crud.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/payment_method.dart';
import 'package:app/core/function/handling_data.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/data/datasource/remot/wallet_data.dart';
import 'package:get/get.dart';
import 'package:app/core/function/app_snackbar.dart';

mixin WalletPaymentMixin on GetxController {
  bool useWallet = false;
  int walletBalance = 0;
  StatusRequest walletStatus = StatusRequest.none;

  SessionService get walletSession => Get.find<SessionService>();
  WalletData get _walletData => WalletData(Get.find<Crud>());

  bool get isLoggedIn =>
      walletSession.isLoggedIn && !walletSession.isGuest;

  bool get canUseWallet =>
      isLoggedIn &&
      walletStatus == StatusRequest.success &&
      walletBalance > 0;

  String get paymentMethod => PaymentMethod.fromUseWallet(useWallet);

  String get walletStatusMessage {
    if (!isLoggedIn) return 'سجّل الدخول لاستخدام المحفظة';
    if (walletStatus == StatusRequest.loading) {
      return 'جاري تحميل الرصيد...';
    }
    if (walletStatus == StatusRequest.unauthorized) {
      return 'يجب تسجيل الدخول لاستخدام المحفظة';
    }
    if (walletStatus == StatusRequest.failure ||
        walletStatus == StatusRequest.offlinefailure) {
      return 'تعذّر تحميل رصيد المحفظة';
    }
    if (walletBalance <= 0) return 'لا يوجد رصيد في المحفظة';
    return '';
  }

  Future<void> fetchWalletBalance() async {
    if (!isLoggedIn) {
      walletBalance = 0;
      useWallet = false;
      walletStatus = StatusRequest.none;
      update();
      return;
    }

    walletStatus = StatusRequest.loading;
    update();

    final response = await _walletData.fetchBalance();
    walletStatus = handlingData(response);

    if (walletStatus == StatusRequest.success && response is Map) {
      final raw = response['balance'];
      walletBalance = raw is int
          ? raw
          : int.tryParse(raw?.toString() ?? '') ?? 0;
      if (walletBalance <= 0) useWallet = false;
    } else {
      walletBalance = 0;
      useWallet = false;
    }

    update();
  }

  void toggleUseWallet(bool value) {
    if (!canUseWallet) {
      AppSnackbar.show(
        'تنبيه',
        walletStatusMessage.isNotEmpty
            ? walletStatusMessage
            : 'لا يمكن استخدام المحفظة حالياً',
      );
      return;
    }

    useWallet = value;
    update();
  }

  void resetWalletPayment() {
    useWallet = false;
    update();
  }
}
