import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/function/handelingdata.dart';
import 'package:app/core/class/crud.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/data/datasorce/model/item_model.dart';
import 'package:app/data/datasorce/model/store_model.dart';
import 'package:app/data/datasorce/model/store_review_model.dart';
import 'package:app/data/datasorce/remot/store_details_data.dart';
import 'package:app/data/datasorce/remot/store_reviews_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopDetailsController extends GetxController {
  ItemModel? shopItemSummary;
  StoreModel? store;
  late final int storeId;
  late TextEditingController searchController;
  final SessionService session = Get.find<SessionService>();

  StatusRequest statusRequest = StatusRequest.none;
  List<Products> filteredProducts = [];
  StoreReviewsResponseModel? reviewsResponse;
  StatusRequest reviewsStatus = StatusRequest.none;
  final TextEditingController reviewTextController = TextEditingController();
  int reviewRating = 5;
  bool isSubmittingReview = false;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ItemModel) {
      shopItemSummary = args;
      storeId = args.id ?? -1;
    } else if (args is int) {
      storeId = args;
    } else {
      storeId = -1;
    }
    if (storeId <= 0) {
      Get.back();
      Get.snackbar("خطأ", "معرّف المتجر غير صحيح");
      return;
    }

    searchController = TextEditingController();
    filteredProducts = [];
    searchController.addListener(_onSearchChanged);
    fetchStoreDetails();
  }

  Future<void> fetchStoreDetails() async {
    statusRequest = StatusRequest.loading;
    update();

    final data = StoreDetailsData(Get.find<Crud>());
    final response = await data.storeDetails(storeId);
    statusRequest = handelingData(response);

    if (statusRequest == StatusRequest.success && response is Map<String, dynamic>) {
      store = StoreModel.fromJson(response);
      filteredProducts = store?.products ?? [];
      await fetchReviews();
      update();
      return;
    }

    if (response is StatusRequest) {
      statusRequest = response;
    } else {
      statusRequest = StatusRequest.failure;
    }
    update();
  }

  Future<void> fetchReviews() async {
    reviewsStatus = StatusRequest.loading;
    update();

    final data = StoreReviewsData(Get.find<Crud>());
    final res = await data.fetchStoreReviews(storeId);
    final stat = handelingData(res);
    if (stat != StatusRequest.success || res is! Map<String, dynamic>) {
      reviewsStatus = res is StatusRequest ? res : StatusRequest.failure;
      update();
      return;
    }
    reviewsResponse = StoreReviewsResponseModel.fromJson(res);
    reviewsStatus = StatusRequest.success;
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

    final data = StoreReviewsData(Get.find<Crud>());
    final text = reviewTextController.text.trim();
    final res = await data.createReview(
      storeId: storeId,
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

  void _onSearchChanged() {
    String query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredProducts = store?.products ?? [];
    } else {
      filteredProducts = (store?.products ?? []).where((product) {
        return (product.name ?? '').toLowerCase().contains(query);
      }).toList();
    }
    update();
  }

  Map<int?, List<Products>> getProductsByCategory() {
    // API الجديد لا يرجع category_id للمنتج، لذلك نجمع كل المنتجات ضمن مجموعة واحدة.
    return {null: filteredProducts};
  }

  int getProductQuantity(int productId) {
    if (!Get.isRegistered<CartController>()) {
      return 0;
    }
    final cartController = Get.find<CartController>();
    final cartItem = cartController.cartItems.firstWhere(
      (item) => item['productId'] == productId,
      orElse: () => <String, dynamic>{},
    );
    if (cartItem.isEmpty) return 0;
    return cartItem['quantity'] as int? ?? 0;
  }

  void increaseQuantity(int productId) {
    if (!Get.isRegistered<CartController>()) {
      Get.snackbar("خطأ", "السلة غير متاحة");
      return;
    }

    final product = (store?.products ?? []).firstWhere(
      (p) => p.id == productId,
      orElse: () => Products(),
    );

    if (product.id == null) {
      Get.snackbar("خطأ", "المنتج غير موجود");
      return;
    }

    final cartController = Get.find<CartController>();

    // التحقق من وجود طلب نشط
    if (cartController.hasActiveOrder()) {
      Get.snackbar(
        "تنبيه",
        "يوجد طلب قيد المعالجة. لا يمكن إضافة منتجات جديدة",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final existingIndex = cartController.cartItems.indexWhere(
      (item) => item['productId'] == productId,
    );

    if (existingIndex != -1) {
      cartController.increaseQuantity(productId);
    } else {
      final storeForCart = store ??
          StoreModel(
            id: shopItemSummary?.id,
            name: shopItemSummary?.name,
            imageUrl: shopItemSummary?.imageUrl,
            deliveryFee: shopItemSummary?.deliveryFee,
            minOrder: shopItemSummary?.minOrder,
            categoryName: shopItemSummary?.categoryName,
            rating: shopItemSummary?.rating,
            productsCount: shopItemSummary?.productsCount,
          );
      cartController.addItem(product, storeForCart, quantity: 1);
    }

    update();
  }

  void decreaseQuantity(int productId) {
    if (!Get.isRegistered<CartController>()) {
      return;
    }

    final cartController = Get.find<CartController>();
    final existingIndex = cartController.cartItems.indexWhere(
      (item) => item['productId'] == productId,
    );

    if (existingIndex != -1) {
      cartController.decreaseQuantity(productId);
      update();
    }
  }

  int getProductPrice(Products product) {
    return product.salePrice ?? product.regularPrice ?? 0;
  }

  /// إعادة تحميل الصفحة (سحب للتحديث)
  Future<void> refreshPage() async {
    await fetchStoreDetails();
  }

  @override
  void onClose() {
    searchController.dispose();
    reviewTextController.dispose();
    super.onClose();
  }
}
