import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/currency_formatter.dart';

class BalanceCard extends StatefulWidget {
  final double totalBalance;
  final double income;
  final double expenses;
  final double savings;
  final VoidCallback? onNotificationTap;

  const BalanceCard({
    super.key,
    required this.totalBalance,
    required this.income,
    required this.expenses,
    required this.savings,
    this.onNotificationTap,
  });

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _showBalance = true;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFFDE59),
              Color(0xFFFFD438),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD83D).withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
              spreadRadius: 0,
            ),
          ],
        ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: "Total Balance" + Eye Icon + Wallet Icon Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Total Balance',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary.withValues(alpha: 0.85),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showBalance = !_showBalance;
                      });
                    },
                    child: Icon(
                      _showBalance ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      size: 16,
                      color: AppColors.textPrimary.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Main Balance + ↑ 12% Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _showBalance ? CurrencyFormatter.format(widget.totalBalance) : '₹ ••••••',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.8,
                      fontSize: 28,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.arrow_upward_rounded,
                      size: 11,
                      color: Color(0xFF16A34A),
                    ),
                    SizedBox(width: 2),
                    Text(
                      '12%',
                      style: TextStyle(
                        color: Color(0xFF16A34A),
                        fontWeight: FontWeight.w700,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 3 White Sub-Cards: Income | Expenses | Savings
          Row(
            children: [
              Expanded(
                child: _buildSubCard(
                  context,
                  label: 'Income',
                  amount: widget.income,
                  color: const Color(0xFF16A34A),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildSubCard(
                  context,
                  label: 'Expenses',
                  amount: widget.expenses,
                  color: const Color(0xFFDC2626),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _buildSubCard(
                  context,
                  label: 'Savings',
                  amount: widget.savings,
                  color: const Color(0xFF2563EB),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildSubCard(
    BuildContext context, {
    required String label,
    required double amount,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              _showBalance ? CurrencyFormatter.format(amount) : '••••',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: color,
                fontSize: 13.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
