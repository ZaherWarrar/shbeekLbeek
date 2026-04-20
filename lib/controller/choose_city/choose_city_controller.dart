import 'package:app/controller/home/home_controller.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/services/session_service.dart';
import 'package:get/get.dart';

class ChooseCityController extends GetxController {
  final session = Get.find<SessionService>();

  final RxnInt selectedCityId = RxnInt();
  final RxnString selectedCityName = RxnString();
  final isSelectingCity = false.obs;

  @override
  void onInit() {
    selectedCityId.value = session.cityId;
    selectedCityName.value = session.cityName;
    super.onInit();
  }

  Future<void> selectCity({
    required int id,
    required String name,
  }) async {
    selectedCityId.value = id;
    selectedCityName.value = name;

    await session.saveCity(id, name);
  }

  /// اختيار المدينة ثم تحميل بيانات الصفحة الرئيسية ثم الانتقال.
  Future<void> selectCityAndGo({
    required int id,
    required String name,
  }) async {
    if (isSelectingCity.value) return;
    isSelectingCity.value = true;
    try {
      await selectCity(id: id, name: name);
      if (Get.isRegistered<HomeControllerImp>()) {
        final home = Get.find<HomeControllerImp>();
        await Future.wait([
          home.fetchSliders(),
          home.fetchMainCategores(),
          home.fetchAllItem(),
          home.fetchHomeSection(),
        ]);
      }
      Get.offAllNamed(AppRoutes.start);
    } finally {
      isSelectingCity.value = false;
    }
  }

  Future<void> clearSelection() async {
    selectedCityId.value = null;
    selectedCityName.value = null;

    await session.clearCity();
  }

  bool get hasSelected => selectedCityId.value != null;
}
