import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/function/handling_data.dart';
import 'package:app/data/datasource/remot/register_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/core/function/app_snackbar.dart';

abstract class RegisterController extends GetxController {
  Future<void> register();
  void goToLogin();
}

class RegisterControllerImb extends RegisterController {
  // ================= Text form fields =================
  GlobalKey<FormState> formStat = GlobalKey<FormState>();
  late TextEditingController name;
  late TextEditingController phoneNumber;

  // ================= Privacy agreement =================
  bool isAgree = false;

  // ================= Data response =================
  RegisterData registerData = RegisterData(Get.find());
  StatusRequest statusRequest = StatusRequest.none;

  // ================= Error messages =================
  final RxString phoneError = ''.obs;
  final RxString nameError = ''.obs;
  final RxBool showAgreeError = false.obs;

  // ================= Validators =================

  // ✅ Validation فوري للاسم
  void validateNameOnChange(String value) {
    if (value.isEmpty) {
      nameError.value = "الرجاء إدخال الاسم";
    } else if (value.length < 3) {
      nameError.value = "الاسم يجب أن يكون 3 أحرف على الأقل";
    } else if (value.length > 50) {
      nameError.value = "الاسم طويل جداً (حد أقصى 50 حرف)";
    } else {
      nameError.value = '';
    }
    update();
  }

  // ✅ Validation فوري لرقم الهاتف
  void validatePhoneOnChange(String value) {
    String cleanPhone = value.replaceAll(RegExp(r'\s+'), '');

    if (cleanPhone.isEmpty) {
      phoneError.value = "الرجاء إدخال رقم الهاتف";
    } else if (cleanPhone.length < 10) {
      phoneError.value = "رقم الهاتف يجب أن يتكون من 10 أرقام (09XXXXXXXX)";
    } else if (cleanPhone.length > 10) {
      phoneError.value = "رقم الهاتف طويل جداً (10 أرقام كحد أقصى)";
    } else if (!RegExp(r'^09[0-9]{8}$').hasMatch(cleanPhone)) {
      phoneError.value =
          "رقم هاتف غير صحيح\n📱 يجب أن يبدأ بـ 09\n🔢 مثال: 0991234567";
    } else {
      phoneError.value = '';
    }
    update();
  }

  // ✅ Validation النهائي عند الضغط على زر التسجيل
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "الرجاء إدخال الاسم";
    }
    if (value.length < 3) {
      return "الاسم يجب أن يكون 3 أحرف على الأقل";
    }
    if (value.length > 50) {
      return "الاسم طويل جداً";
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "الرجاء إدخال رقم الهاتف";
    }

    String cleanPhone = value.replaceAll(RegExp(r'\s+'), '');

    if (cleanPhone.length < 10) {
      return "رقم الهاتف يجب أن يتكون من 10 أرقام";
    }

    if (cleanPhone.length > 10) {
      return "رقم الهاتف طويل جداً (10 أرقام كحد أقصى)";
    }

    if (!RegExp(r'^09[0-9]{8}$').hasMatch(cleanPhone)) {
      return "رقم هاتف غير صحيح\nيجب أن يبدأ بـ 09\nمثال: 0991234567";
    }

    return null;
  }

  String formatPhoneNumber(String phone) {
    String cleanPhone = phone.replaceAll(RegExp(r'\s+'), '');

    // إزالة +963 إذا وجدت
    if (cleanPhone.startsWith('+963')) {
      cleanPhone = cleanPhone.substring(4);
    }

    // إذا بدأ بـ 9 وليس 09، أضف 0 في البداية
    if (cleanPhone.startsWith('9') &&
        !cleanPhone.startsWith('09') &&
        cleanPhone.length == 9) {
      cleanPhone = '0$cleanPhone';
    }

    return cleanPhone;
  }

  void toggleAgree(bool? value) {
    isAgree = value ?? false;
    if (isAgree) {
      showAgreeError.value = false;
    }
    update();
  }

  // ✅ التحقق من صحة النموذج بالكامل
  bool isFormValid() {
    bool isNameValid =
        name.text.isNotEmpty && name.text.length >= 3 && name.text.length <= 50;
    String cleanPhone = phoneNumber.text.replaceAll(RegExp(r'\s+'), '');
    bool isPhoneValid = RegExp(r'^09[0-9]{8}$').hasMatch(cleanPhone);
    bool isAgreed = isAgree;

    return isNameValid && isPhoneValid && isAgreed;
  }

  @override
  Future<void> register() async {
    // ✅ التحقق من الفورم
    if (!formStat.currentState!.validate()) {
      AppSnackbar.show(
        "تنبيه",
        "يرجى تصحيح الأخطاء في الحقول",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade900,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // ✅ التحقق من الموافقة على سياسة الخصوصية
    if (!isAgree) {
      showAgreeError.value = true;
      update();
      AppSnackbar.show(
        "تنبيه",
        "يجب الموافقة على سياسة الخصوصية أولاً",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade100,
        colorText: Colors.orange.shade900,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // ✅ إخفاء خطأ الموافقة
    showAgreeError.value = false;
    update();

    // ✅ تنسيق رقم الهاتف قبل الإرسال
    String formattedPhone = formatPhoneNumber(phoneNumber.text);

    print("📱 Sending: ${name.text}, $formattedPhone");

    // ✅ تغيير الحالة إلى تحميل
    statusRequest = StatusRequest.loading;
    update();

    try {
      var response = await registerData.registerData(name.text, formattedPhone);

      statusRequest = handlingData(response);

      if (statusRequest == StatusRequest.success) {
        final registeredName = name.text;

        // ✅ تنظيف الحقول بعد النجاح
        name.clear();
        phoneNumber.clear();
        nameError.value = '';
        phoneError.value = '';
        isAgree = false;
        showAgreeError.value = false;
        update();

        Get.offAllNamed(
          AppRoutes.otp,
          arguments: {
            "phone_number": formattedPhone,
            "name": registeredName,
          },
        );
      } else {
        String errorMessage = "حدث خطأ أثناء إنشاء الحساب، حاول مرة أخرى";

        if (response is Map) {
          if (response.containsKey('message')) {
            errorMessage = response['message'].toString();
          } else if (response.containsKey('error')) {
            errorMessage = response['error'].toString();
          } else if (response.containsKey('errors')) {
            var errors = response['errors'];
            if (errors is Map) {
              errorMessage = errors.values.join('\n');
            } else if (errors is List) {
              errorMessage = errors.join('\n');
            }
          }
        }

        if (statusRequest == StatusRequest.serverfailure) {
          errorMessage = "مشكلة في الخادم، حاول مرة أخرى لاحقاً";
        } else if (statusRequest == StatusRequest.offlinefailure) {
          errorMessage = "لا يوجد اتصال بالإنترنت، تأكد من اتصالك";
        }

        print("❌ Error: $errorMessage");
        print("❌ Status: $statusRequest");
        print("❌ Response: $response");

        Get.defaultDialog(
          title: "فشل التسجيل",
          middleText: errorMessage,
          textConfirm: "حاول مرة أخرى",
          confirmTextColor: Colors.white,
          onConfirm: () {
            Get.back();
            statusRequest = StatusRequest.none;
            update();
          },
        );
      }
    } catch (e) {
      statusRequest = StatusRequest.failure;
      update();

      print("❌ Exception: $e");

      Get.defaultDialog(
        title: "خطأ غير متوقع",
        middleText: "حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى",
        textConfirm: "حسناً",
        confirmTextColor: Colors.white,
      );
    }

    update();
  }

  @override
  void onInit() {
    name = TextEditingController();
    phoneNumber = TextEditingController();

    name.addListener(() {
      validateNameOnChange(name.text);
    });

    phoneNumber.addListener(() {
      validatePhoneOnChange(phoneNumber.text);
    });

    super.onInit();
  }

  @override
  void dispose() {
    name.dispose();
    phoneNumber.dispose();
    super.dispose();
  }

  @override
  void goToLogin() {
    statusRequest = StatusRequest.none;
    name.clear();
    phoneNumber.clear();
    nameError.value = '';
    phoneError.value = '';
    isAgree = false;
    showAgreeError.value = false;
    update();
    Get.offAllNamed(AppRoutes.login);
  }
}
