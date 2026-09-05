import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../providers/budget_provider.dart';
import '../../providers/bills_provider.dart';
import '../../providers/notifications_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/balance_card.dart';
import '../../widgets/budget_card.dart';
import '../../widgets/quick_actions.dart';
import '../../widgets/transaction_tile.dart';
import '../../widgets/bill_card.dart';
import '../../widgets/user_avatar.dart';
import '../notifications/notifications_screen.dart';
import '../bills/recurring_bills_screen.dart';
import '../budgets/budgets_screen.dart';
import '../wallets/wallets_screen.dart';
import '../receipt_scanner/receipt_scanner_screen.dart';
import '../add_transaction/add_transaction_screen.dart';

class HomeScreen extends ConsumerWidget {
  final Function(int) onNavigateTab;

  const HomeScreen({super.key, required this.onNavigateTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalBalance = ref.watch(totalBalanceProvider);
    final income = ref.watch(totalIncomeProvider);
    final expenses = ref.watch(totalExpensesProvider);
    final savings = ref.watch(totalSavingsProvider);
    final overallBudget = ref.watch(overallBudgetProvider);
    final upcomingBills = ref.watch(upcomingBillsProvider);
    final recentTransactions = ref.watch(transactionsProvider);
    final unreadCount = ref.watch(unreadNotificationsCountProvider);
    final user = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Greeting & Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good morning,',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '${user.name.split(" ").first} 👋',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        "Here's your financial overview",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Notification Icon with Badge '3'
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const NotificationsScreen(),
                                ),
                              );
                            },
                            child: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
                              ),
                              child: const Icon(
                                Icons.notifications_none_rounded,
                                size: 20,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Positioned(
                            top: -2,
                            right: -2,
                            child: Container(
                              width: 15,
                              height: 15,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEF4444),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                unreadCount > 0 ? '$unreadCount' : '3',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      // Profile Avatar
                      UserAvatar(
                        user: user,
                        size: 38,
                        onTap: () => onNavigateTab(4), // Navigate to Profile
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 2. Main Balance Card
              BalanceCard(
                totalBalance: totalBalance,
                income: income,
                expenses: expenses,
                savings: savings,
              ),
              const SizedBox(height: 10),

              // 3. Monthly Budget Card
              MonthlyBudgetCard(
                spent: overallBudget.totalSpent,
                limit: overallBudget.totalLimit,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BudgetsScreen()),
                  );
                },
              ),
              const SizedBox(height: 14),

              // 4. Quick Actions Section
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              QuickActions(
                onAddExpense: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddTransactionScreen(initialIsExpense: true),
                    ),
                  );
                },
                onAddIncome: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddTransactionScreen(initialIsExpense: false),
                    ),
                  );
                },
                onTransfer: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WalletsScreen(initialShowTransfer: true)),
                  );
                },
                onScanReceipt: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReceiptScannerScreen()),
                  );
                },
              ),
              const SizedBox(height: 14),

              // 5. Upcoming Bills Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Upcoming Bills',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RecurringBillsScreen()),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'See All',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 11.5,
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 116,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: upcomingBills.length,
                  itemBuilder: (context, index) {
                    final bill = upcomingBills[index];
                    return BillCard(
                      bill: bill,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RecurringBillsScreen()),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),

              // 6. Recent Transactions Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onNavigateTab(1); // Navigate to Transactions tab
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'See All',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                            fontSize: 11.5,
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (recentTransactions.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: const Text('No transactions yet'),
                )
              else
                Column(
                  children: recentTransactions.take(3).map((tx) {
                    return TransactionTile(
                      transaction: tx,
                      onDelete: () {
                        ref.read(transactionsProvider.notifier).deleteTransaction(tx.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Deleted "${tx.title}"'),
                            backgroundColor: AppColors.textPrimary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
