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
  final List<ProductVariationModel> selectedVariations = [];
  final TextEditingController itemNotesController = TextEditingController();
  final TextEditingController reviewTextController = TextEditingController();
  int reviewRating = 5;
  ProductReviewsResponseModel? reviewsResponse;
  StatusRequest reviewsStatus = StatusRequest.none;
  bool isSubmittingReview = false;
  int? editingReviewId;

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
    // اختيار افتراضي إذا كان المنتج variable وفيه خيارات (متعدد الاختيار)
    if ((product?.type ?? '').toLowerCase() == 'variable' &&
        (product?.variations.isNotEmpty ?? false)) {
      if (selectedVariations.isEmpty) {
        selectedVariations.add(product!.variations.first);
      }
    } else {
      selectedVariations.clear();
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

  void toggleVariation(ProductVariationModel v) {
    final idx = selectedVariations.indexWhere((e) => e.id == v.id && e.name == v.name);
    if (idx == -1) {
      selectedVariations.add(v);
    } else {
      selectedVariations.removeAt(idx);
    }
    update();
  }

  String? get selectedVariationNameCombined {
    final names = selectedVariations
        .map((e) => (e.name ?? '').trim())
        .where((s) => s.isNotEmpty)
        .toList();
    if (names.isEmpty) return null;
    return names.join(', ');
  }

  bool get hasSelectedVariations => selectedVariationNameCombined != null;

  void clearVariationsSelection() {
    selectedVariations.clear();
    update();
  }

  void setReviewRating(int value) {
    reviewRating = value.clamp(1, 5);
    update();
  }

  Future<void> submitReview() async {
    if (isSubmittingReview) return;
    if (!session.isLoggedIn) {
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
      Get.back();
      Get.snackbar("تم", "تم إرسال تقييمك بنجاح");
    } else {
      Get.snackbar("خطأ", "فشل إرسال التقييم");
    }

    isSubmittingReview = false;
    update();
  }

  void beginEditReview(ProductReviewModel review) {
    editingReviewId = review.id;
    reviewRating = (review.rating ?? 5).clamp(1, 5);
    reviewTextController.text = (review.text ?? '').toString();
    update();
  }

  void resetReviewForm() {
    editingReviewId = null;
    reviewRating = 5;
    reviewTextController.clear();
    update();
  }

  Future<void> updateReview() async {
    final rid = editingReviewId;
    if (rid == null || rid <= 0) return;
    if (isSubmittingReview) return;
    if (!session.isLoggedIn) {
      Get.snackbar("تنبيه", "يجب تسجيل الدخول أولاً");
      Get.toNamed(AppRoutes.login);
      return;
    }
    isSubmittingReview = true;
    update();

    final text = reviewTextController.text.trim();
    final res = await _reviewsData.updateReview(
      reviewId: rid,
      rating: reviewRating,
      text: text.isEmpty ? null : text,
    );
    final stat = handelingData(res);
    if (stat == StatusRequest.success) {
      await fetchReviews();
      resetReviewForm();
      Get.back();
      Get.snackbar("تم", "تم تعديل التقييم بنجاح");
    } else {
      Get.snackbar("خطأ", "فشل تعديل التقييم");
    }

    isSubmittingReview = false;
    update();
  }

  Future<void> deleteReview(int reviewId) async {
    if (reviewId <= 0) return;
    if (isSubmittingReview) return;
    if (!session.isLoggedIn) {
      Get.snackbar("تنبيه", "يجب تسجيل الدخول أولاً");
      Get.toNamed(AppRoutes.login);
      return;
    }
    isSubmittingReview = true;
    update();

    final res = await _reviewsData.deleteReview(reviewId);
    final stat = handelingData(res);
    if (stat == StatusRequest.success) {
      await fetchReviews();
      Get.snackbar("تم", "تم حذف التقييم");
    } else {
      Get.snackbar("خطأ", "فشل حذف التقييم");
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

