import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/savings_goal_model.dart';
import '../core/theme/app_theme.dart';

final savingsGoalsProvider = NotifierProvider<SavingsGoalsNotifier, List<SavingsGoalModel>>(() {
  return SavingsGoalsNotifier();
});

class SavingsGoalsNotifier extends Notifier<List<SavingsGoalModel>> {
  static final List<SavingsGoalModel> _initialGoals = [
    SavingsGoalModel(
      id: 'g_1',
      title: 'Emergency Fund',
      targetAmount: 100000,
      currentAmount: 75000, // 75%
      targetDate: DateTime(2026, 12, 31),
      icon: Icons.shield_outlined,
      color: AppColors.success,
    ),
    SavingsGoalModel(
      id: 'g_2',
      title: 'Vacation',
      targetAmount: 80000,
      currentAmount: 32000, // 40%
      targetDate: DateTime(2027, 2, 28),
      icon: Icons.flight_takeoff_rounded,
      color: AppColors.info,
    ),
    SavingsGoalModel(
      id: 'g_3',
      title: 'New Laptop',
      targetAmount: 120000,
      currentAmount: 45000, // 38%
      targetDate: DateTime(2026, 11, 30),
      icon: Icons.laptop_mac_rounded,
      color: AppColors.purple,
    ),
  ];

  @override
  List<SavingsGoalModel> build() {
    return _initialGoals;
  }

  void addGoal(SavingsGoalModel goal) {
    state = [...state, goal];
  }

  void editGoal(SavingsGoalModel goal) {
    state = state.map((g) => g.id == goal.id ? goal : g).toList();
  }

  void deleteGoal(String id) {
    state = state.where((g) => g.id != id).toList();
  }

  void addContribution(String id, double amount) {
    state = state.map((g) {
      if (g.id == id) {
        final newAmt = (g.currentAmount + amount).clamp(0.0, g.targetAmount * 2);
        return g.copyWith(currentAmount: newAmt);
      }
      return g;
    }).toList();
  }
}
