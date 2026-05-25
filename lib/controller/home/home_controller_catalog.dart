import 'package:app/controller/home/home_controller.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/function/handling_data.dart';
import 'package:app/data/datasource/model/item_model.dart';
import 'package:app/data/datasource/model/main_categores.dart';

extension HomeCatalogLogic on HomeControllerImp {
  Future<void> runFetchMainCategores() async {
    mainCatStat = StatusRequest.loading;
    update();
    final response = await mainCategoresData.mainCategoresData(cityId);
    mainCatStat = handlingData(response);
    if (mainCatStat == StatusRequest.success) {
      if (response is List) {
        mainCat = [];
        for (var item in response) {
          mainCat.add(MainCategoriesModel.fromJson(item));
        }
      }
      update();
    } else {
      mainCatStat = StatusRequest.failure;
      update();
    }
  }

  Future<void> runFetchAllItem() async {
    allItemState = StatusRequest.loading;
    update();
    final response =
        await allItemData.allItemData(cityId, categoryId: selectedCategoryId);
    allItemState = handlingData(response);
    if (allItemState == StatusRequest.success) {
      List<dynamic> itemList = [];

      if (response is List) {
        itemList = response;
      } else if (response is Map && response.containsKey('data')) {
        itemList = response['data'] as List<dynamic>;
      }

      items = [];
      for (var item in itemList) {
        items.add(ItemModel.fromJson(item));
      }
      update();
    } else {
      allItemState = StatusRequest.failure;
      update();
    }
  }
}
