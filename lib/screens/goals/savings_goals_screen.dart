import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/savings_goal_model.dart';
import '../../providers/goals_provider.dart';

class SavingsGoalsScreen extends ConsumerWidget {
  const SavingsGoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(savingsGoalsProvider);
    final totalTarget = goals.fold<double>(0.0, (s, g) => s + g.targetAmount);
    final totalSaved = goals.fold<double>(0.0, (s, g) => s + g.currentAmount);
    final overallProgress = totalTarget > 0 ? (totalSaved / totalTarget) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings Goals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Create Goal',
            onPressed: () => _showCreateGoalDialog(context, ref),
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
              // Savings Summary Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B3B2B), Color(0xFF0D1E16)],
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
                          'Total Target Portfolio',
                          style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${(overallProgress * 100).toStringAsFixed(0)}% Achieved',
                            style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w700, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${CurrencyFormatter.format(totalSaved)} / ${CurrencyFormatter.format(totalTarget)}',
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        children: [
                          Container(height: 8, color: Colors.white.withValues(alpha: 0.15)),
                          FractionallySizedBox(
                            widthFactor: overallProgress.clamp(0.0, 1.0),
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      '💡 Automated discipline increases goal completion rate by 42%.',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Active Goals (${goals.length})',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                  ),
                  TextButton.icon(
                    onPressed: () => _showCreateGoalDialog(context, ref),
                    icon: const Icon(Icons.add, size: 16, color: AppColors.textPrimary),
                    label: const Text('Create Goal', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Goals List
              Column(
                children: goals.map((goal) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.cardBorder),
                      boxShadow: const [AppShadows.card],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: goal.color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(goal.icon, color: goal.color, size: 24),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    goal.title,
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Target Date: ${CurrencyFormatter.formatDate(goal.targetDate)}',
                                    style: const TextStyle(color: AppColors.textTertiary, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceSecondary,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                '${goal.percentage.toStringAsFixed(0)}%',
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${CurrencyFormatter.format(goal.currentAmount)} saved',
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                            Text(
                              'Target: ${CurrencyFormatter.format(goal.targetAmount)}',
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            children: [
                              Container(height: 8, color: AppColors.surfaceSecondary),
                              FractionallySizedBox(
                                widthFactor: goal.progress,
                                child: Container(
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: goal.color,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${CurrencyFormatter.format(goal.remainingAmount)} remaining',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                            ),
                            ElevatedButton(
                              onPressed: () => _showAddContributionDialog(context, ref, goal),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.surfaceSecondary,
                                foregroundColor: AppColors.textPrimary,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('+ Add Funds', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
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

  void _showCreateGoalDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final targetController = TextEditingController();
    final currentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Create Savings Goal', style: TextStyle(fontWeight: FontWeight.w700)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Goal Name', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                TextField(controller: titleController, decoration: const InputDecoration(hintText: 'e.g. Wedding, Electric Car')),
                const SizedBox(height: 14),
                const Text('Target Amount (₹)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                TextField(controller: targetController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'e.g. 150000')),
                const SizedBox(height: 14),
                const Text('Initial Deposit (₹)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                TextField(controller: currentController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'e.g. 10000')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                final target = double.tryParse(targetController.text.trim()) ?? 0;
                final initial = double.tryParse(currentController.text.trim()) ?? 0;
                if (title.isEmpty || target <= 0) return;

                final newGoal = SavingsGoalModel(
                  id: 'g_${DateTime.now().millisecondsSinceEpoch}',
                  title: title,
                  targetAmount: target,
                  currentAmount: initial,
                  targetDate: DateTime.now().add(const Duration(days: 180)),
                  icon: Icons.savings_outlined,
                  color: AppColors.purple,
                );
                ref.read(savingsGoalsProvider.notifier).addGoal(newGoal);
                Navigator.pop(ctx);
              },
              child: const Text('Create Goal'),
            ),
          ],
        );
      },
    );
  }

  void _showAddContributionDialog(BuildContext context, WidgetRef ref, SavingsGoalModel goal) {
    final amtController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Add Funds to "${goal.title}"', style: const TextStyle(fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current: ${CurrencyFormatter.format(goal.currentAmount)} / ${CurrencyFormatter.format(goal.targetAmount)}',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: 14),
              const Text('Deposit Amount (₹)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(
                controller: amtController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'e.g. 5000'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final amt = double.tryParse(amtController.text.trim()) ?? 0;
                if (amt <= 0) return;

                ref.read(savingsGoalsProvider.notifier).addContribution(goal.id, amt);
                Navigator.pop(ctx);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✓ Added ${CurrencyFormatter.format(amt)} to ${goal.title}'),
                    backgroundColor: AppColors.textPrimary,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Deposit'),
            ),
          ],
        );
      },
    );
  }
}
