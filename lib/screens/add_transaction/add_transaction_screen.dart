import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/categories.dart';
import '../../core/utils/currency_formatter.dart';
import '../../models/transaction_model.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/wallet_provider.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final bool initialIsExpense;

  const AddTransactionScreen({
    super.key,
    this.initialIsExpense = true,
  });

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  late bool _isExpense;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  CategoryItem? _selectedCategory;
  String _selectedWalletId = 'w_cash';
  DateTime _selectedDate = DateTime(2026, 9, 5);

  @override
  void initState() {
    super.initState();
    _isExpense = widget.initialIsExpense;
    _selectedCategory = _isExpense
        ? AppCategories.expenseCategories.first
        : AppCategories.incomeCategories.first;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onSave() {
    final amountText = _amountController.text.trim().replaceAll(',', '');
    final amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a valid amount'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final wallets = ref.read(walletsProvider);
    final selectedWallet = wallets.firstWhere(
      (w) => w.id == _selectedWalletId,
      orElse: () => wallets.first,
    );

    final title = _selectedCategory!.name;

    final newTx = TransactionModel(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      category: _selectedCategory!.name,
      amount: amount,
      type: _isExpense ? TransactionType.expense : TransactionType.income,
      walletId: selectedWallet.id,
      walletName: selectedWallet.name,
      date: _selectedDate,
      notes: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : null,
    );

    ref.read(transactionsProvider.notifier).addTransaction(newTx);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text('✓ ${_isExpense ? "Expense" : "Income"} saved successfully'),
          ],
        ),
        backgroundColor: AppColors.textPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    Navigator.pop(context);
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryDark,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final wallets = ref.watch(walletsProvider);
    final categories = _isExpense
        ? AppCategories.expenseCategories
        : AppCategories.incomeCategories;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Transaction',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Expense | Income Toggle
                    Container(
                      height: 48,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isExpense = true;
                                  _selectedCategory = AppCategories.expenseCategories.first;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: _isExpense ? const Color(0xFFFFD83D) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Expense',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: _isExpense ? FontWeight.w700 : FontWeight.w500,
                                    fontSize: 14.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isExpense = false;
                                  _selectedCategory = AppCategories.incomeCategories.first;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                decoration: BoxDecoration(
                                  color: !_isExpense ? const Color(0xFFFFD83D) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Income',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: !_isExpense ? FontWeight.w700 : FontWeight.w500,
                                    fontSize: 14.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 2. Large Amount Center Display
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '₹ ',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w800,
                              fontSize: 42,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          IntrinsicWidth(
                            child: TextField(
                              controller: _amountController,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              autofocus: false,
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w800,
                                fontSize: 42,
                                color: AppColors.textPrimary,
                              ),
                              decoration: InputDecoration(
                                hintText: '0',
                                hintStyle: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 42,
                                  color: const Color(0xFFC4C4C4),
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                filled: false,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (val) {
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 3. Select Category Section
                    const Text(
                      'Select Category',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 4x3 Grid of Categories
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isSelected = _selectedCategory?.id == cat.id;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = cat;
                            });
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFFFFD83D) : const Color(0xFFF9F9F9),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFFFFD83D) : const Color(0xFFE5E7EB),
                                    width: 1.2,
                                  ),
                                ),
                                child: Icon(
                                  cat.icon,
                                  size: 22,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                cat.name,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  fontSize: 11.5,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // 4. Form Fields in Rounded Cards
                    // Row A: Amount
                    _buildFormFieldRow(
                      iconWidget: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFD1D5DB)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text('₹', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                      ),
                      label: 'Amount',
                      child: TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          hintText: 'Enter amount',
                          filled: false,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Row B: Wallet
                    _buildFormFieldRow(
                      iconWidget: const Icon(Icons.account_balance_wallet_outlined, size: 20, color: AppColors.textPrimary),
                      label: 'Wallet',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedWalletId,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textPrimary),
                          items: wallets.map((wallet) {
                            return DropdownMenuItem<String>(
                              value: wallet.id,
                              child: Row(
                                children: [
                                  Icon(wallet.icon, size: 18, color: wallet.color),
                                  const SizedBox(width: 8),
                                  Text(
                                    wallet.name,
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedWalletId = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Row C: Date
                    _buildFormFieldRow(
                      iconWidget: const Icon(Icons.calendar_today_outlined, size: 19, color: AppColors.textPrimary),
                      label: 'Date',
                      child: InkWell(
                        onTap: _selectDate,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.event_note, size: 16, color: AppColors.textSecondary),
                                const SizedBox(width: 6),
                                Text(
                                  CurrencyFormatter.formatDate(_selectedDate),
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                ),
                              ],
                            ),
                            const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textPrimary),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Row D: Notes (Optional)
                    _buildFormFieldRow(
                      iconWidget: const Icon(Icons.edit_note_outlined, size: 22, color: AppColors.textPrimary),
                      label: 'Notes\n(Optional)',
                      child: TextField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          hintText: 'Enter a note...',
                          filled: false,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom Buttons: Cancel & Save Transaction
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey.shade300, width: 1.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _onSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD83D),
                        foregroundColor: AppColors.textPrimary,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Save Transaction',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFieldRow({
    required Widget iconWidget,
    required String label,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 28,
            alignment: Alignment.centerLeft,
            child: iconWidget,
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 75,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
                height: 1.2,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: child),
        ],
      ),
    );
  }
}
