import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/user_provider.dart';

class PremiumScreen extends ConsumerWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plans & Upgrade'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Premium Hero Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2C2404), Color(0xFF141203)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [AppShadows.elevated],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.workspace_premium_rounded, color: AppColors.textPrimary, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'FINANCE PRO AI • ${user.name.toUpperCase()}',
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, letterSpacing: 1.2, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Supercharge your financial freedom',
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Unlock automated AI forecasting, unlimited bank sync, smart receipt OCR, and deep wealth analytics.',
                      style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('₹199 / month', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
                          SizedBox(width: 8),
                          Text('(or ₹1,499/year - Save 37%)', style: TextStyle(color: AppColors.primaryLight, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Feature Comparison
              Text(
                'Feature Comparison',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.cardBorder),
                  boxShadow: const [AppShadows.card],
                ),
                child: Column(
                  children: [
                    _buildComparisonRow(
                      feature: 'Income/Expense Tracking',
                      free: true,
                      premium: true,
                    ),
                    _buildComparisonRow(
                      feature: 'AI Finance Assistant & Co-Pilot',
                      free: false,
                      premium: true,
                    ),
                    _buildComparisonRow(
                      feature: 'Smart Receipt Scanner (OCR)',
                      free: false,
                      premium: true,
                    ),
                    _buildComparisonRow(
                      feature: 'Advanced Predictive Analytics',
                      free: false,
                      premium: true,
                    ),
                    _buildComparisonRow(
                      feature: 'Unlimited Accounts & Wallets',
                      free: false,
                      premium: true,
                    ),
                    _buildComparisonRow(
                      feature: 'Encrypted Cloud Backup & Sync',
                      free: false,
                      premium: true,
                    ),
                    _buildComparisonRow(
                      feature: 'Exportable PDF / CSV Statements',
                      free: false,
                      premium: true,
                    ),
                    _buildComparisonRow(
                      feature: 'Smart Budget Warnings',
                      free: true,
                      premium: true,
                      isLast: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Upgrade CTA Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        title: const Text('🎉 Welcome to Finance Pro AI!'),
                        content: const Text(
                          'You have full unlocked access to all AI Co-Pilot features, receipt scanning, and unlimited wallets.',
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Awesome!'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text(
                    'Upgrade to Pro AI',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComparisonRow({
    required String feature,
    required bool free,
    required bool premium,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              feature,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: free
                  ? const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18)
                  : const Icon(Icons.remove_rounded, color: AppColors.textTertiary, size: 18),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: premium
                  ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryDark, size: 20)
                  : const Icon(Icons.remove_rounded, color: AppColors.textTertiary, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
