import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/wallet_model.dart';
import '../../providers/wallet_provider.dart';

class WalletsScreen extends ConsumerStatefulWidget {
  final bool initialShowTransfer;

  const WalletsScreen({super.key, this.initialShowTransfer = false});

  @override
  ConsumerState<WalletsScreen> createState() => _WalletsScreenState();
}

class _WalletsScreenState extends ConsumerState<WalletsScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.initialShowTransfer) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showTransferModal(context, ref);
      });
    }
  }

  String _getWalletTypeDescription(WalletType type) {
    switch (type) {
      case WalletType.bank:
        return 'Primary Bank Account';
      case WalletType.cash:
        return 'Physical Cash';
      case WalletType.credit:
        return 'Credit Card';
      case WalletType.upi:
        return 'UPI Digital Wallet';
      case WalletType.savings:
        return 'Savings Account';
    }
  }

  @override
  Widget build(BuildContext context) {
    final wallets = ref.watch(walletsProvider);
    final totalBalance = ref.watch(totalBalanceProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallets & Accounts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded),
            tooltip: 'Transfer Money',
            onPressed: () => _showTransferModal(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Add Account',
            onPressed: () => _showAddEditWalletDialog(context, ref),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Total Net Worth / Balance
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [AppShadows.elevated],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Net Liquidity & Accounts',
                          style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          CurrencyFormatter.format(totalBalance),
                          style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            _buildQuickHeaderAction(
                              icon: Icons.swap_horiz_rounded,
                              label: 'Transfer Funds',
                              onTap: () => _showTransferModal(context, ref),
                            ),
                            const SizedBox(width: 12),
                            _buildQuickHeaderAction(
                              icon: Icons.add_rounded,
                              label: 'Add Account',
                              onTap: () => _showAddEditWalletDialog(context, ref),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your Accounts',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                      ),
                      Text(
                        '${wallets.length} Accounts',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Accounts Grid / List
                  if (isDesktop)
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: screenWidth >= 1100 ? 3 : 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent: 140,
                      ),
                      itemCount: wallets.length,
                      itemBuilder: (context, index) {
                        return _buildWalletCard(context, ref, wallets[index]);
                      },
                    )
                  else
                    Column(
                      children: wallets.map((w) => _buildWalletCard(context, ref, w)).toList(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickHeaderAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWalletCard(BuildContext context, WidgetRef ref, WalletModel wallet) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: const [AppShadows.card],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: wallet.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(wallet.icon, color: wallet.color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  wallet.name,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                const SizedBox(height: 2),
                Text(
                  _getWalletTypeDescription(wallet.type),
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Text(
                  CurrencyFormatter.format(wallet.balance),
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.textSecondary),
            tooltip: 'Edit Balance',
            onPressed: () => _showAddEditWalletDialog(context, ref, wallet: wallet),
          ),
        ],
      ),
    );
  }

  void _showAddEditWalletDialog(BuildContext context, WidgetRef ref, {WalletModel? wallet}) {
    final isEditing = wallet != null;
    final nameController = TextEditingController(text: isEditing ? wallet.name : '');
    final balanceController = TextEditingController(
      text: isEditing ? wallet.balance.toInt().toString() : '',
    );
    WalletType selectedType = isEditing ? wallet.type : WalletType.bank;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(isEditing ? 'Edit Account' : 'Add New Account'),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Account Name',
                      hintText: 'e.g. HDFC Bank, PayTM, Cash',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: balanceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Current Balance (₹)',
                      hintText: 'e.g. 50000',
                      prefixText: '₹ ',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  final balance = double.tryParse(balanceController.text.trim());
                  if (name.isNotEmpty && balance != null) {
                    if (isEditing) {
                      final delta = balance - wallet.balance;
                      ref.read(walletsProvider.notifier).adjustBalance(wallet.id, delta);
                    } else {
                      ref.read(walletsProvider.notifier).addWallet(
                            WalletModel(
                              id: 'w_${DateTime.now().millisecondsSinceEpoch}',
                              name: name,
                              type: selectedType,
                              balance: balance,
                              icon: Icons.account_balance_wallet_outlined,
                              color: AppColors.purple,
                            ),
                          );
                    }
                    Navigator.pop(ctx);
                  }
                },
                child: Text(isEditing ? 'Save' : 'Add Account'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showTransferModal(BuildContext context, WidgetRef ref) {
    final wallets = ref.read(walletsProvider);
    if (wallets.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You need at least 2 accounts to transfer.')),
      );
      return;
    }

    String fromId = wallets.first.id;
    String toId = wallets.length > 1 ? wallets[1].id : wallets.first.id;
    final amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Transfer Between Accounts'),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('From Account', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: fromId,
                        isExpanded: true,
                        items: wallets.map((w) {
                          return DropdownMenuItem(
                            value: w.id,
                            child: Text('${w.name} (${CurrencyFormatter.format(w.balance)})'),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() => fromId = val);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('To Account', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: toId,
                        isExpanded: true,
                        items: wallets.map((w) {
                          return DropdownMenuItem(
                            value: w.id,
                            child: Text('${w.name} (${CurrencyFormatter.format(w.balance)})'),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() => toId = val);
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Transfer Amount (₹)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'e.g. 5000',
                      prefixText: '₹ ',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final amount = double.tryParse(amountController.text.trim());
                  if (fromId == toId) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sender and receiver account cannot be identical.')),
                    );
                    return;
                  }
                  if (amount != null && amount > 0) {
                    ref.read(walletsProvider.notifier).transfer(
                          fromWalletId: fromId,
                          toWalletId: toId,
                          amount: amount,
                        );
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('✓ Transferred ${CurrencyFormatter.format(amount)} successfully'),
                        backgroundColor: AppColors.textPrimary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                child: const Text('Transfer'),
              ),
            ],
          );
        },
      ),
    );
  }
}
