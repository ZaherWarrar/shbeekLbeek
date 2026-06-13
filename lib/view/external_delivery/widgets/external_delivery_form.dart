import 'package:app/controller/external_delivery/external_delivery_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/view/external_delivery/widgets/external_delivery_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExternalDeliveryForm extends StatelessWidget {
  const ExternalDeliveryForm({super.key});

  String _coordsLabel(double lat, double lng) {
    if (lat == 0.0 && lng == 0.0) return 'لم يُحدد بعد على الخريطة';
    return '${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExternalDeliveryController>();

    return Obx(
      () => Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (controller.isLoadingRoute.value || controller.hasRoute)
              _RouteInfoBar(
                isLoading: controller.isLoadingRoute.value,
                distanceKm: controller.routeDistanceKm.value,
                durationMin: controller.routeDurationMin.value,
              ),
            if (controller.isLoadingRoute.value || controller.hasRoute)
              const SizedBox(height: 16),
            ExternalDeliveryTextField(
              label: 'تفاصيل موقع الانطلاق',
              hint: 'مثال: بجانب الصيدلية، الطابق الثاني',
              controller: controller.fromDetailsController,
              icon: Icons.trip_origin,
            ),
            const SizedBox(height: 6),
            Text(
              _coordsLabel(controller.fromLat.value, controller.fromLng.value),
              style: TextStyle(
                fontSize: 12,
                color: AppColor().descriptionColor,
              ),
            ),
            const SizedBox(height: 16),
            ExternalDeliveryTextField(
              label: 'تفاصيل موقع الوصول',
              hint: 'مثال: عند البوابة الرئيسية',
              controller: controller.toDetailsController,
              icon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 6),
            Text(
              _coordsLabel(controller.toLat.value, controller.toLng.value),
              style: TextStyle(
                fontSize: 12,
                color: AppColor().descriptionColor,
              ),
            ),
            const SizedBox(height: 16),
            ExternalDeliveryTextField(
              label: 'تفاصيل الطلب',
              hint: 'مثال: طرد، مستندات، وصف المحتوى...',
              controller: controller.orderDetailsController,
              icon: Icons.receipt_long_outlined,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'تفاصيل الطلب مطلوبة';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RouteInfoBar extends StatelessWidget {
  const _RouteInfoBar({
    required this.isLoading,
    required this.distanceKm,
    required this.durationMin,
  });

  final bool isLoading;
  final double distanceKm;
  final double durationMin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor().backgroundColorCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColor().primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColor().primaryColor,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'جارٍ حساب المسار...',
                  style: TextStyle(color: AppColor().descriptionColor),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _InfoChip(
                  icon: Icons.route,
                  label: distanceKm > 0
                      ? '${distanceKm.toStringAsFixed(1)} كم'
                      : 'غير متاح',
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: Colors.grey.shade300,
                ),
                _InfoChip(
                  icon: Icons.schedule,
                  label: durationMin > 0
                      ? '${durationMin.toStringAsFixed(0)} دقيقة'
                      : 'غير متاح',
                ),
              ],
            ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColor().primaryColor),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColor().titleColor,
          ),
        ),
      ],
    );
  }
}
