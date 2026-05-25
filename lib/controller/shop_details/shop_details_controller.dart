import 'package:app/controller/shop_details/shop_details_cart_ops.dart';
import 'package:app/controller/shop_details/shop_details_product_loader.dart';
import 'package:app/controller/shop_details/shop_details_reviews_mixin.dart';
import 'package:app/controller/shared/reviews_form_mixin.dart';
import 'package:app/controller/shop_details/shop_details_search_utils.dart';
import 'package:app/core/class/crud.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/function/handling_data.dart';
import 'package:app/core/services/session_service.dart';
import 'package:app/data/datasource/model/item_model.dart';
import 'package:app/data/datasource/model/store_model.dart';
import 'package:app/data/datasource/remot/store_details_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopDetailsController extends GetxController
    with ReviewsFormMixin, ShopDetailsReviewsMixin {
  ItemModel? shopItemSummary;
  StoreModel? store;
  @override
  late final int storeId;
  @override
  final SessionService session = Get.find<SessionService>();

  late TextEditingController searchController;
  StatusRequest statusRequest = StatusRequest.none;
  List<Products> _allProducts = [];
  List<Products> filteredProducts = [];
  int? selectedInnerCategoryId;

  late final ShopDetailsProductLoader _productLoader;

  @override
  void onInit() {
    super.onInit();
    _productLoader = ShopDetailsProductLoader(Get.find<Crud>());
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
      Get.snackbar('خطأ', 'معرّف المتجر غير صحيح');
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
    statusRequest = handlingData(response);

    if (statusRequest == StatusRequest.success &&
        response is Map<String, dynamic>) {
      store = StoreModel.fromJson(response);
      final loaded = await _productLoader.loadForStore(
        storeId: storeId,
        innerCategories: store?.innerCategories ?? [],
        fallbackFromStore: store?.products,
      );
      _allProducts = loaded;
      _applySearchFilter();
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

  void _onSearchChanged() {
    _applySearchFilter();
    update();
  }

  void _applySearchFilter() {
    filteredProducts = filterProductsByQuery(
      _allProducts,
      searchController.text,
    );
  }

  void selectInnerCategory(int? categoryId) {
    selectedInnerCategoryId = categoryId;
    update();
  }

  List<({int? id, String name})> get innerCategoryTabs {
    final tabs = <({int? id, String name})>[(id: null, name: 'الكل')];
    final fromStore = store?.innerCategories ?? [];

    if (fromStore.isNotEmpty) {
      for (final c in fromStore) {
        final id = c.id;
        final name = (c.name ?? '').trim();
        if (id != null && name.isNotEmpty) {
          tabs.add((id: id, name: name));
        }
      }
      return tabs;
    }

    final seen = <int>{};
    for (final p in filteredProducts) {
      final id = p.innerCategory?.id;
      final name = (p.innerCategory?.name ?? '').trim();
      if (id != null && name.isNotEmpty && seen.add(id)) {
        tabs.add((id: id, name: name));
      }
    }
    return tabs;
  }

  List<Products> get displayedProducts {
    if (selectedInnerCategoryId == null) return filteredProducts;
    return filteredProducts
        .where((p) => p.innerCategory?.id == selectedInnerCategoryId)
        .toList();
  }

  Map<int?, List<Products>> getProductsByCategory() {
    final Map<int?, List<Products>> categorized = {};
    for (final p in filteredProducts) {
      final innerId = p.innerCategory?.id;
      categorized.putIfAbsent(innerId, () => []);
      categorized[innerId]!.add(p);
    }
    return categorized;
  }

  int getProductQuantity(int productId) => shopCartQuantity(productId);

  void increaseQuantity(int productId) {
    shopCartIncrease(
      productId: productId,
      catalog: _allProducts,
      store: store,
      shopSummary: shopItemSummary,
      onUpdated: update,
    );
  }

  void decreaseQuantity(int productId) {
    shopCartDecrease(productId: productId, onUpdated: update);
  }

  int getProductPrice(Products product) {
    return product.salePrice ?? product.regularPrice ?? 0;
  }

  Future<void> refreshPage() => fetchStoreDetails();

  @override
  void onClose() {
    searchController.dispose();
    disposeReviewControllers();
    super.onClose();
  }
}
