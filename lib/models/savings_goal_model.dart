import 'package:flutter/material.dart';

class SavingsGoalModel {
  final String id;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final DateTime targetDate;
  final IconData icon;
  final Color color;

  const SavingsGoalModel({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    required this.icon,
    required this.color,
  });

  double get progress => targetAmount > 0 ? (currentAmount / targetAmount).clamp(0.0, 1.0) : 0.0;
  double get percentage => progress * 100;
  double get remainingAmount => (targetAmount - currentAmount) > 0 ? (targetAmount - currentAmount) : 0.0;
  bool get isCompleted => currentAmount >= targetAmount;

  SavingsGoalModel copyWith({
    String? id,
    String? title,
    double? targetAmount,
    double? currentAmount,
    DateTime? targetDate,
    IconData? icon,
    Color? color,
  }) {
    return SavingsGoalModel(
      id: id ?? this.id,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      targetDate: targetDate ?? this.targetDate,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }
}
