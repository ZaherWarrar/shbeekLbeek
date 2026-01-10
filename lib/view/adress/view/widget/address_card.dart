import 'package:app/core/constant/app_color.dart';
import 'package:app/view/adress/model/address_model.dart';
import 'package:flutter/material.dart';

class AddressCard extends StatelessWidget {
  final AddressModel address;

  const AddressCard({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor().backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColor().titleColor.withOpacity(.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
           Icon(Icons.location_on, color: AppColor().primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address.description,
                  style: TextStyle(
                    color: AppColor().descriptionColor,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          if (address.isDefault)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColor().primaryColor.withOpacity(.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child:  Text(
                "افتراضي",
                style: TextStyle(
                  color: AppColor().primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
