import 'package:app/controller/orderHistoory/order_items_group_utils.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/shared/custom_app_bar.dart';
import 'package:app/data/datasource/model/order_his_model.dart';
import 'package:app/view/orderDetails/order_details_actions.dart';
import 'package:app/view/orderDetails/order_details_shop_section.dart';
import 'package:flutter/material.dart';

class OrderDetailsView extends StatelessWidget {
  const OrderDetailsView({super.key, required this.order});

  final OrderHisModel order;

  @override
  Widget build(BuildContext context) {
    final colors = AppColor();
    final items = order.items ?? const <OrderItemModel>[];
    final groups = groupOrderItemsByShop(items);

    return Scaffold(
      backgroundColor: colors.backgroundColor,
      appBar: const CustomAppBar(title: 'تفاصيل الطلب'),
      body: items.isEmpty
          ? Center(
              child: Text(
                'لا توجد أصناف في هذا الطلب',
                style: TextStyle(color: colors.descriptionColor),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      return OrderDetailsShopSection(group: groups[index]);
                    },
                  ),
                ),
                SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => reorderPreviousOrder(order),
                        icon: const Icon(Icons.replay),
                        label: const Text('إعادة طلب'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primaryColor,
                          foregroundColor: colors.textButomColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
