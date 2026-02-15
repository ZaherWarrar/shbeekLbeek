import 'package:app/core/constant/app_color.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/view/adress/controller/address_controller.dart';
import 'package:app/view/adress/model/address_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDeliveryAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomDeliveryAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          color: AppColor().backgroundColor,
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.4),
              blurRadius: 5,
              spreadRadius: 0,
              offset: Offset(0, 2),
            ),
          ],
        ),

        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03, // نسبة من العرض
          vertical: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ====== الجهة اليسار (الأيقونات) ======
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.allShops);
                  },
                  icon: const Icon(Icons.search),
                  color: Colors.black87,
                ),
              ],
            ),

            // ====== الجهة اليمين (العنوان والموقع) ======
            GetBuilder<AddressController>(
              builder: (addressController) {
                // البحث عن العنوان الافتراضي
                AddressModel? defaultAddress;
                try {
                  if (addressController.addresses.isNotEmpty) {
                    defaultAddress = addressController.addresses.firstWhere(
                      (address) => address.isDefault,
                      orElse: () => addressController.addresses.first,
                    );
                  }
                } catch (e) {
                  defaultAddress = null;
                }

                final addressText = defaultAddress?.title ?? "اختر عنوان";

                return GestureDetector(
                  onTap: () {
                    // الانتقال إلى صفحة العناوين
                    Get.toNamed(AppRoutes.addrslis);
                  },
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FittedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "توصيل إلى",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.032,
                                  color: Colors.grey.shade600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 18,
                                    color: Colors.black87,
                                  ),
                                  FittedBox(
                                    child: Text(
                                      addressText,
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
