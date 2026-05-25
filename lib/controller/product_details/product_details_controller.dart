import 'package:app/controller/product_details/product_details_loader.dart';
import 'package:app/controller/product_details/product_details_reviews_mixin.dart';
import 'package:app/controller/shared/reviews_form_mixin.dart';
import 'package:app/controller/product_details/product_details_variations.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/data/datasource/model/product_details_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsController extends GetxController
    with ReviewsFormMixin, ProductDetailsReviewsMixin {
  ProductDetailsController({required this.productId});

  @override
  final int productId;

  @override
  final SessionService session = Get.find<SessionService>();

  final ProductDetailsLoader _loader = productDetailsLoader();

  StatusRequest statusRequest = StatusRequest.none;
  ProductDetailsModel? product;
  List<RecommendedProductModel> recommended = [];
  final List<ProductVariationModel> selectedVariations = [];
  final TextEditingController itemNotesController = TextEditingController();

  Future<void> fetchAll() async {
    statusRequest = StatusRequest.loading;
    update();

    final result = await _loader.load(productId);
    if (result.status != StatusRequest.success || result.product == null) {
      statusRequest = result.status;
      update();
      return;
    }

    product = result.product;
    recommended = result.recommended;
    applyDefaultVariations(
      product: product,
      selectedVariations: selectedVariations,
    );

    await fetchReviews();
    statusRequest = StatusRequest.success;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  void toggleVariation(ProductVariationModel v) {
    toggleVariationSelection(
      selected: selectedVariations,
      variation: v,
    );
    update();
  }

  String? get selectedVariationNameCombined =>
      combinedVariationNames(selectedVariations);

  bool get hasSelectedVariations => selectedVariationNameCombined != null;

  void clearVariationsSelection() {
    selectedVariations.clear();
    update();
  }

  @override
  void onClose() {
    itemNotesController.dispose();
    disposeReviewControllers();
    super.onClose();
  }
}
