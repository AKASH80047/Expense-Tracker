class UserProfileModel {
  final String name;
  final String email;
  final String phone;
  final String occupation;
  final String avatarUrl;
  final String? avatarPath; // Local image path picked from camera/gallery
  final int avatarIndex; // 0: Custom image, 1..12: Presets, -1: Initials
  final bool isPremium;
  final String currency;
  final double monthlyIncomeGoal;
  final int creditScore;
  final String memberSince;
  final bool biometricEnabled;
  final bool notificationsEnabled;
  final bool aiInsightsEnabled;
  final bool twoFactorEnabled;
  final bool budgetAlertsEnabled;

  const UserProfileModel({
    required this.name,
    required this.email,
    this.phone = '+91 98765 43210',
    this.occupation = 'Senior Software Engineer',
    required this.avatarUrl,
    this.avatarPath,
    this.avatarIndex = 1,
    this.isPremium = true,
    this.currency = '₹',
    this.monthlyIncomeGoal = 85000,
    this.creditScore = 785,
    this.memberSince = 'Jan 2026',
    this.biometricEnabled = true,
    this.notificationsEnabled = true,
    this.aiInsightsEnabled = true,
    this.twoFactorEnabled = false,
    this.budgetAlertsEnabled = true,
  });

  UserProfileModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? occupation,
    String? avatarUrl,
    String? avatarPath,
    int? avatarIndex,
    bool? isPremium,
    String? currency,
    double? monthlyIncomeGoal,
    int? creditScore,
    String? memberSince,
    bool? biometricEnabled,
    bool? notificationsEnabled,
    bool? aiInsightsEnabled,
    bool? twoFactorEnabled,
    bool? budgetAlertsEnabled,
    bool clearAvatarPath = false,
  }) {
    return UserProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      occupation: occupation ?? this.occupation,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarPath: clearAvatarPath ? null : (avatarPath ?? this.avatarPath),
      avatarIndex: avatarIndex ?? this.avatarIndex,
      isPremium: isPremium ?? this.isPremium,
      currency: currency ?? this.currency,
      monthlyIncomeGoal: monthlyIncomeGoal ?? this.monthlyIncomeGoal,
      creditScore: creditScore ?? this.creditScore,
      memberSince: memberSince ?? this.memberSince,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      aiInsightsEnabled: aiInsightsEnabled ?? this.aiInsightsEnabled,
      twoFactorEnabled: twoFactorEnabled ?? this.twoFactorEnabled,
      budgetAlertsEnabled: budgetAlertsEnabled ?? this.budgetAlertsEnabled,
    );
  }
}

