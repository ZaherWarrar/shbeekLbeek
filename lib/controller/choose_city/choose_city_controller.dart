import 'package:app/core/services/session_service.dart';
import 'package:get/get.dart';

class ChooseCityController extends GetxController {
  final session = Get.find<SessionService>();

  final RxnInt selectedCityId = RxnInt();
  final RxnString selectedCityName = RxnString();

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

  Future<void> clearSelection() async {
    selectedCityId.value = null;
    selectedCityName.value = null;

    await session.clearCity();
  }

  bool get hasSelected => selectedCityId.value != null;
}
