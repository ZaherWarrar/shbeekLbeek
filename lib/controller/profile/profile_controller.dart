import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/services/shaerd_preferances.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final userName = ''.obs;
  final email = ''.obs;
  final userId = ''.obs;
  final userRole = ''.obs;
  final userStatus = ''.obs;
  final isLoggedIn = false.obs;

  final UserPreferences _prefs = UserPreferences();

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
    loadUserData();
  }

  @override
  void onReady() {
    super.onReady();
    // تحديث حالة تسجيل الدخول عند العودة للصفحة
    checkLoginStatus();
    loadUserData();
  }

  // التحقق من حالة تسجيل الدخول
  Future<void> checkLoginStatus() async {
    final token = await _prefs.getToken();
    isLoggedIn.value = token != null && token.isNotEmpty;
  }

  // تحميل بيانات المستخدم من SharedPreferences
  void loadUserData() {
    final name = _prefs.getUserName();
    final userEmail = _prefs.getUserEmail();
    final id = _prefs.getUserId();

    userName.value = name ?? 'مستخدم';
    email.value = userEmail ?? '';
    userId.value = id ?? '';

    // تحميل role و status بشكل async
    _prefs.getUserRole().then((role) {
      userRole.value = role ?? '';
    });

    _prefs.getUserStatus().then((status) {
      userStatus.value = status ?? '';
    });
  }

  // تسجيل الدخول أو الخروج
  Future<void> handleAuthAction() async {
    if (isLoggedIn.value) {
      // تسجيل الخروج
      await logout();
    } else {
      // تسجيل الدخول
      Get.toNamed(AppRoutes.login);
    }
  }

  // تسجيل الخروج
  Future<void> logout() async {
    try {
      // عرض dialog تأكيد
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('تسجيل الخروج'),
          content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('إلغاء'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text(
                'تسجيل الخروج',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        // مسح جميع البيانات من SharedPreferences (يشمل token, user data, cart, orders)
        await _prefs.clearAll();

        // تحديث حالة تسجيل الدخول
        isLoggedIn.value = false;

        // الانتقال إلى صفحة تسجيل الدخول
        Get.offAllNamed(AppRoutes.login);

        Get.snackbar(
          'تسجيل الخروج',
          'تم تسجيل الخروج بنجاح',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تسجيل الخروج: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
