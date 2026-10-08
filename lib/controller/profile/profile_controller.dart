import 'package:app/controller/choose_city/choose_city_controller.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/function/handling_data.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/data/datasource/model/city_model.dart';
import 'package:app/data/datasource/remot/cities_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/core/function/app_snackbar.dart';

class ProfileController extends GetxController {
  final userName = ''.obs;
  final email = ''.obs;
  final userId = ''.obs;
  final userRole = ''.obs;
  final userStatus = ''.obs;
  final isLoggedIn = false.obs;
  bool showChangeCity = false;

  final SessionService session = Get.find<SessionService>();

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
    loadUserData();
    loadCities();
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
  Future<void> loadCities() async {
    if (Get.isRegistered<ChooseCityController>()) {
      final cities = Get.find<ChooseCityController>().cities;
      if (cities.isNotEmpty) {
        showChangeCity = cities.length > 1;
        update();
        return;
      }
    }

    final response = await CitiesData(Get.find()).fetchCities();
    if (handlingData(response) != StatusRequest.success) {
      showChangeCity = false;
      update();
      return;
    }

    showChangeCity = _parseCities(response).length > 1;
    update();
  }

  List<CityModel> _parseCities(Object response) {
    if (response is List) {
      return response
          .whereType<Map>()
          .map((item) => CityModel.fromJson(Map<String, dynamic>.from(item)))
          .where((city) => city.id > 0 && city.name.isNotEmpty)
          .toList();
    }

    if (response is Map) {
      final data = response['data'] ?? response['cities'];
      if (data is List) return _parseCities(data);
    }

    return [];
  }

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

        AppSnackbar.show(
          'تسجيل الخروج',
          'تم تسجيل الخروج بنجاح',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      AppSnackbar.show(
        'خطأ',
        'حدث خطأ أثناء تسجيل الخروج: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}