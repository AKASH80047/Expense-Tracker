import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_model.dart';

final notificationsProvider = NotifierProvider<NotificationNotifier, List<NotificationModel>>(() {
  return NotificationNotifier();
});

class NotificationNotifier extends Notifier<List<NotificationModel>> {
  static final List<NotificationModel> _initialNotifications = [
    NotificationModel(
      id: 'n_1',
      title: 'Electricity Bill Due Soon',
      message: 'Electricity bill of ₹2,450 is due in 3 days.',
      type: NotificationType.bill,
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
      isRead: false,
    ),
    NotificationModel(
      id: 'n_2',
      title: 'Budget Alert',
      message: "⚠️ You've spent 85% of your monthly shopping budget.",
      type: NotificationType.budget,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    NotificationModel(
      id: 'n_3',
      title: 'Savings Milestone',
      message: '🎉 Great job! You saved ₹8,500 more this month compared to your baseline.',
      type: NotificationType.saving,
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
    ),
    NotificationModel(
      id: 'n_4',
      title: 'Smart Spending Insight',
      message: '💡 Shopping expenses are 18% higher than last month. Consider review.',
      type: NotificationType.insight,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationModel(
      id: 'n_5',
      title: 'Credit Card Due',
      message: '🔔 Credit card payment of ₹8,500 is due tomorrow.',
      type: NotificationType.bill,
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      isRead: true,
    ),
  ];

  @override
  List<NotificationModel> build() {
    return _initialNotifications;
  }

  void markAsRead(String id) {
    state = state.map((n) => n.id == id ? n.copyWith(isRead: true) : n).toList();
  }

  void markAllAsRead() {
    state = state.map((n) => n.copyWith(isRead: true)).toList();
  }

  void deleteNotification(String id) {
    state = state.where((n) => n.id != id).toList();
  }

  void addNotification(NotificationModel notification) {
    state = [notification, ...state];
  }
}

final unreadNotificationsCountProvider = Provider<int>((ref) {
  final list = ref.watch(notificationsProvider);
  return list.where((n) => !n.isRead).length;
});
