import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/categories.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/budget_model.dart';
import '../../providers/budget_provider.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(budgetsProvider);
    final overall = ref.watch(overallBudgetProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _showAddEditBudgetDialog(context, ref),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overall Budget Overview Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF242629), Color(0xFF141416)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [AppShadows.elevated],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Monthly Budget',
                          style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${overall.percentageFormatted}% spent',
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${CurrencyFormatter.format(overall.totalSpent)} / ${CurrencyFormatter.format(overall.totalLimit)}',
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        children: [
                          Container(height: 8, color: Colors.white.withValues(alpha: 0.15)),
                          FractionallySizedBox(
                            widthFactor: overall.percentage,
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          overall.isOnTrack ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
                          size: 16,
                          color: overall.isOnTrack ? AppColors.success : AppColors.warning,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          overall.statusText,
                          style: TextStyle(
                            color: overall.isOnTrack ? AppColors.success : AppColors.warning,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Category Budgets',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
              ),
              const SizedBox(height: 12),

              // Category Budgets List
              Column(
                children: budgets.map((budget) {
                  final catItem = AppCategories.getCategoryByName(budget.category);
                  final isWarning = budget.isWarning || budget.isExceeded;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isWarning ? AppColors.warning.withValues(alpha: 0.6) : AppColors.cardBorder,
                        width: isWarning ? 1.5 : 1,
                      ),
                      boxShadow: const [AppShadows.card],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: catItem.backgroundColor,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(catItem.icon, color: catItem.color, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    budget.category,
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${CurrencyFormatter.format(budget.spent)} of ${CurrencyFormatter.format(budget.limit)}',
                                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isWarning ? AppColors.warningLight : AppColors.surfaceSecondary,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                '${budget.percentageNumber.toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: isWarning ? const Color(0xFFB76E00) : AppColors.textPrimary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // Progress Bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Stack(
                            children: [
                              Container(
                                height: 7,
                                width: double.infinity,
                                color: AppColors.surfaceSecondary,
                              ),
                              FractionallySizedBox(
                                widthFactor: (budget.percentage).clamp(0.0, 1.0),
                                child: Container(
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: isWarning ? AppColors.warning : catItem.color,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isWarning
                                  ? "⚠️ You've used ${budget.percentageNumber.toStringAsFixed(0)}% of your ${budget.category} budget."
                                  : "✓ You're on track (${CurrencyFormatter.format(budget.remaining)} left)",
                              style: TextStyle(
                                fontSize: 11.5,
                                color: isWarning ? const Color(0xFFB76E00) : AppColors.success,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            InkWell(
                              onTap: () => _showAddEditBudgetDialog(context, ref, budget: budget),
                              child: const Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(Icons.edit_outlined, size: 16, color: AppColors.textTertiary),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddEditBudgetDialog(BuildContext context, WidgetRef ref, {BudgetModel? budget}) {
    final isEdit = budget != null;
    final limitController = TextEditingController(text: isEdit ? budget.limit.toStringAsFixed(0) : '');
    String selectedCategory = isEdit ? budget.category : AppCategories.expenseCategories.first.name;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(isEdit ? 'Edit Budget' : 'Set Category Budget', style: const TextStyle(fontWeight: FontWeight.w700)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Category', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        isExpanded: true,
                        items: AppCategories.expenseCategories.map((c) {
                          return DropdownMenuItem(value: c.name, child: Text(c.name));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => selectedCategory = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Monthly Limit (₹)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: limitController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'e.g. 10000'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final limit = double.tryParse(limitController.text.trim()) ?? 0;
                    if (limit <= 0) return;

                    if (isEdit) {
                      ref.read(budgetsProvider.notifier).updateBudget(budget.copyWith(
                            category: selectedCategory,
                            limit: limit,
                          ));
                    } else {
                      final newBudget = BudgetModel(
                        id: 'b_${DateTime.now().millisecondsSinceEpoch}',
                        category: selectedCategory,
                        limit: limit,
                        spent: 0,
                        month: 'September',
                        year: 2026,
                      );
                      ref.read(budgetsProvider.notifier).addBudget(newBudget);
                    }
                    Navigator.pop(ctx);
                  },
                  child: Text(isEdit ? 'Save Changes' : 'Set Budget'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
