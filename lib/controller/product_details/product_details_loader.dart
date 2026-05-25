import 'package:app/core/class/crud.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/function/handling_data.dart';
import 'package:app/data/datasource/model/product_details_model.dart';
import 'package:app/data/datasource/remot/product_details_data.dart';
import 'package:get/get.dart';

class ProductDetailsLoadResult {
  const ProductDetailsLoadResult({
    required this.status,
    this.product,
    this.recommended = const [],
  });

  final StatusRequest status;
  final ProductDetailsModel? product;
  final List<RecommendedProductModel> recommended;
}

class ProductDetailsLoader {
  ProductDetailsLoader(this._data);

  final ProductDetailsData _data;

  Future<ProductDetailsLoadResult> load(int productId) async {
    final detailsRes = await _data.fetchProductDetails(productId);
    final detailsStat = handlingData(detailsRes);
    if (detailsStat != StatusRequest.success ||
        detailsRes is! Map<String, dynamic>) {
      return ProductDetailsLoadResult(
        status: detailsRes is StatusRequest
            ? detailsRes
            : StatusRequest.failure,
      );
    }

    final product = ProductDetailsModel.fromJson(detailsRes);
    final recommended = await _loadRecommended(productId);

    return ProductDetailsLoadResult(
      status: StatusRequest.success,
      product: product,
      recommended: recommended,
    );
  }

  Future<List<RecommendedProductModel>> _loadRecommended(int productId) async {
    final recRes = await _data.fetchRecommended(productId);
    final recStat = handlingData(recRes);
    if (recStat != StatusRequest.success) return [];

    List<dynamic> list = [];
    if (recRes is List) {
      list = recRes;
    } else if (recRes is Map) {
      final candidate = recRes['data'] ??
          recRes['recommended'] ??
          recRes['items'] ??
          recRes['products'];
      if (candidate is List) list = candidate;
    }

    return list
        .map(
          (e) => e is Map<String, dynamic>
              ? RecommendedProductModel.fromJson(e)
              : null,
        )
        .whereType<RecommendedProductModel>()
        .where((p) => (p.id ?? 0) > 0)
        .toList();
  }
}

ProductDetailsLoader productDetailsLoader() =>
    ProductDetailsLoader(ProductDetailsData(Get.find<Crud>()));
