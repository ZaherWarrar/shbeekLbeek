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
    final categoryIds = innerCategories
        .map((inner) => inner.id)
        .whereType<int>()
        .toList();
    final products = <Products>[];

    const batchSize = 6;
    for (var start = 0; start < categoryIds.length; start += batchSize) {
      final end = start + batchSize > categoryIds.length
          ? categoryIds.length
          : start + batchSize;
      final batch = await Future.wait(
        categoryIds
            .sublist(start, end)
            .map((innerId) => _fetchCategoryProducts(storeId, innerId)),
      );
      for (final items in batch) {
        products.addAll(items);
      }
    }

    if (products.isNotEmpty) return products;
    return List<Products>.from(fallbackFromStore ?? []);
  }

  Future<List<Products>> _fetchCategoryProducts(
    int storeId,
    int innerId,
  ) async {
    final endpoint = '${ApiLinks.baseUrl}/stores/$storeId/products/$innerId';
    final eitherRes = await _crud.getData(endpoint, {});
    if (handlingData(eitherRes) != StatusRequest.success) return const [];

    final body = eitherRes.fold((l) => l, (r) => r);
    return _parseProductsBody(body);
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
