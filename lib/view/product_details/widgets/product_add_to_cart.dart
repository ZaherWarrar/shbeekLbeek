import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/controller/product_details/product_details_controller.dart';
import 'package:app/data/datasource/model/item_model.dart';
import 'package:app/data/datasource/model/product_details_model.dart';
import 'package:app/data/datasource/model/store_model.dart';
import 'package:get/get.dart';

void addProductToCart({
  required CartController cart,
  required ProductDetailsController controller,
  required ProductDetailsModel? product,
  required int safeId,
  required bool isVariable,
  required String? selectedVariationName,
  required int? effectiveStoreId,
  required String? effectiveStoreName,
  required String? effectiveStoreImage,
  required String? effectiveStoreDeliveryFee,
}) {
  if (product == null) return;
  if (isVariable && !controller.hasSelectedVariations) {
    Get.snackbar('تنبيه', 'الرجاء اختيار خيار المنتج أولاً');
    return;
  }
  final storeId = effectiveStoreId;
  if (storeId == null || storeId <= 0) {
    Get.snackbar('خطأ', 'لا يمكن إضافة المنتج بدون معرّف المتجر');
    return;
  }

  final shop = StoreModel(
    id: storeId,
    name: effectiveStoreName ?? 'متجر',
    imageUrl: effectiveStoreImage,
    deliveryFee: effectiveStoreDeliveryFee,
  );
  final cartProduct = Products(
    id: product.id,
    name: product.name,
    imageUrl: product.imageUrl,
    regularPrice: product.priceInt,
  );
  final notes = controller.itemNotesController.text.trim();

  cart.addItem(
    cartProduct,
    shop,
    quantity: 1,
    variationName: isVariable ? selectedVariationName : null,
    itemNotes: notes.isEmpty ? null : notes,
  );
}
