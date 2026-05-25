import 'package:app/core/class/crud.dart';
import 'package:app/link_api.dart';

class AllItemData {
  Crud crud;

  AllItemData(this.crud);

  Future<Object> allItemData(int cityId, {int? categoryId}) async {
    var response = await crud
        .getData(
      categoryId == null
          ? "${ApiLinks.home}$cityId/stores"
          : "${ApiLinks.home}$cityId/stores/$categoryId",
      {},
    );
    return response.fold((l) => l, (r) => r);
  }
}
