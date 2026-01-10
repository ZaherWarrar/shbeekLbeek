import 'package:app/core/constant/app_color.dart';
import 'package:app/view/adress/view/widget/add_address_button.dart';
import 'package:app/view/adress/view/widget/address_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/address_controller.dart';

class AddressPage extends GetView<AddressController> {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().backgroundColor ,
      appBar: AppBar(
        title:  Text(
          "العناوين المحفوظة",
          style: TextStyle(color: AppColor().titleColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColor().backgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme:  IconThemeData(color: AppColor().titleColor),
      ),
      body: const AddressList(),
      floatingActionButton: const AddAddressButton(),
    );
  }
}
