import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/controller/shop_details/shop_details_controller.dart';
import 'package:app/view/shopDetails/widgets/shop_category_tabs_row.dart';
import 'package:app/view/shopDetails/widgets/shop_product_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryWithItems extends StatelessWidget {
  const CategoryWithItems({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShopDetailsController>(
      builder: (controller) {
        return GetBuilder<CartController>(
          builder: (_) {
            final tabs = controller.innerCategoryTabs;
            final products = controller.displayedProducts;

            if (controller.filteredProducts.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(
                    'لا توجد منتجات متاحة',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ShopCategoryTabsRow(
                  tabs: tabs,
                  selectedId: controller.selectedInnerCategoryId,
                  onSelect: controller.selectInnerCategory,
                ),
                const SizedBox(height: 8),
                if (products.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        'لا توجد منتجات في هذا القسم',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ),
                  )
                else
                  ...products.map(
                    (product) => ShopProductListTile(
                      product: product,
                      controller: controller,
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
