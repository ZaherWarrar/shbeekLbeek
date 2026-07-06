import 'package:app/core/constant/app_color.dart';
import 'package:flutter/material.dart';

class NotificationsEmptyState extends StatelessWidget {
  const NotificationsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColor().primaryColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_outlined,
                size: 44,
                color: AppColor().primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'لا توجد إشعارات',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColor().titleColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'ستظهر هنا إشعارات الطلبات والعروض عند وصولها',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColor().descriptionColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
