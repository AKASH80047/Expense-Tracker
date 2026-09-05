import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/transaction_model.dart';
import '../../providers/transaction_provider.dart';
import '../../widgets/transaction_tile.dart';
import '../add_transaction/add_transaction_screen.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All'; // All, Expenses, Income
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final allTransactions = ref.watch(transactionsProvider);
    final totalIncome = ref.watch(totalIncomeProvider);
    final totalExpenses = ref.watch(totalExpensesProvider);

    // Apply filtering
    List<TransactionModel> filtered = allTransactions.where((tx) {
      if (_selectedFilter == 'Expenses' && !tx.isExpense) return false;
      if (_selectedFilter == 'Income' && tx.isExpense) return false;
      if (_selectedCategory != null && tx.category != _selectedCategory) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchTitle = tx.title.toLowerCase().contains(q);
        final matchCategory = tx.category.toLowerCase().contains(q);
        final matchWallet = tx.walletName.toLowerCase().contains(q);
        final matchNotes = tx.notes?.toLowerCase().contains(q) ?? false;
        if (!matchTitle && !matchCategory && !matchWallet && !matchNotes) return false;
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search & Filter header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                children: [
                  // Search TextField
                  TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Search transactions, stores, notes...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              onPressed: () => setState(() => _searchQuery = ''),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Filter Chips (All, Expenses, Income)
                  Row(
                    children: [
                      _buildFilterChip('All'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Expenses'),
                      const SizedBox(width: 8),
                      _buildFilterChip('Income'),
                    ],
                  ),
                ],
              ),
            ),

            // Summary strip
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${filtered.length} transactions',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Total: ',
                        style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
                      ),
                      Text(
                        _selectedFilter == 'Income'
                            ? '+${CurrencyFormatter.format(totalIncome)}'
                            : _selectedFilter == 'Expenses'
                                ? '-${CurrencyFormatter.format(totalExpenses)}'
                                : CurrencyFormatter.format(totalIncome - totalExpenses),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: _selectedFilter == 'Income'
                              ? AppColors.success
                              : _selectedFilter == 'Expenses'
                                  ? AppColors.danger
                                  : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Transactions List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.textTertiary.withValues(alpha: 0.5)),
                          const SizedBox(height: 12),
                          Text(
                            'No transactions found',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final tx = filtered[index];
                        return TransactionTile(
                          transaction: tx,
                          onTap: () => _showTransactionDetails(context, tx),
                          onDelete: () {
                            ref.read(transactionsProvider.notifier).deleteTransaction(tx.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Deleted "${tx.title}"'),
                                backgroundColor: AppColors.textPrimary,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textPrimary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.textPrimary : AppColors.cardBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  void _showTransactionDetails(BuildContext context, TransactionModel tx) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.cardBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tx.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Text(
                    '${tx.isExpense ? '-' : '+'}${CurrencyFormatter.format(tx.amount)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: tx.isExpense ? AppColors.danger : AppColors.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Category', tx.category),
              _buildDetailRow('Account / Wallet', tx.walletName),
              _buildDetailRow('Date & Time', CurrencyFormatter.formatDateTime(tx.date)),
              if (tx.notes != null) _buildDetailRow('Notes', tx.notes!),
              if (tx.receiptStore != null) _buildDetailRow('Receipt Store', tx.receiptStore!),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref.read(transactionsProvider.notifier).deleteTransaction(tx.id);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Deleted "${tx.title}"'),
                        backgroundColor: AppColors.textPrimary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                  label: const Text('Delete Transaction', style: TextStyle(color: AppColors.danger)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.danger),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13.5)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }
}
