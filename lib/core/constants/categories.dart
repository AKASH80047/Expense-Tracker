import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CategoryItem {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final bool isExpense;

  const CategoryItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    this.isExpense = true,
  });
}

class AppCategories {
  static const List<CategoryItem> expenseCategories = [
    CategoryItem(
      id: 'food',
      name: 'Food',
      icon: Icons.restaurant_outlined,
      color: AppColors.warning,
      backgroundColor: Color(0xFFFFF4D4),
    ),
    CategoryItem(
      id: 'shopping',
      name: 'Shopping',
      icon: Icons.shopping_cart_outlined,
      color: AppColors.orange,
      backgroundColor: Color(0xFFFFE8DF),
    ),
    CategoryItem(
      id: 'transportation',
      name: 'Transportation',
      icon: Icons.directions_car_outlined,
      color: AppColors.info,
      backgroundColor: Color(0xFFE1F0FF),
    ),
    CategoryItem(
      id: 'entertainment',
      name: 'Entertainment',
      icon: Icons.music_note_outlined,
      color: AppColors.purple,
      backgroundColor: Color(0xFFEFEAFF),
    ),
    CategoryItem(
      id: 'bills',
      name: 'Bills',
      icon: Icons.description_outlined,
      color: AppColors.danger,
      backgroundColor: Color(0xFFFFE5E9),
    ),
    CategoryItem(
      id: 'health',
      name: 'Health',
      icon: Icons.favorite_border_rounded,
      color: AppColors.green,
      backgroundColor: Color(0xFFE2F8EE),
    ),
    CategoryItem(
      id: 'education',
      name: 'Education',
      icon: Icons.school_outlined,
      color: AppColors.indigo,
      backgroundColor: Color(0xFFECE8FD),
    ),
    CategoryItem(
      id: 'travel',
      name: 'Travel',
      icon: Icons.flight_outlined,
      color: AppColors.teal,
      backgroundColor: Color(0xFFE0F7FA),
    ),
    CategoryItem(
      id: 'home',
      name: 'Home',
      icon: Icons.home_outlined,
      color: AppColors.blue,
      backgroundColor: Color(0xFFE3EDFF),
    ),
    CategoryItem(
      id: 'pet',
      name: 'Pet',
      icon: Icons.pets_outlined,
      color: AppColors.orange,
      backgroundColor: Color(0xFFFFECE4),
    ),
    CategoryItem(
      id: 'gift',
      name: 'Gift',
      icon: Icons.card_giftcard_outlined,
      color: AppColors.pink,
      backgroundColor: Color(0xFFFFEAE6),
    ),
    CategoryItem(
      id: 'other',
      name: 'Other',
      icon: Icons.more_horiz_rounded,
      color: AppColors.textSecondary,
      backgroundColor: Color(0xFFEEEEEE),
    ),
  ];

  static const List<CategoryItem> incomeCategories = [
    CategoryItem(
      id: 'salary',
      name: 'Salary',
      icon: Icons.account_balance_wallet_outlined,
      color: AppColors.success,
      backgroundColor: Color(0xFFE2F8EE),
      isExpense: false,
    ),
    CategoryItem(
      id: 'freelance',
      name: 'Freelance & Bonus',
      icon: Icons.laptop_mac_outlined,
      color: AppColors.info,
      backgroundColor: Color(0xFFE1F0FF),
      isExpense: false,
    ),
    CategoryItem(
      id: 'investments',
      name: 'Investments',
      icon: Icons.trending_up_rounded,
      color: AppColors.purple,
      backgroundColor: Color(0xFFEFEAFF),
      isExpense: false,
    ),
    CategoryItem(
      id: 'rental',
      name: 'Rental Income',
      icon: Icons.house_outlined,
      color: AppColors.orange,
      backgroundColor: Color(0xFFFFE8DF),
      isExpense: false,
    ),
    CategoryItem(
      id: 'other_income',
      name: 'Other Income',
      icon: Icons.attach_money_rounded,
      color: AppColors.teal,
      backgroundColor: Color(0xFFE0F7FA),
      isExpense: false,
    ),
  ];

  static CategoryItem getCategoryByName(String name, {bool isExpense = true}) {
    final list = isExpense ? expenseCategories : incomeCategories;
    return list.firstWhere(
      (c) => c.name.toLowerCase() == name.toLowerCase() || c.id.toLowerCase() == name.toLowerCase(),
      orElse: () => isExpense ? expenseCategories.last : incomeCategories.last,
    );
  }
}
