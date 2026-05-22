# TODO - Inner Categories in ShopDetails

- [ ] Update `Products` model to parse `inner_category` from API.
  - File: `lib/data/datasorce/model/item_model.dart`

- [ ] Update `ShopDetailsController.getProductsByCategory()` to group `filteredProducts` by `product.innerCategory.id` (instead of returning `{null: ...}`).
  - File: `lib/controller/shop_details/shop_details_controller.dart`

- [ ] Update `CategoryWithItems` UI title to show inner category name.
  - File: `lib/view/shopDetails/widgets/category_with_items.dart`

- [ ] Sanity check: ensure product quantity, navigation to ProductDetails, favorites, and cart updates still work after model changes.
- [ ] Run `flutter analyze` / tests if available.
