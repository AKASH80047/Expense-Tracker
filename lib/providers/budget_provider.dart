import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/budget_model.dart';

final budgetsProvider = NotifierProvider<BudgetNotifier, List<BudgetModel>>(() {
  return BudgetNotifier();
});

class BudgetNotifier extends Notifier<List<BudgetModel>> {
  static final List<BudgetModel> _initialBudgets = [
    const BudgetModel(
      id: 'b_shopping',
      category: 'Shopping',
      limit: 10000,
      spent: 8000, // 80% warning
      month: 'September',
      year: 2026,
    ),
    const BudgetModel(
      id: 'b_food',
      category: 'Food & Dining',
      limit: 8000,
      spent: 5500, // 69%
      month: 'September',
      year: 2026,
    ),
    const BudgetModel(
      id: 'b_transport',
      category: 'Transportation',
      limit: 5000,
      spent: 3200, // 64%
      month: 'September',
      year: 2026,
    ),
    const BudgetModel(
      id: 'b_entertainment',
      category: 'Entertainment',
      limit: 6000,
      spent: 3500, // 58%
      month: 'September',
      year: 2026,
    ),
    const BudgetModel(
      id: 'b_bills',
      category: 'Bills & Utilities',
      limit: 4500,
      spent: 3500, // 77%
      month: 'September',
      year: 2026,
    ),
  ];

  @override
  List<BudgetModel> build() {
    return _initialBudgets;
  }

  void addBudget(BudgetModel budget) {
    state = [...state, budget];
  }

  void updateBudget(BudgetModel budget) {
    state = state.map((b) => b.id == budget.id ? budget : b).toList();
  }

  void deleteBudget(String id) {
    state = state.where((b) => b.id != id).toList();
  }

  void addExpenseToCategory(String categoryName, double amount) {
    state = state.map((b) {
      if (b.category.toLowerCase().contains(categoryName.toLowerCase()) ||
          categoryName.toLowerCase().contains(b.category.toLowerCase())) {
        final newSpent = (b.spent + amount).clamp(0.0, 9999999.0);
        return b.copyWith(spent: newSpent);
      }
      return b;
    }).toList();
  }
}

// Overall Monthly Budget summary: spent ₹42,350 / ₹60,000 (70.6%)
final overallBudgetProvider = Provider<OverallBudgetSummary>((ref) {
  final totalLimit = 60000.0;
  final totalSpent = 42350.0;
  final percentage = (totalSpent / totalLimit).clamp(0.0, 1.0);

  return OverallBudgetSummary(
    totalLimit: totalLimit,
    totalSpent: totalSpent,
    percentage: percentage,
    percentageFormatted: (percentage * 100).toStringAsFixed(1),
    isOnTrack: percentage < 0.85,
    statusText: percentage < 0.85 ? "You're on track this month" : "Approaching monthly limit",
  );
});

class OverallBudgetSummary {
  final double totalLimit;
  final double totalSpent;
  final double percentage;
  final String percentageFormatted;
  final bool isOnTrack;
  final String statusText;

  OverallBudgetSummary({
    required this.totalLimit,
    required this.totalSpent,
    required this.percentage,
    required this.percentageFormatted,
    required this.isOnTrack,
    required this.statusText,
  });
}
