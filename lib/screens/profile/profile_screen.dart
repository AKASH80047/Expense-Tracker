import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/app_theme.dart';
import '../../models/user_profile_model.dart';
import '../../providers/user_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../providers/budget_provider.dart';
import '../../providers/goals_provider.dart';
import '../../widgets/user_avatar.dart';
import '../wallets/wallets_screen.dart';
import '../budgets/budgets_screen.dart';
import '../goals/savings_goals_screen.dart';
import '../bills/recurring_bills_screen.dart';
import '../ai_assistant/ai_assistant_screen.dart';
import '../receipt_scanner/receipt_scanner_screen.dart';
import '../security/security_screen.dart';
import '../reports/reports_screen.dart';
import '../premium/premium_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null && mounted) {
        ref.read(userProfileProvider.notifier).updateAvatarPath(pickedFile.path);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Color(0xFFFFD83D), size: 20),
                SizedBox(width: 8),
                Text('Profile photo updated successfully!'),
              ],
            ),
            backgroundColor: const Color(0xFF171717),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not access image: $e'),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProfileProvider);
    final wallets = ref.watch(walletsProvider);
    final budgets = ref.watch(budgetsProvider);
    final goals = ref.watch(savingsGoalsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Profile & Settings',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 18,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.edit_rounded, size: 18, color: AppColors.textPrimary),
            ),
            tooltip: 'Edit Profile Info',
            onPressed: () => _showEditProfileDialog(context, ref, user),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. VIP Profile Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.white, Color(0xFFFCFDFE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFF1F2F4), width: 1.2),
                  boxShadow: const [AppShadows.card],
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Interactive User Avatar with Camera Badge
                        UserAvatar(
                          user: user,
                          size: 72,
                          showBadge: true,
                          onTap: () => _showAvatarPickerSheet(context, ref, user),
                        ),
                        const SizedBox(width: 16),
                        // Name, Occupation, Pro Badge, and Email
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      user.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 18,
                                        color: AppColors.textPrimary,
                                        letterSpacing: -0.3,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFD83D),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'PRO',
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 9.5,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                user.occupation,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  const Icon(Icons.mail_outline_rounded, size: 12, color: AppColors.textTertiary),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      user.email,
                                      style: const TextStyle(
                                        color: AppColors.textTertiary,
                                        fontSize: 11.5,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Member Since & Status Row
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF9C3).withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFEF08A)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.verified_user_rounded, size: 15, color: Color(0xFFCA8A04)),
                          const SizedBox(width: 6),
                          Text(
                            'Lifetime Pro Plan • Member since ${user.memberSince}',
                            style: const TextStyle(
                              color: Color(0xFF854D0E),
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            'Active ✓',
                            style: TextStyle(
                              color: Color(0xFF16A34A),
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Quick Financial Stats Row (4-columns)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFF1F2F4)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildProfileStat(
                              title: 'Wallets',
                              value: '${wallets.length}',
                              icon: Icons.account_balance_wallet_outlined,
                              color: const Color(0xFF2563EB),
                            ),
                          ),
                          Container(width: 1, height: 26, color: const Color(0xFFE5E7EB)),
                          Expanded(
                            child: _buildProfileStat(
                              title: 'Budgets',
                              value: '${budgets.length}',
                              icon: Icons.pie_chart_outline_rounded,
                              color: const Color(0xFFF59E0B),
                            ),
                          ),
                          Container(width: 1, height: 26, color: const Color(0xFFE5E7EB)),
                          Expanded(
                            child: _buildProfileStat(
                              title: 'Goals',
                              value: '${goals.length}',
                              icon: Icons.flag_outlined,
                              color: const Color(0xFF16A34A),
                            ),
                          ),
                          Container(width: 1, height: 26, color: const Color(0xFFE5E7EB)),
                          Expanded(
                            child: _buildProfileStat(
                              title: 'Score',
                              value: '${user.creditScore}',
                              icon: Icons.speed_rounded,
                              color: const Color(0xFF7C3AED),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // 2. Personal & Account Details
              _buildSectionTitle('Personal & Account'),
              const SizedBox(height: 8),
              _buildSettingsGroup([
                _buildSettingsTile(
                  icon: Icons.person_pin_rounded,
                  iconColor: const Color(0xFF2563EB),
                  title: 'Edit Profile Information',
                  subtitle: 'Change name, occupation, email & phone',
                  onTap: () => _showEditProfileDialog(context, ref, user),
                ),
                _buildSettingsTile(
                  icon: Icons.image_rounded,
                  iconColor: const Color(0xFFD97706),
                  title: 'Change Avatar / Profile Picture',
                  subtitle: user.avatarPath != null ? 'Custom photo from device' : 'Preset avatar selected',
                  trailingText: 'Change',
                  onTap: () => _showAvatarPickerSheet(context, ref, user),
                ),
                _buildSettingsTile(
                  icon: Icons.badge_outlined,
                  iconColor: const Color(0xFF0D9488),
                  title: 'KYC & Verification',
                  subtitle: 'Identity verified & tax compliance',
                  trailingWidget: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Verified ✓',
                      style: TextStyle(color: Color(0xFF16A34A), fontWeight: FontWeight.w800, fontSize: 11),
                    ),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✓ Your KYC is 100% verified with bank-grade security')),
                    );
                  },
                ),
              ]),
              const SizedBox(height: 18),

              // 3. Financial Hub & Management
              _buildSectionTitle('Financial Management'),
              const SizedBox(height: 8),
              _buildSettingsGroup([
                _buildSettingsTile(
                  icon: Icons.account_balance_wallet_outlined,
                  iconColor: const Color(0xFF2563EB),
                  title: 'Accounts & Wallets',
                  subtitle: 'Manage bank accounts, debit cards & cash',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletsScreen())),
                ),
                _buildSettingsTile(
                  icon: Icons.pie_chart_outline_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  title: 'Budgets & Limits',
                  subtitle: 'Set monthly category thresholds & controls',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BudgetsScreen())),
                ),
                _buildSettingsTile(
                  icon: Icons.flag_outlined,
                  iconColor: const Color(0xFF16A34A),
                  title: 'Savings Goals',
                  subtitle: 'Emergency fund, vacation & targets',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SavingsGoalsScreen())),
                ),
                _buildSettingsTile(
                  icon: Icons.receipt_long_outlined,
                  iconColor: const Color(0xFFEA580C),
                  title: 'Recurring Bills & Subscriptions',
                  subtitle: 'Electricity, internet, Netflix & utilities',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RecurringBillsScreen())),
                ),
              ]),
              const SizedBox(height: 18),

              // 4. AI & Smart Financial Tools
              _buildSectionTitle('AI & Productivity Suite'),
              const SizedBox(height: 8),
              _buildSettingsGroup([
                _buildSettingsTile(
                  icon: Icons.auto_awesome_rounded,
                  iconColor: const Color(0xFF7C3AED),
                  title: 'AI Financial Assistant',
                  subtitle: 'Chat co-pilot & smart saving tips',
                  trailingWidget: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE9FE),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text('AI 2.0', style: TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.w800, fontSize: 10)),
                  ),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AIAssistantScreen())),
                ),
                _buildSettingsTile(
                  icon: Icons.document_scanner_outlined,
                  iconColor: const Color(0xFFD97706),
                  title: 'Receipt Scanner (Smart OCR)',
                  subtitle: 'Scan physical bills and extract auto-data',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReceiptScannerScreen())),
                ),
                _buildSettingsTile(
                  icon: Icons.insert_chart_outlined_rounded,
                  iconColor: const Color(0xFF0D9488),
                  title: 'Financial Statements & Reports',
                  subtitle: 'Export statements in PDF & CSV format',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsScreen())),
                ),
                _buildSwitchTile(
                  icon: Icons.insights_rounded,
                  iconColor: const Color(0xFF8B5CF6),
                  title: 'Smart AI Recommendations',
                  subtitle: 'Show proactive spending optimization tips',
                  value: user.aiInsightsEnabled,
                  onChanged: (val) {
                    ref.read(userProfileProvider.notifier).toggleAiInsights(val);
                  },
                ),
              ]),
              const SizedBox(height: 18),

              // 5. Security & Privacy Center
              _buildSectionTitle('Security & Privacy'),
              const SizedBox(height: 8),
              _buildSettingsGroup([
                _buildSwitchTile(
                  icon: Icons.fingerprint_rounded,
                  iconColor: const Color(0xFF2563EB),
                  title: 'Biometric / Face ID Lock',
                  subtitle: 'Unlock app securely using fingerprint or Face ID',
                  value: user.biometricEnabled,
                  onChanged: (val) {
                    ref.read(userProfileProvider.notifier).toggleBiometric(val);
                  },
                ),
                _buildSwitchTile(
                  icon: Icons.shield_outlined,
                  iconColor: const Color(0xFF16A34A),
                  title: 'Two-Factor Authentication (2FA)',
                  subtitle: 'Extra security verification on login',
                  value: user.twoFactorEnabled,
                  onChanged: (val) {
                    ref.read(userProfileProvider.notifier).toggleTwoFactor(val);
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.lock_outline_rounded,
                  iconColor: const Color(0xFFEF4444),
                  title: 'Security Center & App PIN',
                  subtitle: 'Change PIN, backup recovery key & audit log',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SecurityScreen())),
                ),
              ]),
              const SizedBox(height: 18),

              // 6. Preferences & Regional Settings
              _buildSectionTitle('Preferences & System'),
              const SizedBox(height: 8),
              _buildSettingsGroup([
                _buildSettingsTile(
                  icon: Icons.currency_rupee_rounded,
                  iconColor: const Color(0xFF16A34A),
                  title: 'Default Currency',
                  subtitle: 'Selected: ${user.currency} (Indian Rupee)',
                  trailingText: user.currency,
                  onTap: () => _showCurrencyPicker(context, ref, user.currency),
                ),
                _buildSwitchTile(
                  icon: Icons.notifications_active_outlined,
                  iconColor: const Color(0xFFEA580C),
                  title: 'Smart Notifications',
                  subtitle: 'Daily morning review & upcoming bill reminders',
                  value: user.notificationsEnabled,
                  onChanged: (val) {
                    ref.read(userProfileProvider.notifier).toggleNotifications(val);
                  },
                ),
                _buildSwitchTile(
                  icon: Icons.warning_amber_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  title: 'Budget Overrun Alerts',
                  subtitle: 'Notify when category spending exceeds 85%',
                  value: user.budgetAlertsEnabled,
                  onChanged: (val) {
                    ref.read(userProfileProvider.notifier).toggleBudgetAlerts(val);
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.workspace_premium_outlined,
                  iconColor: const Color(0xFFF59E0B),
                  title: 'Premium Membership',
                  subtitle: 'Active Lifetime VIP Plan',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PremiumScreen())),
                ),
              ]),
              const SizedBox(height: 18),

              // 7. Data, Cloud Sync & Backups
              _buildSectionTitle('Data & Storage'),
              const SizedBox(height: 8),
              _buildSettingsGroup([
                _buildSettingsTile(
                  icon: Icons.cloud_sync_outlined,
                  iconColor: const Color(0xFF2563EB),
                  title: 'Cloud Auto-Backup',
                  subtitle: 'Last synced today at 11:30 AM',
                  trailingText: 'Synced',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✓ Encrypted backup created successfully!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.file_download_outlined,
                  iconColor: const Color(0xFF0D9488),
                  title: 'Export Financial Data (CSV / JSON)',
                  subtitle: 'Download complete transaction history',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsScreen())),
                ),
              ]),
              const SizedBox(height: 18),

              // 8. App Info & Danger Zone
              _buildSectionTitle('App Info & Account'),
              const SizedBox(height: 8),
              _buildSettingsGroup([
                _buildSettingsTile(
                  icon: Icons.info_outline_rounded,
                  iconColor: AppColors.textSecondary,
                  title: 'About AI Finance Manager',
                  subtitle: 'Version 2.4.0 (Build 2026)',
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'AI Finance Manager',
                      applicationVersion: 'v2.4.0',
                      applicationLegalese: '© 2026 AI Personal Finance. All rights reserved.\nEngineered with Flutter & Riverpod.',
                    );
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.logout_rounded,
                  iconColor: const Color(0xFFEF4444),
                  title: 'Log Out',
                  subtitle: 'Safely sign out from this device',
                  isDestructive: true,
                  onTap: () => _showLogoutDialog(context),
                ),
              ]),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 2),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 11.5,
          color: AppColors.textTertiary,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildProfileStat({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14.5,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F2F4), width: 1.2),
        boxShadow: const [AppShadows.card],
      ),
      child: Column(
        children: List.generate(children.length, (index) {
          final isLast = index == children.length - 1;
          return Column(
            children: [
              children[index],
              if (!isLast)
                const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6), indent: 56, endIndent: 16),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    String? trailingText,
    Widget? trailingWidget,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                      color: isDestructive ? const Color(0xFFEF4444) : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5),
                  ),
                ],
              ),
            ),
            if (trailingWidget != null) ...[
              trailingWidget,
              const SizedBox(width: 6),
            ] else if (trailingText != null) ...[
              Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  trailingText,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                ),
              ),
            ],
            const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: const Color(0xFFFFD83D),
            activeTrackColor: const Color(0xFF171717),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // ==========================================
  // AVATAR & IMAGE PICKER BOTTOM SHEET
  // ==========================================
  void _showAvatarPickerSheet(BuildContext context, WidgetRef ref, UserProfileModel user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.72,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: ListView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4.5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Text(
                      'Profile Picture & Avatar',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, letterSpacing: -0.3),
                    ),
                    Spacer(),
                    Icon(Icons.photo_camera_back_outlined, color: Color(0xFFD97706), size: 22),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Upload your real photo from gallery/camera or choose a curated avatar style.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
                ),
                const SizedBox(height: 20),

                // Device Image Picker Action Buttons
                Row(
                  children: [
                    // Gallery Button
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(ctx);
                          _pickImage(ImageSource.gallery);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF6FF),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFBFDBFE), width: 1.2),
                          ),
                          child: const Column(
                            children: [
                              Icon(Icons.photo_library_rounded, color: Color(0xFF2563EB), size: 26),
                              SizedBox(height: 6),
                              Text(
                                'Choose Photo',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: Color(0xFF1E40AF),
                                ),
                              ),
                              Text(
                                'From Gallery',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF3B82F6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Camera Button
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(ctx);
                          _pickImage(ImageSource.camera);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFFDE68A), width: 1.2),
                          ),
                          child: const Column(
                            children: [
                              Icon(Icons.camera_alt_rounded, color: Color(0xFFD97706), size: 26),
                              SizedBox(height: 6),
                              Text(
                                'Take Photo',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: Color(0xFF92400E),
                                ),
                              ),
                              Text(
                                'Use Camera',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFB45309),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                if (user.avatarPath != null) ...[
                  InkWell(
                    onTap: () {
                      ref.read(userProfileProvider.notifier).clearAvatarPath();
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('✓ Custom photo removed. Switched to preset avatar.')),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete_outline_rounded, size: 16, color: Color(0xFFDC2626)),
                          SizedBox(width: 6),
                          Text(
                            'Remove Custom Photo',
                            style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.w700, fontSize: 12.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                const Divider(height: 24, thickness: 1, color: Color(0xFFE5E7EB)),

                // Preset Styles Section Header
                const Text(
                  'Or Choose Preset Style',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14.5, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),

                // Grid of 12 Curated Avatars
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: UserAvatar.presetAvatars.length,
                  itemBuilder: (context, index) {
                    final avatar = UserAvatar.presetAvatars[index];
                    final isSelected = user.avatarPath == null && avatar['id'] == user.avatarIndex;
                    final icon = avatar['icon'] as IconData?;
                    final bg = avatar['bg'] as Color;
                    final color = avatar['color'] as Color;

                    return GestureDetector(
                      onTap: () {
                        ref.read(userProfileProvider.notifier).updateAvatarIndex(avatar['id'] as int);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('✓ Avatar changed to "${avatar['label']}"'),
                            backgroundColor: AppColors.textPrimary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: bg,
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFFFFD83D) : const Color(0xFFE5E7EB),
                                    width: isSelected ? 2.8 : 1.2,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFFFFD83D).withValues(alpha: 0.5),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          )
                                        ]
                                      : null,
                                ),
                                child: icon != null
                                    ? Icon(icon, color: color, size: 24)
                                    : Center(
                                        child: Text(
                                          user.name.isNotEmpty
                                              ? user.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join()
                                              : 'AP',
                                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                                        ),
                                      ),
                              ),
                              if (isSelected)
                                Positioned(
                                  top: -2,
                                  right: -2,
                                  child: Container(
                                    width: 18,
                                    height: 18,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF16A34A),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.check, size: 12, color: Colors.white),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            avatar['label'] as String,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // EDIT PROFILE DIALOG
  // ==========================================
  void _showEditProfileDialog(BuildContext context, WidgetRef ref, UserProfileModel user) {
    final nameCtrl = TextEditingController(text: user.name);
    final occupationCtrl = TextEditingController(text: user.occupation);
    final emailCtrl = TextEditingController(text: user.email);
    final phoneCtrl = TextEditingController(text: user.phone);
    final goalCtrl = TextEditingController(text: user.monthlyIncomeGoal.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.edit_note_rounded, color: Color(0xFFD97706), size: 22),
            ),
            const SizedBox(width: 10),
            const Text(
              'Edit Profile Info',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: AppColors.textPrimary),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: const Icon(Icons.person_outline, size: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: occupationCtrl,
                decoration: InputDecoration(
                  labelText: 'Designation / Occupation',
                  prefixIcon: const Icon(Icons.work_outline_rounded, size: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: const Icon(Icons.email_outlined, size: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: goalCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Monthly Income Target (${user.currency})',
                  prefixIcon: const Icon(Icons.trending_up_rounded, size: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD83D),
              foregroundColor: AppColors.textPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            ),
            onPressed: () {
              if (nameCtrl.text.trim().isNotEmpty) {
                ref.read(userProfileProvider.notifier).updateName(nameCtrl.text.trim());
              }
              if (occupationCtrl.text.trim().isNotEmpty) {
                ref.read(userProfileProvider.notifier).updateOccupation(occupationCtrl.text.trim());
              }
              if (emailCtrl.text.trim().isNotEmpty) {
                ref.read(userProfileProvider.notifier).updateEmail(emailCtrl.text.trim());
              }
              if (phoneCtrl.text.trim().isNotEmpty) {
                ref.read(userProfileProvider.notifier).updatePhone(phoneCtrl.text.trim());
              }
              final parsedGoal = double.tryParse(goalCtrl.text.replaceAll(',', ''));
              if (parsedGoal != null && parsedGoal > 0) {
                ref.read(userProfileProvider.notifier).updateMonthlyIncomeGoal(parsedGoal);
              }

              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle, color: Color(0xFFFFD83D), size: 18),
                      SizedBox(width: 8),
                      Text('Profile updated successfully!'),
                    ],
                  ),
                  backgroundColor: AppColors.textPrimary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // CURRENCY PICKER
  // ==========================================
  void _showCurrencyPicker(BuildContext context, WidgetRef ref, String currentCurrency) {
    const currencies = [
      {'symbol': '₹', 'code': 'INR', 'name': 'Indian Rupee'},
      {'symbol': '\$', 'code': 'USD', 'name': 'US Dollar'},
      {'symbol': '€', 'code': 'EUR', 'name': 'Euro'},
      {'symbol': '£', 'code': 'GBP', 'name': 'British Pound'},
      {'symbol': '¥', 'code': 'JPY', 'name': 'Japanese Yen'},
      {'symbol': 'AED', 'code': 'AED', 'name': 'UAE Dirham'},
      {'symbol': 'C\$', 'code': 'CAD', 'name': 'Canadian Dollar'},
      {'symbol': 'A\$', 'code': 'AUD', 'name': 'Australian Dollar'},
      {'symbol': 'S\$', 'code': 'SGD', 'name': 'Singapore Dollar'},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text('Select Default Currency', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: currencies.map((c) {
                    final isSelected = c['symbol'] == currentCurrency;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFFD83D) : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          c['symbol']!,
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.textPrimary),
                        ),
                      ),
                      title: Text('${c['name']} (${c['code']})', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                      trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 22) : null,
                      onTap: () {
                        ref.read(userProfileProvider.notifier).updateCurrency(c['symbol']!);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('✓ Default currency set to ${c['name']} (${c['symbol']})'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // LOGOUT CONFIRMATION
  // ==========================================
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
            SizedBox(width: 8),
            Text('Sign Out', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
          ],
        ),
        content: const Text(
          'Are you sure you want to log out from this device? Your local data is safely backed up.',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Successfully signed out.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
