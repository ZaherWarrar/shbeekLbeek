import 'package:app/controller/cart/cart_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/shared/custom_app_bar.dart';
import 'package:app/core/shared/custom_refresh.dart';
import 'package:app/controller/shop_details/shop_details_controller.dart';
import 'package:app/view/shopDetails/widgets/cart_floating_button.dart';
import 'package:app/view/shopDetails/widgets/category_with_items.dart';
import 'package:app/view/shopDetails/widgets/shop_details_header_section.dart';
import 'package:app/view/shopDetails/widgets/shop_details_reviews_section.dart';
import 'package:app/view/shopDetails/widgets/shop_details_search_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopDetailsView extends StatelessWidget {
  const ShopDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShopDetailsController>(
      builder: (controller) {
        return SafeArea(
          child: Scaffold(
            floatingActionButton: const CartFloatingButton(),
            backgroundColor: AppColor().backgroundColor,
            appBar: CustomAppBar(
              title: controller.appBarTitle,
            ),
            body: CustomRefresh(
              statusRequest: controller.statusRequest,
              preferBodyWhenLoading: true,
              fun: () => controller.refreshPage(),
              body: GetBuilder<CartController>(
                builder: (_) => CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  cacheExtent: 600,
                  slivers: [
                    const SliverToBoxAdapter(child: ShopDetailsHeaderSection()),
                    const SliverToBoxAdapter(child: SizedBox(height: 10)),
                    const SliverToBoxAdapter(child: ShopDetailsSearchField()),
                    ...buildShopCatalogSlivers(controller),
                    const SliverToBoxAdapter(child: SizedBox(height: 30)),
                    const SliverToBoxAdapter(
                      child: ShopDetailsReviewsSection(),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
