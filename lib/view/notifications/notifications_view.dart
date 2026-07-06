import 'package:app/controller/notifications/notifications_controller.dart';
import 'package:app/core/constant/app_color.dart';
import 'package:app/core/shared/custom_refresh.dart';
import 'package:app/view/notifications/widget/notification_card.dart';
import 'package:app/view/notifications/widget/notifications_empty_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!Get.isRegistered<NotificationsController>()) return;
      Get.find<NotificationsController>().loadNotifications(requireAuth: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationsController>(
      builder: (controller) {
        final items = controller.visibleNotifications;

        return Scaffold(
          backgroundColor: AppColor().backgroundColor,
          appBar: AppBar(
            title: const Text(
              'الإشعارات',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
            backgroundColor: AppColor().backgroundColor,
            elevation: 0,
            foregroundColor: AppColor().titleColor,
            actions: [
              if (controller.unreadCount > 0)
                TextButton(
                  onPressed: controller.markAllAsRead,
                  child: Text(
                    'قراءة الكل',
                    style: TextStyle(
                      color: AppColor().primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          body: CustomRefresh(
            statusRequest: controller.statusRequest,
            fun: () => controller.loadNotifications(requireAuth: true),
            body: items.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 120),
                      NotificationsEmptyState(),
                    ],
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return NotificationCard(
                        notification: item,
                        onTap: () => controller.markAsRead(item.id),
                        onMarkAsRead: () => controller.markAsRead(item.id),
                        onDelete: () => controller.deleteNotification(item.id),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
