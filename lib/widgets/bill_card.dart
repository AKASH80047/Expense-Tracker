import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/currency_formatter.dart';
import '../models/recurring_bill_model.dart';

class BillCard extends StatelessWidget {
  final RecurringBillModel bill;
  final VoidCallback? onTap;
  final VoidCallback? onMarkPaid;

  const BillCard({
    super.key,
    required this.bill,
    this.onTap,
    this.onMarkPaid,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 108,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F2F4), width: 1.2),
          boxShadow: const [AppShadows.card],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top: Icon
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: bill.color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                bill.icon,
                color: bill.color,
                size: 16,
              ),
            ),

            // Title & Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bill.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  CurrencyFormatter.format(bill.amount),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),

            // Due Status (e.g. Due in 3 days)
            Text(
              'Due in ${bill.daysUntilDue} days',
              style: TextStyle(
                color: bill.daysUntilDue <= 3 ? const Color(0xFFEF4444) : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
                fontSize: 9.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
