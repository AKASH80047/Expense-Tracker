import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../providers/transaction_provider.dart';
import '../../widgets/custom_donut_chart.dart';
import '../../widgets/custom_trend_chart.dart';
import '../ai_assistant/ai_assistant_screen.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  String _selectedPeriod = 'This Month';
  bool _isExpenses = true;

  final List<MonthSpendingPoint> _trendData = const [
    MonthSpendingPoint('Jan', 31000),
    MonthSpendingPoint('Feb', 35000),
    MonthSpendingPoint('Mar', 38000),
    MonthSpendingPoint('Apr', 34000),
    MonthSpendingPoint('May', 40000),
    MonthSpendingPoint('Jun', 42350),
  ];

  static const List<Map<String, dynamic>> _topCategories = [
    {
      'name': 'Shopping',
      'percentage': 38.0,
      'amount': 16100.0,
      'icon': Icons.shopping_cart_outlined,
      'color': Color(0xFFFFD83D),
      'iconBg': Color(0xFFFFF7D6),
    },
    {
      'name': 'Food',
      'percentage': 22.0,
      'amount': 9317.0,
      'icon': Icons.restaurant_outlined,
      'color': Color(0xFFF472B6),
      'iconBg': Color(0xFFFCE7F3),
    },
    {
      'name': 'Transportation',
      'percentage': 15.0,
      'amount': 6350.0,
      'icon': Icons.directions_car_outlined,
      'color': Color(0xFF2DD4BF),
      'iconBg': Color(0xFFCCFBF1),
    },
    {
      'name': 'Entertainment',
      'percentage': 12.0,
      'amount': 5082.0,
      'icon': Icons.music_note_outlined,
      'color': Color(0xFF60A5FA),
      'iconBg': Color(0xFFDBEAFE),
    },
    {
      'name': 'Other',
      'percentage': 13.0,
      'amount': 5501.0,
      'icon': Icons.more_horiz_rounded,
      'color': Color(0xFF34D399),
      'iconBg': Color(0xFFD1FAE5),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final expenses = ref.watch(totalExpensesProvider);
    final income = ref.watch(totalIncomeProvider);
    final categorySpending = ref.watch(categorySpendingProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Financial Analytics',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedPeriod,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.textPrimary),
                items: [
                  DropdownMenuItem(
                    value: 'This Month',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.textSecondary),
                        SizedBox(width: 5),
                        Text('This Month', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Last Month',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.textSecondary),
                        SizedBox(width: 5),
                        Text('Last Month', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedPeriod = val;
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Expenses | Income Toggle
              Container(
                height: 44,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpenses = true;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: _isExpenses ? const Color(0xFFFFD83D) : Colors.transparent,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Expenses',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: _isExpenses ? FontWeight.w700 : FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpenses = false;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: !_isExpenses ? const Color(0xFFFFD83D) : Colors.transparent,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Income',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: !_isExpenses ? FontWeight.w700 : FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 2. Donut Chart + Legend Side-by-Side
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Donut Chart
                  Expanded(
                    flex: 5,
                    child: CustomDonutChart(
                      items: categorySpending,
                      totalAmount: _isExpenses ? expenses : income,
                      centerLabel: _isExpenses ? 'Total Expenses' : 'Total Income',
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Legend
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _topCategories.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: item['color'] as Color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item['name'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              Text(
                                '${(item['percentage'] as double).toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 3. Top Spending Categories
              const Text(
                'Top Spending Categories',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              Column(
                children: _topCategories.map((item) {
                  final color = item['color'] as Color;
                  final iconBg = item['iconBg'] as Color;
                  final percentage = item['percentage'] as double;
                  final amount = item['amount'] as double;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      children: [
                        // Category Icon
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: iconBg,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            item['icon'] as IconData,
                            size: 18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Name + Progress bar
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item['name'] as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13.5,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    '${percentage.toStringAsFixed(0)}%',
                                    style: const TextStyle(
                                      color: AppColors.textTertiary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 6,
                                      width: double.infinity,
                                      color: const Color(0xFFF3F4F6),
                                    ),
                                    FractionallySizedBox(
                                      widthFactor: (percentage / 100).clamp(0.05, 1.0),
                                      child: Container(
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: color,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Amount
                        Text(
                          CurrencyFormatter.format(amount),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // 4. Spending Trend (Last 6 Months)
              const Text(
                'Spending Trend (Last 6 Months)',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              CustomTrendChart(data: _trendData),
              const SizedBox(height: 24),

              // 5. AI Analysis Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Robot Avatar
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.smart_toy_outlined,
                            color: AppColors.textPrimary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'AI Analysis',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Your spending increased by 8.5% this month.\nShopping is your highest expense category.\nPotential monthly saving: ₹4,500 – ₹6,000',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AIAssistantScreen(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD83D),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                'Ask AI Assistant',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.textPrimary),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
