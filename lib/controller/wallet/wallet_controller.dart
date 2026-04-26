import 'package:app/core/class/crud.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/function/handelingdata.dart';
import 'package:app/data/datasorce/remot/wallet_data.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  final WalletData _data = WalletData(Get.find<Crud>());

  StatusRequest statusRequest = StatusRequest.none;
  int balance = 0;

  Future<void> fetchBalance() async {
    statusRequest = StatusRequest.loading;
    update();

    final res = await _data.fetchBalance();
    final stat = handelingData(res);
    if (stat != StatusRequest.success || res is! Map<String, dynamic>) {
      final s = res is StatusRequest ? res : StatusRequest.failure;
      statusRequest = s;
      update();
      if (s == StatusRequest.unauthorized) {
        Get.snackbar("تنبيه", "يجب تسجيل الدخول أولاً");
        Get.toNamed(AppRoutes.login);
      }
      return;
    }

    balance = (res['balance'] is int)
        ? (res['balance'] as int)
        : int.tryParse(res['balance']?.toString() ?? '') ?? 0;

    statusRequest = StatusRequest.success;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    fetchBalance();
  }
}

