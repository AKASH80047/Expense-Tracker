import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction_model.dart';
import 'wallet_provider.dart';
import 'budget_provider.dart';

final transactionsProvider = NotifierProvider<TransactionNotifier, List<TransactionModel>>(() {
  return TransactionNotifier();
});

class TransactionNotifier extends Notifier<List<TransactionModel>> {
  static final List<TransactionModel> _initialTransactions = [
    TransactionModel(
      id: 'tx_1',
      title: 'Amazon',
      category: 'Shopping',
      amount: 2499,
      type: TransactionType.expense,
      walletId: 'w_credit',
      walletName: 'Credit Card',
      date: DateTime.now().subtract(const Duration(hours: 3)),
      notes: 'Noise cancelling headphones',
      receiptStore: 'Amazon',
    ),
    TransactionModel(
      id: 'tx_2',
      title: 'Monthly Salary',
      category: 'Salary',
      amount: 68500,
      type: TransactionType.income,
      walletId: 'w_hdfc',
      walletName: 'HDFC Bank',
      date: DateTime.now().subtract(const Duration(days: 4)),
      notes: 'TechCorp salary credit for September',
    ),
    TransactionModel(
      id: 'tx_3',
      title: 'Swiggy',
      category: 'Food & Dining',
      amount: 540,
      type: TransactionType.expense,
      walletId: 'w_cash',
      walletName: 'Cash Wallet',
      date: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      notes: 'Dinner with friends',
    ),
    TransactionModel(
      id: 'tx_4',
      title: 'Uber',
      category: 'Transportation',
      amount: 320,
      type: TransactionType.expense,
      walletId: 'w_hdfc',
      walletName: 'HDFC Bank',
      date: DateTime.now().subtract(const Duration(days: 2)),
      notes: 'Ride to client office',
    ),
    TransactionModel(
      id: 'tx_5',
      title: 'Apple Store',
      category: 'Shopping',
      amount: 8999,
      type: TransactionType.expense,
      walletId: 'w_credit',
      walletName: 'Credit Card',
      date: DateTime.now().subtract(const Duration(days: 5)),
      notes: 'MagSafe Charger & Case',
      receiptStore: 'Apple Store',
    ),
    TransactionModel(
      id: 'tx_6',
      title: 'Freelance Design Project',
      category: 'Freelance & Bonus',
      amount: 15000,
      type: TransactionType.income,
      walletId: 'w_sbi',
      walletName: 'SBI Savings',
      date: DateTime.now().subtract(const Duration(days: 6)),
      notes: 'UI Design for FinTech MVP',
    ),
    TransactionModel(
      id: 'tx_7',
      title: 'Zara Fashion',
      category: 'Shopping',
      amount: 4602,
      type: TransactionType.expense,
      walletId: 'w_credit',
      walletName: 'Credit Card',
      date: DateTime.now().subtract(const Duration(days: 7)),
      notes: 'Autumn jacket',
    ),
    TransactionModel(
      id: 'tx_8',
      title: 'Blinkit Groceries',
      category: 'Food & Dining',
      amount: 1850,
      type: TransactionType.expense,
      walletId: 'w_hdfc',
      walletName: 'HDFC Bank',
      date: DateTime.now().subtract(const Duration(days: 8)),
      notes: 'Weekly fresh vegetables & essentials',
    ),
    TransactionModel(
      id: 'tx_9',
      title: 'Fuel & Metro Card',
      category: 'Transportation',
      amount: 6030,
      type: TransactionType.expense,
      walletId: 'w_hdfc',
      walletName: 'HDFC Bank',
      date: DateTime.now().subtract(const Duration(days: 10)),
      notes: 'Monthly commute refill',
    ),
    TransactionModel(
      id: 'tx_10',
      title: 'Dining at Social',
      category: 'Food & Dining',
      amount: 6927,
      type: TransactionType.expense,
      walletId: 'w_hdfc',
      walletName: 'HDFC Bank',
      date: DateTime.now().subtract(const Duration(days: 12)),
      notes: 'Weekend team dinner',
    ),
    TransactionModel(
      id: 'tx_11',
      title: 'Netflix & Spotify Subs',
      category: 'Entertainment',
      amount: 5082,
      type: TransactionType.expense,
      walletId: 'w_credit',
      walletName: 'Credit Card',
      date: DateTime.now().subtract(const Duration(days: 14)),
      notes: 'Monthly recurring entertainment subscriptions',
    ),
    TransactionModel(
      id: 'tx_12',
      title: 'Miscellaneous & Utility',
      category: 'Bills & Utilities',
      amount: 3500,
      type: TransactionType.expense,
      walletId: 'w_hdfc',
      walletName: 'HDFC Bank',
      date: DateTime.now().subtract(const Duration(days: 15)),
      notes: 'Water bill & maintenance',
    ),
    TransactionModel(
      id: 'tx_13',
      title: 'Pharmacy & Fitness',
      category: 'Other',
      amount: 2001,
      type: TransactionType.expense,
      walletId: 'w_cash',
      walletName: 'Cash Wallet',
      date: DateTime.now().subtract(const Duration(days: 18)),
      notes: 'Supplements & first aid',
    ),
  ];

  @override
  List<TransactionModel> build() {
    return _initialTransactions;
  }

  void addTransaction(TransactionModel transaction) {
    state = [transaction, ...state];

    // Update wallet balance
    final walletDelta = transaction.isExpense ? -transaction.amount : transaction.amount;
    ref.read(walletsProvider.notifier).adjustBalance(transaction.walletId, walletDelta);

    // Update budget spent if expense
    if (transaction.isExpense) {
      ref.read(budgetsProvider.notifier).addExpenseToCategory(transaction.category, transaction.amount);
    }
  }

  void deleteTransaction(String id) {
    final tx = state.firstWhere((t) => t.id == id, orElse: () => state.first);
    final walletDelta = tx.isExpense ? tx.amount : -tx.amount;
    ref.read(walletsProvider.notifier).adjustBalance(tx.walletId, walletDelta);

    if (tx.isExpense) {
      ref.read(budgetsProvider.notifier).addExpenseToCategory(tx.category, -tx.amount);
    }

    state = state.where((t) => t.id != id).toList();
  }
}

// Financial summary providers
final totalIncomeProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionsProvider);
  return transactions
      .where((t) => !t.isExpense)
      .fold<double>(0.0, (sum, item) => sum + item.amount);
});

final totalExpensesProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionsProvider);
  return transactions
      .where((t) => t.isExpense)
      .fold<double>(0.0, (sum, item) => sum + item.amount);
});

final totalSavingsProvider = Provider<double>((ref) {
  final income = ref.watch(totalIncomeProvider);
  final expenses = ref.watch(totalExpensesProvider);
  return (income - expenses) > 0 ? (income - expenses) : 0.0;
});

// Category expense breakdown
class CategorySpending {
  final String category;
  final double amount;
  final double percentage;

  CategorySpending({
    required this.category,
    required this.amount,
    required this.percentage,
  });
}

final categorySpendingProvider = Provider<List<CategorySpending>>((ref) {
  final transactions = ref.watch(transactionsProvider);
  final expenses = transactions.where((t) => t.isExpense).toList();
  final totalExp = expenses.fold<double>(0.0, (sum, item) => sum + item.amount);

  if (totalExp == 0) return [];

  final Map<String, double> map = {};
  for (var tx in expenses) {
    String cat = tx.category;
    if (cat.contains('Shopping')) {
      cat = 'Shopping';
    } else if (cat.contains('Food')) {
      cat = 'Food';
    } else if (cat.contains('Transport')) {
      cat = 'Transportation';
    } else if (cat.contains('Entertainment')) {
      cat = 'Entertainment';
    } else if (cat.contains('Bills')) {
      cat = 'Bills';
    } else {
      cat = 'Other';
    }

    map[cat] = (map[cat] ?? 0) + tx.amount;
  }

  final list = map.entries.map((e) {
    return CategorySpending(
      category: e.key,
      amount: e.value,
      percentage: (e.value / totalExp) * 100,
    );
  }).toList();

  list.sort((a, b) => b.amount.compareTo(a.amount));
  return list;
});
