import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/function/handelingdata.dart';
import 'package:app/core/class/crud.dart';
import 'package:app/data/datasorce/model/product_details_model.dart';
import 'package:app/data/datasorce/remot/product_details_data.dart';
import 'package:get/get.dart';

class ProductDetailsController extends GetxController {
  ProductDetailsController({required this.productId});

  final int productId;

  final ProductDetailsData _data = ProductDetailsData(Get.find<Crud>());

  StatusRequest statusRequest = StatusRequest.none;
  ProductDetailsModel? product;
  List<RecommendedProductModel> recommended = [];

  Future<void> fetchAll() async {
    statusRequest = StatusRequest.loading;
    update();

    final detailsRes = await _data.fetchProductDetails(productId);
    final detailsStat = handelingData(detailsRes);
    if (detailsStat != StatusRequest.success || detailsRes is! Map<String, dynamic>) {
      statusRequest = detailsRes is StatusRequest ? detailsRes : StatusRequest.failure;
      update();
      return;
    }

    product = ProductDetailsModel.fromJson(detailsRes);

    final recRes = await _data.fetchRecommended(productId);
    final recStat = handelingData(recRes);
    if (recStat == StatusRequest.success) {
      List list = [];
      if (recRes is List) {
        list = recRes;
      } else if (recRes is Map) {
        final candidate = recRes['data'] ??
            recRes['recommended'] ??
            recRes['items'] ??
            recRes['products'];
        if (candidate is List) list = candidate;
      }
      recommended = list
          .map((e) =>
              e is Map<String, dynamic> ? RecommendedProductModel.fromJson(e) : null)
          .whereType<RecommendedProductModel>()
          .where((p) => (p.id ?? 0) > 0)
          .toList();
    }

    statusRequest = StatusRequest.success;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }
}

