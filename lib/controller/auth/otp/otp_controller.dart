import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/function/handelingdata.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/data/datasorce/remot/otp_data.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  var otpCode = ''.obs;

  /// حالة التحميل للزر
  var isLoading = false.obs;

  late String phoneNumber;
  late StatusRequest statusRequest;

  final OtpData otpData = OtpData(Get.find());
  final session = Get.find<SessionService>();


  @override
  void onInit() {
    phoneNumber = Get.arguments['phone_number'];
    super.onInit();
  }

  Future<void> verifyOtp() async {
    if (otpCode.value.length != 6) {
      Get.snackbar("تنبيه", "الرجاء إدخال رمز التفعيل الكامل");
      return;
    }

    isLoading.value = true;

    try {
      final response = await otpData.otpData(otpCode.value, phoneNumber);
      statusRequest = handelingData(response);

      if (statusRequest == StatusRequest.success &&
          response is Map<String, dynamic>) {

        // ====== حفظ التوكن ======
        if (response.containsKey('token')) {
          await session.saveLogin(
            token: response['token'].toString(),
            userId: response['user']['id'].toString(),
          );
        }

        // ====== حفظ بيانات المستخدم ======
        if (response.containsKey('user')) {
          final user = response['user'] as Map<String, dynamic>;

          if (user.containsKey('name')) {
            await session.saveUserName(user['name']);
          }

          if (user.containsKey('email')) {
            await session.saveUserEmail(user['email']);
          }

          if (user.containsKey('role')) {
            await session.saveUserRole(user['role']);
          }

          if (user.containsKey('status')) {
            await session.saveUserStatus(user['status']);
          }
        }

        // المستخدم لم يعد ضيف
        await session.setGuest(false);

        Get.snackbar('نجاح', 'تم التحقق بنجاح');
        Get.offAllNamed(AppRoutes.start);

      } else {
        Get.snackbar('فشل', 'رمز غير صالح');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ غير معروف: ${e.toString()}');
    }

    isLoading.value = false;
  }
}