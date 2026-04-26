import 'package:app/core/class/crud.dart';
import 'package:app/link_api.dart';

class SliderData {
  Crud crud;

  SliderData(this.crud);

  Future<Object> sliderData(int cityId, {int? categoryId}) async {
    var response = await crud
        .getData(
      categoryId == null
          ? "${ApiLinks.home}$cityId/slider"
          : "${ApiLinks.home}$cityId/slider/$categoryId",
      {},
    );
    return response.fold((l) => l, (r) => r);
  }
}
