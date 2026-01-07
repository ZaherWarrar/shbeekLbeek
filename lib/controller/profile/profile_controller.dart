import 'package:get/get.dart';

class ProfileController extends GetxController {
  final userName = 'محمد علي'.obs;
  final email = 'user@example.com'.obs;

  void logout() {
    // TODO: logout logic
    Get.snackbar('تسجيل الخروج', 'تم تسجيل الخروج بنجاح');
  }
}
