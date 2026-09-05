import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _inrFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final NumberFormat _inrWithDecimals = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 2,
  );

  /// Formats amount into Indian Rupee format, e.g. ₹1,24,850
  static String format(double amount, {bool showDecimals = false}) {
    if (showDecimals && (amount % 1 != 0)) {
      return _inrWithDecimals.format(amount);
    }
    return _inrFormatter.format(amount);
  }

  /// Formats compact numbers, e.g. ₹35K, ₹1.2L, ₹1.5Cr
  static String formatCompact(double amount) {
    if (amount.abs() >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(1)}Cr';
    } else if (amount.abs() >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount.abs() >= 1000) {
      return '₹${(amount / 1000).toStringAsFixed(0)}K';
    }
    return format(amount);
  }

  /// Formats date for display: "Today", "Yesterday", or "05 Sep 2026"
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final aDate = DateTime(date.year, date.month, date.day);

    if (aDate == today) {
      return 'Today';
    } else if (aDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return DateFormat('dd MMM yyyy').format(date);
    }
  }

  /// Formats time: "10:30 AM"
  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  /// Formats full date with time
  static String formatDateTime(DateTime date) {
    return '${formatDate(date)}, ${formatTime(date)}';
  }
}
