import 'package:app/core/constant/app_color.dart';
import 'package:app/data/datasource/model/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onMarkAsRead,
    required this.onDelete,
  });

  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onMarkAsRead;
  final Future<bool> Function() onDelete;

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'الآن';
    if (diff.inHours < 1) return 'منذ ${diff.inMinutes} د';
    if (diff.inDays < 1) return 'منذ ${diff.inHours} س';
    if (diff.inDays < 7) return 'منذ ${diff.inDays} ي';
    return DateFormat('d/M/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColor().backgroundColorCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isUnread
                  ? AppColor().primaryColor.withValues(alpha: 0.35)
                  : Colors.grey.shade200,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor().titleColor.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColor().primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: AppColor().primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight:
                                  isUnread ? FontWeight.w700 : FontWeight.w600,
                              color: AppColor().titleColor,
                            ),
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColor().primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.body,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.4,
                        color: AppColor().descriptionColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDate(notification.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColor().descriptionColor.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              if (isUnread)
                IconButton(
                  tooltip: 'تعيين كمقروء',
                  onPressed: onMarkAsRead,
                  icon: Icon(
                    Icons.done_all,
                    color: AppColor().primaryColor,
                    size: 22,
                  ),
                ),
              IconButton(
                tooltip: 'حذف',
                onPressed: () => onDelete(),
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red.shade400,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
