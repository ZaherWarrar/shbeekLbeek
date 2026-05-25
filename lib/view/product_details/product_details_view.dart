import 'package:app/binding/product_details_binding.dart';
import 'package:app/controller/product_details/product_details_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/shared/custom_refresh.dart';
import 'package:app/view/product_details/product_details_page_args.dart';
import 'package:app/view/product_details/widgets/product_bottom_bar.dart';
import 'package:app/view/product_details/widgets/product_description_section.dart';
import 'package:app/view/product_details/widgets/product_header_section.dart';
import 'package:app/view/product_details/widgets/product_recommended_section.dart';
import 'package:app/view/product_details/widgets/product_reviews_section.dart';
import 'package:app/view/shopDetails/widgets/cart_floating_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  ProductDetailsPageArgs? _args;
  late final String _controllerTag;

  @override
  void initState() {
    super.initState();
    _args = ProductDetailsPageArgs.tryParse(Get.arguments);
    _controllerTag = _args != null
        ? ProductDetailsBinding.tagFor(_args!.productId)
        : '';
  }

  @override
  void dispose() {
    if (_args != null &&
        Get.isRegistered<ProductDetailsController>(tag: _controllerTag)) {
      Get.delete<ProductDetailsController>(tag: _controllerTag);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = _args;
    if (args == null) {
      return Scaffold(
        backgroundColor: AppColor().backgroundColor,
        body: Center(
          child: Text(
            'معرّف المنتج غير صحيح',
            style: TextStyle(color: AppColor().titleColor),
          ),
        ),
      );
    }

    return GetBuilder<ProductDetailsController>(
      tag: _controllerTag,
      builder: (controller) {
        final product = controller.product;
        final isVariable =
            (product?.type ?? '').toLowerCase() == 'variable' &&
            (product?.variations.isNotEmpty ?? false);
        final effectiveStoreId = product?.storeId ?? args.storeId;
        final effectiveStoreName = product?.storeName ?? args.storeName;
        final effectiveStoreImage = product?.storeImageUrl ?? args.storeImageUrl;
        final effectiveStoreDeliveryFee =
            product?.storeDeliveryFee ?? args.storeDeliveryFee;

        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColor().backgroundColor,
            floatingActionButton: const CartFloatingButton(),
            appBar: AppBar(
              backgroundColor: AppColor().backgroundColor,
              surfaceTintColor: AppColor().backgroundColor,
              elevation: 0,
              centerTitle: true,
              foregroundColor: AppColor().titleColor,
              title: Text(
                'تفاصيل المنتج',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColor().primaryColor,
                ),
              ),
            ),
            body: CustomRefresh(
              statusRequest: controller.statusRequest,
              preferBodyWhenLoading: true,
              fun: () => controller.fetchAll(),
              body: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      ProductHeaderSection(product: product),
                      const SizedBox(height: 18),
                      ProductDescriptionSection(
                        product: product,
                        controller: controller,
                        isVariable: isVariable,
                      ),
                      const SizedBox(height: 18),
                      ProductRecommendedSection(
                        controller: controller,
                        effectiveStoreId: effectiveStoreId,
                        effectiveStoreName: effectiveStoreName,
                        effectiveStoreImage: effectiveStoreImage,
                        effectiveStoreDeliveryFee: effectiveStoreDeliveryFee,
                      ),
                      const SizedBox(height: 18),
                      ProductReviewsSection(controller: controller),
                      const SizedBox(height: 90),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: ProductBottomBar(
              product: product,
              productId: args.productId,
              controller: controller,
              isVariable: isVariable,
              selectedVariationName:
                  controller.selectedVariationNameCombined,
              effectiveStoreId: effectiveStoreId,
              effectiveStoreName: effectiveStoreName,
              effectiveStoreImage: effectiveStoreImage,
              effectiveStoreDeliveryFee: effectiveStoreDeliveryFee,
            ),
          ),
        );
      },
    );
  }
}
