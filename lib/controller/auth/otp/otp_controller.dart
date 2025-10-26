import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OtpController extends GetxController {
  var otpCode = ''.obs;

  var isloading = false.obs;

  // هنا يجب ادخال عنوان الapi الصحيح للotp
  final String apiUrl = "";

  Future<void> verifyOtp() async {
    if (otpCode.value.length != 6) {
      Get.snackbar("تنبيه", "الرجاء ادخال رمز التفعيل الكامل");
      return;
    }

    try {
      isloading.value = true;

      final Map<String, dynamic> requestData = {
        'otp': otpCode.value,
        'phone': '+963900000000',
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );
      //===========بحالة نجاح التحقق ==========
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          Get.snackbar('نجاح ✅', data['message'] ?? 'تم التحقق بنجاح');
          // =========يمكنك الانتقال لصفحة أخرى:=========
          // Get.offAllNamed(AppRoutes.home);
        } else {
          Get.snackbar('فشل ❌', data['message'] ?? 'رمز غير صالح');
        }
      } else {
        Get.snackbar('خطأ ⚠️', 'فشل الاتصال بالسيرفر (${response.statusCode})');
      }
    } catch (e) {
      Get.snackbar("حدث خطأ أثناء التحقق", 'خطأ : $e');
    } finally {
      isloading.value = false;
    }
  }
}
