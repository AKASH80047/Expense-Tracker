import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/user_provider.dart';
import '../../providers/notifications_provider.dart';
import '../../widgets/user_avatar.dart';
import 'home/home_screen.dart';
import 'transactions/transactions_screen.dart';
import 'analytics/analytics_screen.dart';
import 'budgets/budgets_screen.dart';
import 'goals/savings_goals_screen.dart';
import 'bills/recurring_bills_screen.dart';
import 'wallets/wallets_screen.dart';
import 'ai_assistant/ai_assistant_screen.dart';
import 'profile/profile_screen.dart';
import 'notifications/notifications_screen.dart';
import 'add_transaction/add_transaction_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    if (index == 2 && MediaQuery.of(context).size.width < 900) {
      // Mobile center add button
      _openAddTransaction();
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _openAddTransaction() {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
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
              child: const AddTransactionScreen(),
            ),
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const AddTransactionScreen(),
          fullscreenDialog: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider);
    final unreadCount = ref.watch(unreadNotificationsCountProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;

    final List<Widget> mobileScreens = [
      HomeScreen(onNavigateTab: _onTabTapped),
      const TransactionsScreen(),
      const SizedBox.shrink(), // Placeholder for center add button
      const AnalyticsScreen(),
      const ProfileScreen(),
    ];

    final List<Widget> desktopScreens = [
      HomeScreen(onNavigateTab: _onTabTapped),
      const TransactionsScreen(),
      const AnalyticsScreen(),
      const BudgetsScreen(),
      const SavingsGoalsScreen(),
      const RecurringBillsScreen(),
      const WalletsScreen(),
      const AIAssistantScreen(),
      const ProfileScreen(),
    ];

    if (isDesktop) {
      // Desktop / Web Layout with Sidebar
      final safeDesktopIndex = _currentIndex.clamp(0, desktopScreens.length - 1);

      return Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: Row(
          children: [
            // Left Sidebar
            Container(
              width: 270,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  right: BorderSide(color: Colors.grey.shade200, width: 1.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(2, 0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo & Brand Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD83D), Color(0xFFF59E0B)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFF59E0B).withOpacity(0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet_rounded,
                            color: AppColors.textPrimary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'ExpenseTracker',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.3,
                              ),
                            ),
                            Text(
                              'Pro Finance Hub',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Quick Action Button in Sidebar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _openAddTransaction,
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD83D), Color(0xFFF59E0B)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFF59E0B).withOpacity(0.25),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add_rounded, color: AppColors.textPrimary, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Add Transaction',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: Text(
                      'MAIN MENU',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textTertiary,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),

                  // Sidebar Menu Items
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                        _buildSidebarItem(
                          index: 0,
                          icon: Icons.dashboard_rounded,
                          title: 'Dashboard',
                        ),
                        _buildSidebarItem(
                          index: 1,
                          icon: Icons.swap_horiz_rounded,
                          title: 'Transactions',
                        ),
                        _buildSidebarItem(
                          index: 2,
                          icon: Icons.analytics_rounded,
                          title: 'Analytics & Trends',
                        ),
                        _buildSidebarItem(
                          index: 3,
                          icon: Icons.pie_chart_rounded,
                          title: 'Budgets',
                        ),
                        _buildSidebarItem(
                          index: 4,
                          icon: Icons.track_changes_rounded,
                          title: 'Savings Goals',
                        ),
                        _buildSidebarItem(
                          index: 5,
                          icon: Icons.receipt_long_rounded,
                          title: 'Recurring Bills',
                        ),
                        _buildSidebarItem(
                          index: 6,
                          icon: Icons.account_balance_rounded,
                          title: 'Wallets & Accounts',
                        ),
                        _buildSidebarItem(
                          index: 7,
                          icon: Icons.auto_awesome_rounded,
                          title: 'AI Assistant',
                        ),
                        _buildSidebarItem(
                          index: 8,
                          icon: Icons.person_rounded,
                          title: 'Profile & Settings',
                        ),
                      ],
                    ),
                  ),

                  // Bottom User Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        UserAvatar(
                          user: user,
                          size: 38,
                          onTap: () => setState(() => _currentIndex = 8),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                user.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                user.email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.notifications_none_rounded, size: 20),
                          tooltip: 'Notifications',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Right Main Content Area
            Expanded(
              child: Container(
                color: const Color(0xFFF8FAFC),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1320),
                    child: IndexedStack(
                      index: safeDesktopIndex,
                      children: desktopScreens,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Mobile Layout with Bottom Navigation Bar
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex == 2 ? 0 : _currentIndex,
        children: mobileScreens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        padding: const EdgeInsets.only(top: 6, bottom: 8),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                icon: Icons.home,
                unselectedIcon: Icons.home_outlined,
                label: 'Home',
              ),
              _buildNavItem(
                index: 1,
                icon: Icons.swap_horiz_rounded,
                unselectedIcon: Icons.swap_horiz_rounded,
                label: 'Transactions',
              ),
              // Center Add Button
              GestureDetector(
                onTap: () => _onTabTapped(2),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD83D),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.textPrimary,
                    size: 26,
                  ),
                ),
              ),
              _buildNavItem(
                index: 3,
                icon: Icons.bar_chart_rounded,
                unselectedIcon: Icons.bar_chart_rounded,
                label: 'Analytics',
              ),
              _buildNavItem(
                index: 4,
                icon: Icons.person_outline_rounded,
                unselectedIcon: Icons.person_outline_rounded,
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarItem({
    required int index,
    required IconData icon,
    required String title,
  }) {
    final isSelected = _currentIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => setState(() => _currentIndex = index),
          borderRadius: BorderRadius.circular(12),
          hoverColor: const Color(0xFFFFFBEB),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFEF3C7) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? const Color(0xFFD97706) : Colors.grey.shade600,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? const Color(0xFFB45309) : const Color(0xFF334155),
                  ),
                ),
                if (isSelected) ...[
                  const Spacer(),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFFD97706),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData unselectedIcon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;
    const activeColor = Color(0xFFF59E0B);
    final inactiveColor = Colors.grey.shade500;

    return InkWell(
      onTap: () => _onTabTapped(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? icon : unselectedIcon,
              color: isSelected ? activeColor : inactiveColor,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? activeColor : inactiveColor,
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
