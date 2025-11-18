import 'package:app/core/class/crud.dart';
import 'package:app/link_api.dart';

class TopOrderedData {
  Crud crud;

  TopOrderedData(this.crud);

  Future<Object> topOrderedData(int cityId) async {
    var response = await crud
        .getData("${ApiLinks.home}$cityId/top_ordered", {});
    return response.fold((l) => l, (r) => r);
  }
}
