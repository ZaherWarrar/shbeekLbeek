import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/services/session_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final userName = ''.obs;
  final email = ''.obs;
  final userId = ''.obs;
  final userRole = ''.obs;
  final userStatus = ''.obs;
  final isLoggedIn = false.obs;

  final SessionService session = Get.find<SessionService>();

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
    loadUserData();
  }

  @override
  void onReady() {
    super.onReady();
    checkLoginStatus();
    loadUserData();
  }

  // ================================
  // التحقق من حالة تسجيل الدخول
  // ================================
  void checkLoginStatus() {
    isLoggedIn.value = session.token != null && session.token!.isNotEmpty;
  }

  // ================================
  // تحميل بيانات المستخدم
  // ================================
  void loadUserData() {
    userName.value = session.userName ?? 'مستخدم';
    email.value = session.userEmail ?? '';
    userId.value = session.userId ?? '';
    userRole.value = session.userRole ?? '';
    userStatus.value = session.userStatus ?? '';
  }

  // ================================
  // تسجيل الدخول أو الخروج
  // ================================
  Future<void> handleAuthAction() async {
    if (isLoggedIn.value) {
      await logout();
    } else {
      Get.toNamed(AppRoutes.login);
    }
  }

  // ================================
  // تسجيل الخروج
  // ================================
  Future<void> logout() async {
    try {
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
        // مسح بيانات الجلسة فقط
        await session.logout();
        await session.clearCity();
        await session.clearActiveOrder();

        isLoggedIn.value = false;

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