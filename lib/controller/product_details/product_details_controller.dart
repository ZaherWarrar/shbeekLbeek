import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/function/handelingdata.dart';
import 'package:app/core/class/crud.dart';
import 'package:app/data/datasorce/model/product_details_model.dart';
import 'package:app/data/datasorce/model/product_review_model.dart';
import 'package:app/data/datasorce/remot/product_details_data.dart';
import 'package:app/data/datasorce/remot/product_reviews_data.dart';
import 'package:app/core/services/session_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsController extends GetxController {
  ProductDetailsController({required this.productId});

  final int productId;

  final ProductDetailsData _data = ProductDetailsData(Get.find<Crud>());
  final ProductReviewsData _reviewsData = ProductReviewsData(Get.find<Crud>());
  final SessionService session = Get.find<SessionService>();

  StatusRequest statusRequest = StatusRequest.none;
  ProductDetailsModel? product;
  List<RecommendedProductModel> recommended = [];
  ProductVariationModel? selectedVariation;
  final TextEditingController itemNotesController = TextEditingController();
  final TextEditingController reviewTextController = TextEditingController();
  int reviewRating = 5;
  ProductReviewsResponseModel? reviewsResponse;
  StatusRequest reviewsStatus = StatusRequest.none;
  bool isSubmittingReview = false;

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
    // اختيار افتراضي إذا كان المنتج variable وفيه خيارات
    if ((product?.type ?? '').toLowerCase() == 'variable' &&
        (product?.variations.isNotEmpty ?? false)) {
      selectedVariation ??= product!.variations.first;
    } else {
      selectedVariation = null;
    }

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

    await fetchReviews();

    statusRequest = StatusRequest.success;
    update();
  }

  Future<void> fetchReviews() async {
    reviewsStatus = StatusRequest.loading;
    update();

    final res = await _reviewsData.fetchProductReviews(productId);
    final stat = handelingData(res);
    if (stat != StatusRequest.success || res is! Map<String, dynamic>) {
      reviewsStatus = res is StatusRequest ? res : StatusRequest.failure;
      update();
      return;
    }
    reviewsResponse = ProductReviewsResponseModel.fromJson(res);
    reviewsStatus = StatusRequest.success;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  void selectVariation(ProductVariationModel v) {
    selectedVariation = v;
    update();
  }

  void setReviewRating(int value) {
    reviewRating = value.clamp(1, 5);
    update();
  }

  Future<void> submitReview() async {
    if (isSubmittingReview) return;
    if (session.token == null || (session.token?.isEmpty ?? true)) {
      Get.snackbar("تنبيه", "يجب تسجيل الدخول أولاً");
      Get.toNamed(AppRoutes.login);
      return;
    }
    isSubmittingReview = true;
    update();

    final text = reviewTextController.text.trim();
    final res = await _reviewsData.createReview(
      productId: productId,
      rating: reviewRating,
      text: text.isEmpty ? null : text,
    );

    final stat = handelingData(res);
    if (stat == StatusRequest.success) {
      reviewTextController.clear();
      reviewRating = 5;
      await fetchReviews();
      Get.back(); // close sheet/dialog
      Get.snackbar("تم", "تم إرسال تقييمك بنجاح");
    } else {
      Get.snackbar("خطأ", "فشل إرسال التقييم");
    }

    isSubmittingReview = false;
    update();
  }

  @override
  void onClose() {
    itemNotesController.dispose();
    reviewTextController.dispose();
    super.onClose();
  }
}

