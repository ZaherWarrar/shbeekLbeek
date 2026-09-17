import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:app/core/function/app_snackbar.dart';

void showOrderError(StatusRequest status) {
  switch (status) {
    case StatusRequest.unauthorized:
      AppSnackbar.show('خطأ', 'غير مصرح لك. يرجى تسجيل الدخول');
      Get.toNamed(AppRoutes.login);
      break;
    case StatusRequest.forbidden:
      AppSnackbar.show('خطأ', 'غير مسموح لك بهذا الإجراء');
      break;
    case StatusRequest.notFound:
      AppSnackbar.show('خطأ', 'الطلب غير موجود');
      break;
    case StatusRequest.serverfailure:
      AppSnackbar.show('خطأ', 'خطأ في الخادم');
      break;
    case StatusRequest.offlinefailure:
      AppSnackbar.show('خطأ', 'لا يوجد اتصال بالإنترنت');
      break;
    default:
      AppSnackbar.show('خطأ', 'فشل في العملية');
  }
}
