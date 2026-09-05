import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'home/home_screen.dart';
import 'transactions/transactions_screen.dart';
import 'analytics/analytics_screen.dart';
import 'profile/profile_screen.dart';
import 'add_transaction/add_transaction_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    if (index == 2) {
      // Open Add Transaction modal / screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const AddTransactionScreen(),
          fullscreenDialog: true,
        ),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 0: Home, 1: Transactions, 2: (Add), 3: Analytics, 4: Profile
    final List<Widget> screens = [
      HomeScreen(onNavigateTab: _onTabTapped),
      const TransactionsScreen(),
      const SizedBox.shrink(), // Placeholder for center add button
      const AnalyticsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex == 2 ? 0 : _currentIndex,
        children: screens,
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
