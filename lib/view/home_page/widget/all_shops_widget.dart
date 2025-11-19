import 'package:app/controller/home/home_controller.dart';
import 'package:app/core/shared/custom_loding_page.dart';
import 'package:app/view/home_page/widget/list_all_shops_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllShops extends StatelessWidget {
  const AllShops({super.key});

  @override
  Widget build(BuildContext context) {
    //مشان التحكم بحجم العنصر اذا كان الجوال بالطول

    return GetBuilder<HomeControllerImp>(
      builder: (controller) {
        return CustomLodingPage(
          statusRequest: controller.allItemState,
          body: ListAllShopsWidget(),
        );
      },
    );
  }
}
