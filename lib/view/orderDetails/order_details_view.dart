import 'package:app/core/constant/app_color.dart';
import 'package:app/core/shared/custom_app_bar.dart';
import 'package:app/view/orderHistoory/controller/order_his_controller.dart';
import 'package:app/view/orderHistoory/model/order_his_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({super.key, required this.orderId});
  final int orderId;
  @override
  Widget build(BuildContext context) {
    OrderHisController controller = Get.find<OrderHisController>();

    final colors = AppColor();

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      appBar: CustomAppBar(title: "تفاصيل الطلب"),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: controller.orders[orderId].items!.length,
          itemBuilder: (context, index) {
            return _buildProductCard(
              colors,
              controller.orders[orderId].items![index],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductCard(AppColor colors, OrderItemModel item) {
    return Card(
      color: colors.backgroundColorCard,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // صورة المنتج
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "${item.product!.imageUrl}",
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            // النصوص
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${item.product!.name}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colors.titleColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${item.product!.description}",
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.descriptionColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "السعر: ${item.product!.salePrice} \$",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "العدد: ${item.quantity}",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
