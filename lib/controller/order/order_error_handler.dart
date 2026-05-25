import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:get/get.dart';

void showOrderError(StatusRequest status) {
  switch (status) {
    case StatusRequest.unauthorized:
      Get.snackbar('خطأ', 'غير مصرح لك. يرجى تسجيل الدخول');
      Get.toNamed(AppRoutes.login);
      break;
    case StatusRequest.forbidden:
      Get.snackbar('خطأ', 'غير مسموح لك بهذا الإجراء');
      break;
    case StatusRequest.notFound:
      Get.snackbar('خطأ', 'الطلب غير موجود');
      break;
    case StatusRequest.serverfailure:
      Get.snackbar('خطأ', 'خطأ في الخادم');
      break;
    case StatusRequest.offlinefailure:
      Get.snackbar('خطأ', 'لا يوجد اتصال بالإنترنت');
      break;
    default:
      Get.snackbar('خطأ', 'فشل في العملية');
  }
}
