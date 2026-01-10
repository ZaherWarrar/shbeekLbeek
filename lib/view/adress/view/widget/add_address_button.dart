import 'package:app/core/constant/app_color.dart';
import 'package:app/view/adress/view/add_address_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAddressButton extends StatelessWidget {
  const AddAddressButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColor().primaryColor,
      onPressed: () => Get.to(() => AddAddressPage()),
      child: const Icon(Icons.add),
    );
  }
}
