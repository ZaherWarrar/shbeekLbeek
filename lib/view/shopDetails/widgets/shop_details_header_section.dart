import 'package:app/controller/shop_details/shop_details_controller.dart';
import 'package:app/core/constant/app_images.dart';
import 'package:app/view/shopDetails/widgets/information_shop_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopDetailsHeaderSection extends StatelessWidget {
  const ShopDetailsHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShopDetailsController>(
      builder: (controller) {
        return SizedBox(
          height: 320,
          child: Stack(
            children: [
              SizedBox(
                height: 180,
                width: double.infinity,
                child: Image.network(
                  controller.store?.imageUrl ??
                      controller.shopItemSummary?.imageUrl ??
                      '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      Assets.imagesLogo,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              const Positioned(
                top: 140,
                left: 8,
                right: 8,
                child: InformationShopCard(),
              ),
            ],
          ),
        );
      },
    );
  }
}
