import 'package:app/core/constant/app_color.dart';
import 'package:app/view/orderHistoory/controller/order_his_controller.dart';
import 'package:app/view/orderHistoory/view/widget/order_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderHistoryPage extends StatelessWidget {
  OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OrderHisController());

    return Scaffold(
      backgroundColor: AppColor().backgroundColor,
      appBar: AppBar(
        title: Text(
          "سجل الطلبات",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: AppColor().backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColor().titleColor),
        automaticallyImplyLeading: false,
      ),
      body: const OrderList(),
    );
  }
}
