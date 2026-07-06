import 'package:app/core/constant/app_color.dart';
import 'package:app/data/datasource/model/external_order_model.dart';
import 'package:app/view/orderHistoory/widget/status_chip.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExternalOrderCard extends StatelessWidget {
  const ExternalOrderCard({super.key, required this.order});

  final ExternalOrderModel order;

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String _formatPrice(double? price) {
    if (price == null || price <= 0) return 'قيد التسعير';
    return '${price.toStringAsFixed(0)} ل.س';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: AppColor().backgroundColorCard,
        boxShadow: [
          BoxShadow(
            color: AppColor().titleColor.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: AppColor().primaryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.local_shipping_outlined,
                    color: AppColor().primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    order.orderDetails.isNotEmpty
                        ? order.orderDetails
                        : 'طلب توصيل خارجي',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColor().titleColor,
                    ),
                  ),
                ),
                StatusChip(status: order.status),
              ],
            ),
            const SizedBox(height: 14),
            _AddressRow(
              icon: Icons.trip_origin,
              label: 'من',
              value: order.fromAddressDetails,
            ),
            const SizedBox(height: 8),
            _AddressRow(
              icon: Icons.location_on_outlined,
              label: 'إلى',
              value: order.toAddressDetails,
            ),
            const SizedBox(height: 14),
            Divider(color: Colors.grey.shade200),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 18,
                      color: AppColor().descriptionColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'رقم الطلب #${order.id}',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColor().descriptionColor,
                      ),
                    ),
                  ],
                ),
                Text(
                  _formatPrice(order.totalPrice),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor().primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'تاريخ الطلب: ${_formatDate(order.createdAt)}',
              style: TextStyle(
                fontSize: 13,
                color: AppColor().descriptionColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressRow extends StatelessWidget {
  const _AddressRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColor().primaryColor),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColor().titleColor,
          ),
        ),
        Expanded(
          child: Text(
            value.isNotEmpty ? value : '—',
            style: TextStyle(
              fontSize: 13,
              color: AppColor().descriptionColor,
            ),
          ),
        ),
      ],
    );
  }
}
