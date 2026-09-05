import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/currency_formatter.dart';

class MonthSpendingPoint {
  final String month;
  final double amount;

  const MonthSpendingPoint(this.month, this.amount);
}

class CustomTrendChart extends StatelessWidget {
  final List<MonthSpendingPoint> data;

  const CustomTrendChart({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final maxAmount = data.map((e) => e.amount).reduce((a, b) => a > b ? a : b) * 1.15;

    return RepaintBoundary(
      child: Column(
        children: [
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(data.length, (index) {
                final point = data[index];
                final heightFactor = (point.amount / maxAmount).clamp(0.15, 1.0);

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          CurrencyFormatter.formatCompact(point.amount),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 90 * heightFactor,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD83D),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          point.month.substring(0, 3),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
