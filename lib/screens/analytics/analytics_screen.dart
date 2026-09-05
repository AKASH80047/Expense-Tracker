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
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;

    // Toggle widget
    Widget buildToggle() {
      return Container(
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
                onTap: () => setState(() => _isExpenses = true),
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
                onTap: () => setState(() => _isExpenses = false),
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
      );
    }

    // Donut + Legend card
    Widget buildDonutSection() {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: const [AppShadows.card],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: CustomDonutChart(
                    items: categorySpending,
                    totalAmount: _isExpenses ? expenses : income,
                    centerLabel: _isExpenses ? 'Total Expenses' : 'Total Income',
                  ),
                ),
                const SizedBox(width: 16),
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
          ],
        ),
      );
    }

    // Top categories list
    Widget buildTopCategoriesSection() {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: const [AppShadows.card],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Spending Categories',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
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
          ],
        ),
      );
    }

    // Spending Trend widget
    Widget buildTrendSection() {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: const [AppShadows.card],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Spending Trend (Last 6 Months)',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            CustomTrendChart(data: _trendData),
          ],
        ),
      );
    }

    // AI Analysis widget
    Widget buildAISection() {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [AppShadows.card],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.auto_awesome, color: AppColors.textPrimary, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Smart Financial AI Analysis',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '• Your spending increased by 8.5% this month.\n• Shopping is your highest expense category (38%).\n• Potential monthly saving: ₹4,500 – ₹6,000.',
              style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AIAssistantScreen()),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                label: const Text('Ask Copilot', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Financial Analytics'),
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
                    setState(() => _selectedPeriod = val);
                  }
                },
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
              child: isDesktop
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 320, child: buildToggle()),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Column (Donut & Categories)
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: [
                                  buildDonutSection(),
                                  const SizedBox(height: 20),
                                  buildTopCategoriesSection(),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            // Right Column (Trend Chart & AI)
                            Expanded(
                              flex: 6,
                              child: Column(
                                children: [
                                  buildTrendSection(),
                                  const SizedBox(height: 20),
                                  buildAISection(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildToggle(),
                        const SizedBox(height: 16),
                        buildDonutSection(),
                        const SizedBox(height: 16),
                        buildTopCategoriesSection(),
                        const SizedBox(height: 16),
                        buildTrendSection(),
                        const SizedBox(height: 16),
                        buildAISection(),
                        const SizedBox(height: 20),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
