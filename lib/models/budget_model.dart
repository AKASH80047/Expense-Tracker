class BudgetModel {
  final String id;
  final String category;
  final double limit;
  final double spent;
  final String month;
  final int year;

  const BudgetModel({
    required this.id,
    required this.category,
    required this.limit,
    required this.spent,
    required this.month,
    required this.year,
  });

  double get percentage => limit > 0 ? (spent / limit).clamp(0.0, 1.5) : 0.0;
  double get percentageNumber => percentage * 100;
  double get remaining => (limit - spent) > 0 ? (limit - spent) : 0.0;
  bool get isExceeded => spent > limit;
  bool get isWarning => percentage >= 0.8 && !isExceeded;

  BudgetModel copyWith({
    String? id,
    String? category,
    double? limit,
    double? spent,
    String? month,
    int? year,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      category: category ?? this.category,
      limit: limit ?? this.limit,
      spent: spent ?? this.spent,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }
}
