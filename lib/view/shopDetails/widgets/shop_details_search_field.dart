import 'package:app/controller/shop_details/shop_details_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShopDetailsSearchField extends StatelessWidget {
  const ShopDetailsSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShopDetailsController>(
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: 40,
            child: TextField(
              controller: controller.searchController,
              decoration: InputDecoration(
                hintText: 'بحث',
                hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 126, 126, 126),
                  fontSize: 14,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                suffixIcon: const Icon(
                  Icons.search,
                  color: Color.fromARGB(255, 126, 126, 126),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: AppColor().descriptionColor,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: AppColor().primaryColor,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
