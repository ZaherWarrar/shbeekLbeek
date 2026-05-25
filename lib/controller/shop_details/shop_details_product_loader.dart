import 'package:app/core/class/crud.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/function/handling_data.dart';
import 'package:app/data/datasource/model/item_model.dart';
import 'package:app/link_api.dart';

class ShopDetailsProductLoader {
  ShopDetailsProductLoader(this._crud);

  final Crud _crud;

  Future<List<Products>> loadForStore({
    required int storeId,
    required List<InnerCategory> innerCategories,
    List<Products>? fallbackFromStore,
  }) async {
    final products = <Products>[];

    for (final inner in innerCategories) {
      final innerId = inner.id;
      if (innerId == null) continue;

      final endpoint = '${ApiLinks.baseUrl}/stores/$storeId/products/$innerId';
      final eitherRes = await _crud.getData(endpoint, {});
      final stat = handlingData(eitherRes);

      if (stat != StatusRequest.success) continue;

      final body = eitherRes.fold((l) => l, (r) => r);
      products.addAll(_parseProductsBody(body));
    }

    if (products.isNotEmpty) return products;
    return List<Products>.from(fallbackFromStore ?? []);
  }

  static List<Products> _parseProductsBody(dynamic body) {
    if (body is Map<String, dynamic>) {
      final candidate =
          body['items'] ??
          body['products'] ??
          body['data'] ??
          body['data_items'];

      if (candidate is List) {
        return candidate
            .whereType<Map<String, dynamic>>()
            .map(Products.fromJson)
            .toList();
      }
      return [];
    }

    if (body is List) {
      return body
          .whereType<Map<String, dynamic>>()
          .map(Products.fromJson)
          .toList();
    }

    return [];
  }
}
