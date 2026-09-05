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
import '../../widgets/ai_insight_card.dart';
import '../notifications/notifications_screen.dart';
import '../bills/recurring_bills_screen.dart';
import '../budgets/budgets_screen.dart';
import '../wallets/wallets_screen.dart';
import '../receipt_scanner/receipt_scanner_screen.dart';
import '../add_transaction/add_transaction_screen.dart';
import '../ai_assistant/ai_assistant_screen.dart';

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

    final isDesktop = MediaQuery.of(context).size.width >= 900;

    void openAddTransaction({bool isExpense = true}) {
      if (isDesktop) {
        showDialog(
          context: context,
          builder: (_) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 540, maxHeight: 720),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: AddTransactionScreen(initialIsExpense: isExpense),
              ),
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddTransactionScreen(initialIsExpense: isExpense),
            fullscreenDialog: true,
          ),
        );
      }
    }

    // Top Header Widget
    Widget buildHeader() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Good day,',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${user.name.split(" ").first} 👋',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                "Here's your real-time financial overview",
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          if (!isDesktop)
            Row(
              children: [
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
                        width: 40,
                        height: 40,
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
                        width: 16,
                        height: 16,
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
                const SizedBox(width: 10),
                UserAvatar(
                  user: user,
                  size: 40,
                  onTap: () => onNavigateTab(4),
                ),
              ],
            ),
        ],
      );
    }

    // Recent Transactions Widget
    Widget buildTransactionsSection() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => onNavigateTab(1),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'See All',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                      ),
                    ),
                    SizedBox(width: 3),
                    Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (recentTransactions.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const Text('No transactions recorded yet.'),
            )
          else
            Column(
              children: recentTransactions.take(isDesktop ? 5 : 3).map((tx) {
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
        ],
      );
    }

    // Upcoming Bills Widget
    Widget buildUpcomingBillsSection() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Upcoming Bills',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
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
                        fontWeight: FontWeight.w600,
                        fontSize: 12.5,
                      ),
                    ),
                    SizedBox(width: 3),
                    Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 120,
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
        ],
      );
    }

    // Quick Actions Widget
    Widget buildQuickActions() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          QuickActions(
            onAddExpense: () => openAddTransaction(isExpense: true),
            onAddIncome: () => openAddTransaction(isExpense: false),
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
        ],
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: isDesktop ? 32 : 16,
            vertical: isDesktop ? 24 : 12,
          ),
          child: isDesktop
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHeader(),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column (Primary Cards & Actions)
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BalanceCard(
                                totalBalance: totalBalance,
                                income: income,
                                expenses: expenses,
                                savings: savings,
                              ),
                              const SizedBox(height: 20),
                              buildQuickActions(),
                              const SizedBox(height: 24),
                              buildTransactionsSection(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Right Column (Budgets, AI & Bills)
                        Expanded(
                          flex: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AIInsightCard(
                                onViewAnalysis: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const AIAssistantScreen()),
                                  );
                                },
                              ),
                              const SizedBox(height: 20),
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
                              const SizedBox(height: 20),
                              buildUpcomingBillsSection(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHeader(),
                    const SizedBox(height: 14),
                    BalanceCard(
                      totalBalance: totalBalance,
                      income: income,
                      expenses: expenses,
                      savings: savings,
                    ),
                    const SizedBox(height: 12),
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
                    buildQuickActions(),
                    const SizedBox(height: 16),
                    buildUpcomingBillsSection(),
                    const SizedBox(height: 16),
                    buildTransactionsSection(),
                    const SizedBox(height: 20),
                  ],
                ),
        ),
      ),
    );
  }
}
