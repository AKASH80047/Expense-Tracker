import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recurring_bill_model.dart';
import '../core/theme/app_theme.dart';

final recurringBillsProvider = NotifierProvider<RecurringBillsNotifier, List<RecurringBillModel>>(() {
  return RecurringBillsNotifier();
});

class RecurringBillsNotifier extends Notifier<List<RecurringBillModel>> {
  static final List<RecurringBillModel> _initialBills = [
    RecurringBillModel(
      id: 'bill_1',
      title: 'Electricity Bill',
      amount: 2450,
      dueDate: DateTime.now().add(const Duration(days: 3)),
      frequency: 'Every month',
      category: 'Bills & Utilities',
      icon: Icons.bolt_rounded,
      color: AppColors.orange,
    ),
    RecurringBillModel(
      id: 'bill_2',
      title: 'Internet Fiber',
      amount: 999,
      dueDate: DateTime.now().add(const Duration(days: 6)),
      frequency: 'Every month',
      category: 'Bills & Utilities',
      icon: Icons.wifi_rounded,
      color: AppColors.info,
    ),
    RecurringBillModel(
      id: 'bill_3',
      title: 'Netflix Premium',
      amount: 649,
      dueDate: DateTime.now().add(const Duration(days: 9)),
      frequency: 'Every month',
      category: 'Entertainment',
      icon: Icons.movie_filter_rounded,
      color: AppColors.danger,
    ),
    RecurringBillModel(
      id: 'bill_4',
      title: 'Cult.fit Gym',
      amount: 1750,
      dueDate: DateTime.now().add(const Duration(days: 14)),
      frequency: 'Every month',
      category: 'Health & Fitness',
      icon: Icons.fitness_center_rounded,
      color: AppColors.green,
    ),
  ];

  @override
  List<RecurringBillModel> build() {
    return _initialBills;
  }

  void addBill(RecurringBillModel bill) {
    state = [...state, bill];
  }

  void editBill(RecurringBillModel bill) {
    state = state.map((b) => b.id == bill.id ? bill : b).toList();
  }

  void deleteBill(String id) {
    state = state.where((b) => b.id != id).toList();
  }

  void togglePaid(String id) {
    state = state.map((b) {
      if (b.id == id) {
        return b.copyWith(isPaid: !b.isPaid);
      }
      return b;
    }).toList();
  }
}

final upcomingBillsProvider = Provider<List<RecurringBillModel>>((ref) {
  final bills = ref.watch(recurringBillsProvider);
  return bills.where((b) => !b.isPaid).toList();
});
