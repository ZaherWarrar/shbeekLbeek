import 'package:app/core/class/crud.dart';
import 'package:app/link_api.dart';

class StoreDetailsData {
  final Crud crud;

  StoreDetailsData(this.crud);

  Future<Object> storeDetails(int storeId) async {
    final response = await crud.getData('${ApiLinks.store}/$storeId', {});
    return response.fold((l) => l, (r) => r);
  }
}

