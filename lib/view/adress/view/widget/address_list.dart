import 'package:app/view/adress/controller/address_controller.dart';
import 'package:app/view/adress/view/widget/address_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressList extends GetView<AddressController> {
  const AddressList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.addresses.isEmpty) {
        return const Center(child: Text("لا يوجد عناوين مضافة"));
      }

      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: controller.addresses.length,
        itemBuilder: (context, index) {
          return AddressCard(address: controller.addresses[index]);
        },
      );
    });
  }
}
