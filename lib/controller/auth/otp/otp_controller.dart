import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/function/handelingdata.dart';
import 'package:app/core/services/shaerd_preferances.dart';
import 'package:app/data/datasorce/remot/otp_data.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  var otpCode = ''.obs;

  var isloading = false.obs;

  late String phoneNumber;
  late StatusRequest statusRequest;
  OtpData otpData = OtpData(Get.find());
  UserPreferences _prefs = UserPreferences();
  dynamic data;
  // هنا يجب ادخال عنوان الapi الصحيح للotp
  final String apiUrl = "";

  Future<void> verifyOtp() async {
    if (otpCode.value.length != 6) {
      Get.snackbar("تنبيه", "الرجاء ادخال رمز التفعيل الكامل");
      return;
    }
    try {
      statusRequest = StatusRequest.loading;
      data = [];
      update();
      final response = await otpData.otpData(otpCode.value, phoneNumber);
      statusRequest = handelingData(response);
      if (statusRequest == StatusRequest.success) {
        // التحقق من أن response هو Map
        if (response is Map<String, dynamic>) {
          try {
            // حفظ Token
            if (response.containsKey("token") && response["token"] != null) {
              final token = response["token"].toString();
              await _prefs.saveToken(token);
            }

            // حفظ بيانات المستخدم
            if (response.containsKey("user") && response["user"] is Map) {
              final userData = response["user"] as Map<String, dynamic>;

              // حفظ user_id
              if (userData.containsKey("id")) {
                final userId = userData["id"].toString();
                await _prefs.saveUserId(userId);
              }

              // حفظ name
              if (userData.containsKey("name") && userData["name"] != null) {
                await _prefs.saveUserName(userData["name"].toString());
              }

              // حفظ email
              if (userData.containsKey("email") && userData["email"] != null) {
                await _prefs.saveUserEmail(userData["email"].toString());
              }

              // حفظ phone_number (موجود بالفعل لكن يمكن حفظه للتأكد)
              if (userData.containsKey("phone_number") &&
                  userData["phone_number"] != null) {
                // يمكن إضافة method لحفظ phone_number إذا لزم
              }

              // حفظ role إذا كان موجوداً
              if (userData.containsKey("role") && userData["role"] != null) {
                await _prefs.saveUserRole(userData["role"].toString());
              }

              // حفظ status إذا كان موجوداً
              if (userData.containsKey("status") &&
                  userData["status"] != null) {
                await _prefs.saveUserStatus(userData["status"].toString());
              }

              data = userData;
            }

            Get.snackbar('نجاح ✅', 'تم التحقق بنجاح');
            Get.toNamed(AppRoutes.home);
          } catch (e) {
            Get.snackbar("خطأ", "حدث خطأ أثناء حفظ البيانات: ${e.toString()}");
          }
        } else {
          Get.snackbar('خطأ', 'استجابة غير صحيحة من الخادم');
        }
      } else {
        Get.snackbar('فشل ❌', 'رمز غير صالح');
      }
      update();
    } catch (e) {
      Get.snackbar("حدث حطأ غير معروف ", "خطأ");
    }
  }

  @override
  void onInit() {
    phoneNumber = Get.arguments["phone_number"];
    super.onInit();
  }
}
