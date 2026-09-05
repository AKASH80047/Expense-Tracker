import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/recurring_bill_model.dart';
import '../../providers/bills_provider.dart';

class RecurringBillsScreen extends ConsumerWidget {
  const RecurringBillsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bills = ref.watch(recurringBillsProvider);
    final totalMonthly = bills.fold<double>(0.0, (s, b) => s + b.amount);
    final unpaidMonthly = bills.where((b) => !b.isPaid).fold<double>(0.0, (s, b) => s + b.amount);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recurring Bills'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD83D),
                foregroundColor: AppColors.textPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              onPressed: () => _showAddBillDialog(context, ref),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text(
                'Add Bill',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 32 : 20,
                vertical: isDesktop ? 20 : 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Monthly Commitments Overview
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2C1810), Color(0xFF180D08)],
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
                              'Total Monthly Commitments',
                              style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '${bills.where((b) => !b.isPaid).length} Pending',
                                style: const TextStyle(color: AppColors.orange, fontWeight: FontWeight.w700, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          CurrencyFormatter.format(totalMonthly),
                          style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Unpaid balance due this month: ${CurrencyFormatter.format(unpaidMonthly)}',
                          style: const TextStyle(color: Colors.white70, fontSize: 12.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subscriptions & Bills',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                      ),
                      Text(
                        '${bills.length} Active',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Bills Grid / List
                  if (isDesktop)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: screenWidth >= 1100 ? 3 : 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent: 140,
                      ),
                      itemCount: bills.length,
                      itemBuilder: (context, index) {
                        return _buildBillItem(context, ref, bills[index]);
                      },
                    )
                  else
                    Column(
                      children: bills.map((b) => _buildBillItem(context, ref, b)).toList(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBillItem(BuildContext context, WidgetRef ref, RecurringBillModel bill) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: bill.daysUntilDue < 0 && !bill.isPaid
              ? AppColors.danger.withOpacity(0.5)
              : AppColors.cardBorder,
        ),
        boxShadow: const [AppShadows.card],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bill.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(bill.icon, color: bill.color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  bill.title,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5),
                ),
                const SizedBox(height: 2),
                Text(
                  '${bill.dueStatusText} (${DateFormat("d MMM").format(bill.dueDate)})',
                  style: TextStyle(
                    color: bill.daysUntilDue < 0 && !bill.isPaid
                        ? AppColors.danger
                        : AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: bill.daysUntilDue < 0 && !bill.isPaid ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.format(bill.amount),
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              bill.isPaid ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              color: bill.isPaid ? AppColors.success : AppColors.textTertiary,
              size: 26,
            ),
            tooltip: bill.isPaid ? 'Mark as Unpaid' : 'Mark as Paid',
            onPressed: () {
              ref.read(recurringBillsProvider.notifier).togglePaid(bill.id);
            },
          ),
        ],
      ),
    );
  }

  void _showAddBillDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    DateTime dueDate = DateTime.now().add(const Duration(days: 7));

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Add Recurring Bill'),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Bill / Subscription Title',
                      hintText: 'e.g. Netflix, Electricity, Rent',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount (₹)',
                      hintText: 'e.g. 799',
                      prefixText: '₹ ',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final title = titleController.text.trim();
                  final amount = double.tryParse(amountController.text.trim());
                  if (title.isNotEmpty && amount != null && amount > 0) {
                    ref.read(recurringBillsProvider.notifier).addBill(
                          RecurringBillModel(
                            id: 'bill_${DateTime.now().millisecondsSinceEpoch}',
                            title: title,
                            amount: amount,
                            dueDate: dueDate,
                            category: 'Bills & Utilities',
                            icon: Icons.receipt_outlined,
                            color: AppColors.orange,
                            isPaid: false,
                          ),
                        );
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('Add Bill'),
              ),
            ],
          );
        },
      ),
    );
  }
}
