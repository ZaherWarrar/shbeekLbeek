import 'package:app/core/class/crud.dart';
import 'package:app/link_api.dart';

class SliderData {
  Crud crud;

  SliderData(this.crud);

  Future<Object> sliderData(int cityId) async {
    var response = await crud
        .getData("${ApiLinks.home}$cityId/slider", {});
    return response.fold((l) => l, (r) => r);
  }
}
