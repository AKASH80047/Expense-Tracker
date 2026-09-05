import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile_model.dart';

final userProfileProvider = NotifierProvider<UserProfileNotifier, UserProfileModel>(() {
  return UserProfileNotifier();
});

class UserProfileNotifier extends Notifier<UserProfileModel> {
  @override
  UserProfileModel build() {
    return const UserProfileModel(
      name: 'Akash Patel',
      email: 'akash.patel@example.com',
      phone: '+91 98765 43210',
      occupation: 'Senior Software Engineer',
      avatarUrl: '',
      avatarPath: null,
      avatarIndex: 1,
      isPremium: true,
      currency: '₹',
      monthlyIncomeGoal: 85000,
      creditScore: 785,
      memberSince: 'Jan 2026',
      biometricEnabled: true,
      notificationsEnabled: true,
      aiInsightsEnabled: true,
      twoFactorEnabled: false,
      budgetAlertsEnabled: true,
    );
  }

  void updateName(String name) => state = state.copyWith(name: name);
  void updateEmail(String email) => state = state.copyWith(email: email);
  void updatePhone(String phone) => state = state.copyWith(phone: phone);
  void updateOccupation(String occupation) => state = state.copyWith(occupation: occupation);
  
  void updateAvatarPath(String path) {
    state = state.copyWith(
      avatarPath: path,
      avatarIndex: 0, // 0 signifies custom image
    );
  }

  void clearAvatarPath() {
    state = state.copyWith(
      clearAvatarPath: true,
      avatarIndex: 1,
    );
  }

  void updateAvatarIndex(int index) {
    state = state.copyWith(
      avatarIndex: index,
      clearAvatarPath: true,
    );
  }

  void updateAvatarUrl(String url) => state = state.copyWith(avatarUrl: url);
  void updateCurrency(String currency) => state = state.copyWith(currency: currency);
  void updateMonthlyIncomeGoal(double goal) => state = state.copyWith(monthlyIncomeGoal: goal);
  void toggleBiometric(bool enabled) => state = state.copyWith(biometricEnabled: enabled);
  void toggleNotifications(bool enabled) => state = state.copyWith(notificationsEnabled: enabled);
  void toggleAiInsights(bool enabled) => state = state.copyWith(aiInsightsEnabled: enabled);
  void toggleTwoFactor(bool enabled) => state = state.copyWith(twoFactorEnabled: enabled);
  void toggleBudgetAlerts(bool enabled) => state = state.copyWith(budgetAlertsEnabled: enabled);
  void setPremium(bool isPremium) => state = state.copyWith(isPremium: isPremium);
}

