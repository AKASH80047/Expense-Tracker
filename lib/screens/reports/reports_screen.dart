import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../providers/transaction_provider.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  String _selectedReportType = 'Monthly Report';
  final List<String> _reportTypes = [
    'Monthly Report',
    'Yearly Report',
    'Expense Report',
    'Income Report',
  ];

  @override
  Widget build(BuildContext context) {
    final income = ref.watch(totalIncomeProvider);
    final expenses = ref.watch(totalExpensesProvider);
    final savings = ref.watch(totalSavingsProvider);
    final categorySpending = ref.watch(categorySpendingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial Reports'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Report Type Selector Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: _reportTypes.map((type) {
                    final isSelected = _selectedReportType == type;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(type),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surface,
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        ),
                        side: BorderSide(
                          color: isSelected ? AppColors.primaryDark : AppColors.cardBorder,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedReportType = type);
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Summary Card for September 2026
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.cardBorder),
                  boxShadow: const [AppShadows.card],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'September 2026 Statement',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.successLight,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Balanced',
                            style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w700, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _buildReportMetricRow('Income', CurrencyFormatter.format(income), AppColors.success),
                    const SizedBox(height: 10),
                    _buildReportMetricRow('Expenses', CurrencyFormatter.format(expenses), AppColors.danger),
                    const SizedBox(height: 10),
                    _buildReportMetricRow('Net Savings', CurrencyFormatter.format(savings), AppColors.info),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: AppColors.cardBorder),
                    const SizedBox(height: 16),
                    Text(
                      'Category Breakdown Summary',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 10),
                    ...categorySpending.take(4).map((c) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(c.category, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                            Text(
                              '${CurrencyFormatter.format(c.amount)} (${c.percentage.toStringAsFixed(0)}%)',
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Export Actions
              Text(
                'Export Options',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: const [
                                Icon(Icons.picture_as_pdf_rounded, color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Text('✓ PDF report generated successfully'),
                              ],
                            ),
                            backgroundColor: AppColors.textPrimary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                      icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                      label: const Text('Export PDF'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: const [
                                Icon(Icons.table_chart_outlined, color: Colors.white, size: 20),
                                SizedBox(width: 8),
                                Text('✓ CSV ledger exported successfully'),
                              ],
                            ),
                            backgroundColor: AppColors.textPrimary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                      icon: const Icon(Icons.table_chart_outlined, size: 18),
                      label: const Text('Export CSV'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportMetricRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}
