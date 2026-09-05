import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/currency_formatter.dart';
import '../providers/transaction_provider.dart';

class DonutChartData {
  final String label;
  final double amount;
  final double percentage;
  final Color color;

  DonutChartData({
    required this.label,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}

class CustomDonutChart extends StatefulWidget {
  final List<CategorySpending> items;
  final double totalAmount;
  final String centerLabel;

  const CustomDonutChart({
    super.key,
    required this.items,
    required this.totalAmount,
    this.centerLabel = 'Total Expenses',
  });

  @override
  State<CustomDonutChart> createState() => _CustomDonutChartState();
}

class _CustomDonutChartState extends State<CustomDonutChart> {
  static const List<Color> _chartColors = [
    Color(0xFFFFD83D), // Shopping
    Color(0xFFF472B6), // Food
    Color(0xFF2DD4BF), // Transportation
    Color(0xFF60A5FA), // Entertainment
    Color(0xFF34D399), // Other
  ];

  @override
  Widget build(BuildContext context) {
    final List<DonutChartData> chartData = [];
    for (int i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];
      chartData.add(
        DonutChartData(
          label: item.category,
          amount: item.amount,
          percentage: item.percentage,
          color: _chartColors[i % _chartColors.length],
        ),
      );
    }

    return RepaintBoundary(
      child: SizedBox(
        height: 160,
        width: 160,
        child: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(160, 160),
              painter: _DonutChartPainter(
                data: chartData,
                strokeWidth: 22,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  CurrencyFormatter.format(widget.totalAmount),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  widget.centerLabel,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<DonutChartData> data;
  final double strokeWidth;

  _DonutChartPainter({
    required this.data,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    double startAngle = -math.pi / 2;
    final totalPercentage = data.fold<double>(0.0, (s, d) => s + d.percentage);

    if (totalPercentage == 0) return;

    for (int i = 0; i < data.length; i++) {
      final sweepAngle = (data[i].percentage / totalPercentage) * 2 * math.pi;

      final paint = Paint()
        ..color = data[i].color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}
