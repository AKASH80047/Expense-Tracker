import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/currency_formatter.dart';

class MonthlyBudgetCard extends StatelessWidget {
  final double spent;
  final double limit;
  final VoidCallback? onTap;

  const MonthlyBudgetCard({
    super.key,
    required this.spent,
    required this.limit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = limit > 0 ? (spent / limit).clamp(0.0, 1.0) : 0.0;
    final double percentage = progress * 100;
    final bool isWarning = percentage >= 85;

    return RepaintBoundary(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFF1F2F4), width: 1.2),
            boxShadow: const [AppShadows.card],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Line 1: Title "Monthly Budget"
              Text(
                'Monthly Budget',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontSize: 13.5,
                ),
              ),
              const SizedBox(height: 6),

              // Line 2: Spent / Limit on left, Percentage on right
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: CurrencyFormatter.format(spent),
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            fontSize: 15.5,
                          ),
                        ),
                        TextSpan(
                          text: ' / ${CurrencyFormatter.format(limit)} spent',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Line 3: Yellow Progress Bar (Thin & Smooth)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    Container(
                      height: 6,
                      width: double.infinity,
                      color: const Color(0xFFF3F4F6),
                    ),
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: isWarning ? AppColors.warning : const Color(0xFFFFD83D),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Line 4: "✓ You're on track this month" and Chevron
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          color: Color(0xFF16A34A),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 9.5,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isWarning ? "Approaching monthly limit" : "You're on track this month",
                        style: const TextStyle(
                          color: Color(0xFF16A34A),
                          fontWeight: FontWeight.w500,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textTertiary,
                    size: 18,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
