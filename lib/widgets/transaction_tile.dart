import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/categories.dart';
import '../core/utils/currency_formatter.dart';
import '../models/transaction_model.dart';

class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final categoryItem = AppCategories.getCategoryByName(
      transaction.category,
      isExpense: transaction.isExpense,
    );

    return RepaintBoundary(
      child: Dismissible(
        key: Key(transaction.id),
        direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.danger,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 22),
      ),
      onDismissed: (_) {
        onDelete?.call();
      },
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF1F2F4), width: 1.2),
            boxShadow: const [AppShadows.card],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: categoryItem.backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  categoryItem.icon,
                  color: categoryItem.color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13.5,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${transaction.category} • ${CurrencyFormatter.formatDate(transaction.date)}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${transaction.isExpense ? '-' : '+'}${CurrencyFormatter.format(transaction.amount)}',
                style: TextStyle(
                  color: transaction.isExpense ? const Color(0xFFEF4444) : const Color(0xFF16A34A),
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
