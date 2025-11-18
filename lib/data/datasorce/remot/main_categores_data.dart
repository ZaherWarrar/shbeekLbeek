import 'package:app/core/class/crud.dart';
import 'package:app/link_api.dart';

class MainCategoresData {
  Crud crud;

  MainCategoresData(this.crud);

  Future<Object> mainCategoresData(int cityId) async {
    var response = await crud
        .getData("${ApiLinks.home}$cityId/root_categories", {});
    return response.fold((l) => l, (r) => r);
  }
}
