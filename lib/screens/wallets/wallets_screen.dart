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

  @override
  Widget build(BuildContext context) {
    final wallets = ref.watch(walletsProvider);
    final totalBalance = ref.watch(totalBalanceProvider);

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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _showTransferModal(context, ref),
                            icon: const Icon(Icons.swap_horiz_rounded, size: 18, color: AppColors.textPrimary),
                            label: const Text('Transfer Funds', style: TextStyle(fontWeight: FontWeight.w700)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton.icon(
                          onPressed: () => _showAddEditWalletDialog(context, ref),
                          icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
                          label: const Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Connected Accounts (${wallets.length})',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
              ),
              const SizedBox(height: 12),

              // Wallet Cards List
              Column(
                children: wallets.map((wallet) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: AppColors.cardBorder),
                      boxShadow: const [AppShadows.card],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: wallet.color.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(wallet.icon, color: wallet.color, size: 24),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    wallet.name,
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    wallet.accountNumber ?? wallet.type.name.toUpperCase(),
                                    style: const TextStyle(color: AppColors.textTertiary, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  CurrencyFormatter.format(wallet.balance),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: wallet.balance < 0 ? AppColors.danger : AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  wallet.balance < 0 ? 'Outstanding' : 'Available',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: wallet.balance < 0 ? AppColors.danger : AppColors.success,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Divider(height: 1, color: AppColors.cardBorder),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () => _showAddEditWalletDialog(context, ref, wallet: wallet),
                              icon: const Icon(Icons.edit_outlined, size: 16),
                              label: const Text('Edit', style: TextStyle(fontSize: 13)),
                              style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                ref.read(walletsProvider.notifier).deleteWallet(wallet.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Removed ${wallet.name}'),
                                    backgroundColor: AppColors.textPrimary,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.delete_outline, size: 16),
                              label: const Text('Delete', style: TextStyle(fontSize: 13)),
                              style: TextButton.styleFrom(foregroundColor: AppColors.danger),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddEditWalletDialog(BuildContext context, WidgetRef ref, {WalletModel? wallet}) {
    final isEdit = wallet != null;
    final nameController = TextEditingController(text: isEdit ? wallet.name : '');
    final balanceController = TextEditingController(text: isEdit ? wallet.balance.toStringAsFixed(0) : '');
    final accController = TextEditingController(text: isEdit ? wallet.accountNumber ?? '' : '');
    WalletType selectedType = isEdit ? wallet.type : WalletType.bank;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(isEdit ? 'Edit Account' : 'Add New Account', style: const TextStyle(fontWeight: FontWeight.w700)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Account Name', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(hintText: 'e.g. Axis Salary, ICICI Savings'),
                    ),
                    const SizedBox(height: 14),
                    const Text('Account Type', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<WalletType>(
                          value: selectedType,
                          isExpanded: true,
                          items: WalletType.values.map((t) {
                            return DropdownMenuItem(value: t, child: Text(t.name.toUpperCase()));
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => selectedType = val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text('Current Balance (₹)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: balanceController,
                      keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                      decoration: const InputDecoration(hintText: 'e.g. 50000 or -8500'),
                    ),
                    const SizedBox(height: 14),
                    const Text('Account / Card Mask (Optional)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: accController,
                      decoration: const InputDecoration(hintText: 'e.g. •••• 1234'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final balance = double.tryParse(balanceController.text.trim()) ?? 0;
                    if (name.isEmpty) return;

                    if (isEdit) {
                      ref.read(walletsProvider.notifier).editWallet(
                            wallet.copyWith(
                              name: name,
                              type: selectedType,
                              balance: balance,
                              accountNumber: accController.text.trim().isNotEmpty ? accController.text.trim() : null,
                            ),
                          );
                    } else {
                      final newWallet = WalletModel(
                        id: 'w_${DateTime.now().millisecondsSinceEpoch}',
                        name: name,
                        type: selectedType,
                        balance: balance,
                        accountNumber: accController.text.trim().isNotEmpty ? accController.text.trim() : null,
                        color: selectedType == WalletType.credit ? AppColors.danger : AppColors.info,
                        icon: selectedType == WalletType.credit ? Icons.credit_card : Icons.account_balance,
                      );
                      ref.read(walletsProvider.notifier).addWallet(newWallet);
                    }
                    Navigator.pop(ctx);
                  },
                  child: Text(isEdit ? 'Save Changes' : 'Add Account'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showTransferModal(BuildContext context, WidgetRef ref) {
    final wallets = ref.read(walletsProvider);
    if (wallets.length < 2) return;

    String fromId = wallets.first.id;
    String toId = wallets[1].id;
    final amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Transfer Between Accounts',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('From Account', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
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
                        items: wallets.map((w) => DropdownMenuItem(value: w.id, child: Text(w.name))).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => fromId = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('To Account', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
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
                        items: wallets.map((w) => DropdownMenuItem(value: w.id, child: Text(w.name))).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => toId = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Amount (₹)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'e.g. 5000'),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        final amt = double.tryParse(amountController.text.trim()) ?? 0;
                        if (amt <= 0) return;

                        final success = ref.read(walletsProvider.notifier).transfer(
                              fromWalletId: fromId,
                              toWalletId: toId,
                              amount: amt,
                            );

                        if (success) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('✓ Successfully transferred ${CurrencyFormatter.format(amt)}'),
                              backgroundColor: AppColors.textPrimary,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        }
                      },
                      child: const Text('Execute Transfer'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
