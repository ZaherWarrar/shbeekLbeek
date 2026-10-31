import 'package:app/controller/shop_details/shop_details_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/data/datasource/model/item_model.dart';
import 'package:app/view/shopDetails/widgets/shop_category_tabs_row.dart';
import 'package:app/view/shopDetails/widgets/shop_network_image.dart';
import 'package:app/view/shopDetails/widgets/shop_product_list_tile.dart';
import 'package:flutter/material.dart';

List<Widget> buildShopCatalogSlivers(ShopDetailsController controller) {
  final tabs = controller.innerCategoryTabs;
  final products = controller.displayedProducts;

  if (controller.filteredProducts.isEmpty) {
    return [
      SliverToBoxAdapter(
        child: controller.productsLoading
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColor().primaryColor,
                    strokeWidth: 2,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'لا توجد منتجات متاحة',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ),
              ),
      ),
    ];
  }

  return [
    SliverToBoxAdapter(
      child: ShopCategoryTabsRow(
        tabs: tabs,
        selectedId: controller.selectedInnerCategoryId,
        onSelect: controller.selectInnerCategory,
      ),
    ),
    const SliverToBoxAdapter(child: SizedBox(height: 8)),
    if (products.isEmpty)
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              'لا توجد منتجات في هذا القسم',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
        ),
      )
    else
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = products[index];
            _precacheUpcoming(context, products, index);
            return ShopProductListTile(
              key: ValueKey(product.id ?? index),
              product: product,
              controller: controller,
            );
          },
          childCount: products.length,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: true,
          findChildIndexCallback: (key) {
            if (key is! ValueKey<int>) return null;
            final index = products.indexWhere((item) => item.id == key.value);
            return index < 0 ? null : index;
          },
        ),
      ),
    if (controller.productsLoading)
      const SliverToBoxAdapter(child: _CatalogTailLoader()),
  ];
}

void _precacheUpcoming(
  BuildContext context,
  List<Products> products,
  int index,
) {
  final width = MediaQuery.sizeOf(context).width;
  final logical = width < 400 ? 80.0 : 120.0;
  for (var step = 1; step <= 3; step++) {
    final next = index + step;
    if (next >= products.length) return;
    precacheShopImage(context, products[next].imageUrl, logical);
  }
}

class _CatalogTailLoader extends StatelessWidget {
  const _CatalogTailLoader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColor().primaryColor,
          ),
        ),
      ),
    );
  }
}
