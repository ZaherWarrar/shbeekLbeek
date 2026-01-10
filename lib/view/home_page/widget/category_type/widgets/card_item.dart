import 'package:app/controller/home/home_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/constant/routes/app_routes.dart';
import 'package:app/core/function/fontsize.dart';
import 'package:app/data/datasorce/model/item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardItem extends StatelessWidget {
  const CardItem({super.key, required this.controller, required this.index});
  final HomeControllerImp controller;
  final int index;
  @override
  Widget build(BuildContext context) {
    final items = controller.finalSection[controller.sectionName] ?? [];
    final sectionItem = items[index];

    // البحث عن المتجر (ItemModel) الذي يحتوي على هذا المنتج
    ItemModel? storeItem;
    if (sectionItem.storeId != null) {
      try {
        storeItem = controller.items.firstWhere(
          (item) => item.id == sectionItem.storeId,
        );
      } catch (e) {
        storeItem = null;
      }
    }

    return GestureDetector(
      onTap: () {
        if (storeItem != null) {
          Get.toNamed(AppRoutes.resturantDetails, arguments: storeItem);
        } else {
          Get.snackbar(
            'تنبيه',
            'لم يتم العثور على معلومات المتجر',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: AppColor().backgroundColorCard,
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                child: Image.network(
                  items[index].imageUrl!,
                  height: 130,
                  width: 300,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    items[index].name ?? "",
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(context, fontSize: 35),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    items[index].description ?? "",
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(context, fontSize: 25),
                      color: AppColor().descriptionColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                      Icon(
                        Icons.star_border,
                        color: AppColor().primaryColor,
                        size: 25,
                      ),
                      SizedBox(width: 5),
                      Text(
                        "4",
                        style: TextStyle(
                          fontSize: getResponsiveFontSize(
                            context,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "200",
                        style: TextStyle(
                          fontSize: getResponsiveFontSize(
                            context,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
