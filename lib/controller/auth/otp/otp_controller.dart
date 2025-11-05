import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/function/handelingdata.dart';
import 'package:app/data/datasorce/remot/otp_data.dart';
import 'package:get/get.dart';

class OtpController extends GetxController {
  var otpCode = ''.obs;

  var isloading = false.obs;

  late String phoneNumber;
  late StatusRequest statusRequest;
  OtpData otpData = OtpData(Get.find());
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
        data = (response["user"]);
        // ignore: unused_local_variable
        var token = response["token"];
        Get.snackbar('نجاح ✅', 'تم التحقق بنجاح');
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
