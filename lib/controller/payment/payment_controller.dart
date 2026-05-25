import 'package:get/get.dart';
import '../../data/datasource/model/payment_method_model.dart';

class PaymentController extends GetxController {
  final methods = <PaymentMethodModel>[].obs;
  final selectedMethodId = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadMethods();
  }

  void loadMethods() {
    methods.value = [
      PaymentMethodModel(
        id: 'cash',
        title: 'الدفع عند الاستلام',
        icon: '💵',
        isOnline: false,
      ),
      PaymentMethodModel(
        id: 'card',
        title: 'بطاقة مصرفية',
        icon: '💳',
        isOnline: true,
      ),
      PaymentMethodModel(
        id: 'wallet',
        title: 'محفظة إلكترونية',
        icon: '📱',
        isOnline: true,
      ),
    ];
  }

  void selectMethod(String id) {
    selectedMethodId.value = id;
  }

  bool get isSelected => selectedMethodId.value != null;
}
