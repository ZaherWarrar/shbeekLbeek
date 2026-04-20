import 'package:app/core/class/crud.dart';
import 'package:app/link_api.dart';

class ProductDetailsData {
  final Crud crud;

  ProductDetailsData(this.crud);

  Future<Object> fetchProductDetails(int productId) async {
    final response = await crud.getData(
      '${ApiLinks.productDetails}/$productId',
      {},
    );
    return response.fold((l) => l, (r) => r);
  }

  Future<Object> fetchRecommended(int productId) async {
    final response = await crud.getData(
      '${ApiLinks.productRecommended}/$productId',
      {},
    );
    return response.fold((l) => l, (r) => r);
  }
}

