enum TransactionType { expense, income }

class TransactionModel {
  final String id;
  final String title;
  final String category;
  final double amount;
  final TransactionType type;
  final String walletId;
  final String walletName;
  final DateTime date;
  final String? notes;
  final String? receiptStore;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.type,
    required this.walletId,
    required this.walletName,
    required this.date,
    this.notes,
    this.receiptStore,
  });

  bool get isExpense => type == TransactionType.expense;

  TransactionModel copyWith({
    String? id,
    String? title,
    String? category,
    double? amount,
    TransactionType? type,
    String? walletId,
    String? walletName,
    DateTime? date,
    String? notes,
    String? receiptStore,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      walletId: walletId ?? this.walletId,
      walletName: walletName ?? this.walletName,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      receiptStore: receiptStore ?? this.receiptStore,
    );
  }
}
