import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/wallet_model.dart';

final walletsProvider = NotifierProvider<WalletNotifier, List<WalletModel>>(() {
  return WalletNotifier();
});

class WalletNotifier extends Notifier<List<WalletModel>> {
  static final List<WalletModel> _initialWallets = [
    const WalletModel(
      id: 'w_hdfc',
      name: 'Main Bank (HDFC)',
      type: WalletType.bank,
      balance: 82500,
      accountNumber: '•••• 4921',
      color: Color(0xFF1E3A8A), // Deep navy
      icon: Icons.account_balance_rounded,
    ),
    const WalletModel(
      id: 'w_cash',
      name: 'Cash Wallet',
      type: WalletType.cash,
      balance: 12350,
      color: Color(0xFF10B981), // Emerald
      icon: Icons.payments_outlined,
    ),
    const WalletModel(
      id: 'w_credit',
      name: 'Credit Card (Regalia)',
      type: WalletType.credit,
      balance: -8500,
      accountNumber: '•••• 8832',
      color: Color(0xFF1F2937), // Dark slate
      icon: Icons.credit_card_rounded,
    ),
    const WalletModel(
      id: 'w_sbi',
      name: 'Savings Account (SBI)',
      type: WalletType.savings,
      balance: 38500,
      accountNumber: '•••• 7109',
      color: Color(0xFF0284C7), // Sky blue
      icon: Icons.savings_outlined,
    ),
  ];

  @override
  List<WalletModel> build() {
    return _initialWallets;
  }

  void addWallet(WalletModel wallet) {
    state = [...state, wallet];
  }

  void editWallet(WalletModel wallet) {
    state = state.map((w) => w.id == wallet.id ? wallet : w).toList();
  }

  void deleteWallet(String id) {
    state = state.where((w) => w.id != id).toList();
  }

  void adjustBalance(String walletId, double delta) {
    state = state.map((w) {
      if (w.id == walletId) {
        return w.copyWith(balance: w.balance + delta);
      }
      return w;
    }).toList();
  }

  bool transfer({
    required String fromWalletId,
    required String toWalletId,
    required double amount,
  }) {
    if (fromWalletId == toWalletId || amount <= 0) return false;

    state = state.map((w) {
      if (w.id == fromWalletId) {
        return w.copyWith(balance: w.balance - amount);
      } else if (w.id == toWalletId) {
        return w.copyWith(balance: w.balance + amount);
      }
      return w;
    }).toList();
    return true;
  }
}

final totalBalanceProvider = Provider<double>((ref) {
  final wallets = ref.watch(walletsProvider);
  return wallets.fold<double>(0.0, (sum, w) => sum + w.balance);
});
