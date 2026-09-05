import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recurring Bills'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add Recurring Bill',
            onPressed: () => _showAddBillDialog(context, ref),
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
                            color: Colors.white.withValues(alpha: 0.12),
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

              Text(
                'Active Subscriptions & Utilities (${bills.length})',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
              ),
              const SizedBox(height: 12),

              // Bills List
              Column(
                children: bills.map((bill) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.cardBorder),
                      boxShadow: const [AppShadows.card],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: bill.color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(bill.icon, color: bill.color, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bill.title,
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${bill.frequency} • ${bill.category}',
                                    style: const TextStyle(color: AppColors.textTertiary, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  CurrencyFormatter.format(bill.amount),
                                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  bill.dueStatusText,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: bill.isPaid
                                        ? AppColors.success
                                        : (bill.daysUntilDue <= 3 ? AppColors.danger : AppColors.textSecondary),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1, color: AppColors.cardBorder),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Mark Paid button
                            ElevatedButton.icon(
                              onPressed: () {
                                ref.read(recurringBillsProvider.notifier).togglePaid(bill.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(bill.isPaid ? 'Marked ${bill.title} as unpaid' : '✓ Paid ${bill.title}'),
                                    backgroundColor: AppColors.textPrimary,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              icon: Icon(
                                bill.isPaid ? Icons.undo_rounded : Icons.check_circle_outline_rounded,
                                size: 16,
                              ),
                              label: Text(
                                bill.isPaid ? 'Mark Unpaid' : 'Mark as Paid',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: bill.isPaid ? AppColors.surfaceSecondary : AppColors.primary,
                                foregroundColor: AppColors.textPrimary,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.danger),
                                  onPressed: () {
                                    ref.read(recurringBillsProvider.notifier).deleteBill(bill.id);
                                  },
                                ),
                              ],
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

  void _showAddBillDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Add Recurring Bill', style: TextStyle(fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Bill Name', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(controller: titleController, decoration: const InputDecoration(hintText: 'e.g. WiFi, Disney+ Hotstar')),
              const SizedBox(height: 14),
              const Text('Amount (₹)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(controller: amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'e.g. 999')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text.trim();
                final amt = double.tryParse(amountController.text.trim()) ?? 0;
                if (title.isEmpty || amt <= 0) return;

                final newBill = RecurringBillModel(
                  id: 'bill_${DateTime.now().millisecondsSinceEpoch}',
                  title: title,
                  amount: amt,
                  dueDate: DateTime.now().add(const Duration(days: 15)),
                  category: 'Bills & Utilities',
                  icon: Icons.receipt_long_rounded,
                  color: AppColors.info,
                );
                ref.read(recurringBillsProvider.notifier).addBill(newBill);
                Navigator.pop(ctx);
              },
              child: const Text('Add Bill'),
            ),
          ],
        );
      },
    );
  }
}
