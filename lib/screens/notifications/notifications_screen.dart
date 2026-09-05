import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/notification_model.dart';
import '../../providers/notifications_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (notifications.any((n) => !n.isRead))
            TextButton(
              onPressed: () {
                ref.read(notificationsProvider.notifier).markAllAsRead();
              },
              child: const Text('Mark all read', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
      body: SafeArea(
        child: notifications.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_off_outlined, size: 48, color: AppColors.textTertiary.withValues(alpha: 0.5)),
                    const SizedBox(height: 12),
                    Text('No notifications', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notif = notifications[index];
                  final iconData = _getNotificationIcon(notif.type);
                  final color = _getNotificationColor(notif.type);

                  return Dismissible(
                    key: Key(notif.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppColors.danger,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(Icons.delete_outline, color: Colors.white),
                    ),
                    onDismissed: (_) {
                      ref.read(notificationsProvider.notifier).deleteNotification(notif.id);
                    },
                    child: GestureDetector(
                      onTap: () {
                        ref.read(notificationsProvider.notifier).markAsRead(notif.id);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: notif.isRead ? AppColors.surface : const Color(0xFFFFFDF5),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: notif.isRead ? AppColors.cardBorder : AppColors.primary.withValues(alpha: 0.5),
                            width: notif.isRead ? 1 : 1.5,
                          ),
                          boxShadow: const [AppShadows.card],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(iconData, color: color, size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          notif.title,
                                          style: TextStyle(
                                            fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.w700,
                                            fontSize: 14.5,
                                          ),
                                        ),
                                      ),
                                      if (!notif.isRead)
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: const BoxDecoration(
                                            color: AppColors.primaryDark,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notif.message,
                                    style: TextStyle(
                                      color: notif.isRead ? AppColors.textSecondary : AppColors.textPrimary,
                                      fontSize: 13,
                                      height: 1.35,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    CurrencyFormatter.formatDate(notif.timestamp),
                                    style: const TextStyle(color: AppColors.textTertiary, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.bill:
        return Icons.notifications_active_outlined;
      case NotificationType.budget:
        return Icons.warning_amber_rounded;
      case NotificationType.saving:
        return Icons.celebration_outlined;
      case NotificationType.insight:
        return Icons.lightbulb_outline_rounded;
      case NotificationType.security:
        return Icons.shield_outlined;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.bill:
        return AppColors.orange;
      case NotificationType.budget:
        return AppColors.danger;
      case NotificationType.saving:
        return AppColors.success;
      case NotificationType.insight:
        return AppColors.purple;
      case NotificationType.security:
        return AppColors.info;
    }
  }
}
