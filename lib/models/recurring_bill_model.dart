import 'package:flutter/material.dart';

class RecurringBillModel {
  final String id;
  final String title;
  final double amount;
  final DateTime dueDate;
  final String frequency; // e.g. "Every month", "Every year"
  final String category;
  final bool isPaid;
  final IconData icon;
  final Color color;

  const RecurringBillModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.dueDate,
    this.frequency = 'Every month',
    required this.category,
    this.isPaid = false,
    required this.icon,
    required this.color,
  });

  int get daysUntilDue {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    return due.difference(today).inDays;
  }

  String get dueStatusText {
    if (isPaid) return 'Paid';
    final days = daysUntilDue;
    if (days < 0) return 'Overdue by ${-days} days';
    if (days == 0) return 'Due today';
    if (days == 1) return 'Due tomorrow';
    return 'Due in $days days';
  }

  RecurringBillModel copyWith({
    String? id,
    String? title,
    double? amount,
    DateTime? dueDate,
    String? frequency,
    String? category,
    bool? isPaid,
    IconData? icon,
    Color? color,
  }) {
    return RecurringBillModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      frequency: frequency ?? this.frequency,
      category: category ?? this.category,
      isPaid: isPaid ?? this.isPaid,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }
}
