import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/security_provider.dart';

class SecurityScreen extends ConsumerWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final security = ref.watch(securitySettingsProvider);
    final notifier = ref.read(securitySettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Security & Privacy'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Security Status Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.cardBorder),
                  boxShadow: const [AppShadows.card],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.successLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.verified_user_rounded, color: AppColors.success, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Device Security: Maximum', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                          SizedBox(height: 2),
                          Text('AES-256 Bit On-Device Vault Active', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Access Control',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),

              _buildSwitchCard(
                title: 'PIN Lock',
                subtitle: 'Require 4-digit PIN upon app launch',
                value: security.pinLock,
                onChanged: (v) => notifier.togglePinLock(v),
                icon: Icons.pin_outlined,
              ),
              _buildSwitchCard(
                title: 'Biometric Authentication',
                subtitle: 'Unlock with Face ID or Fingerprint scanner',
                value: security.biometricAuth,
                onChanged: (v) => notifier.toggleBiometricAuth(v),
                icon: Icons.fingerprint_rounded,
              ),
              const SizedBox(height: 20),

              Text(
                'Data & Storage',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),

              _buildSwitchCard(
                title: 'Encrypted Local Data',
                subtitle: 'Zero-knowledge encrypted database storage',
                value: security.encryptedLocalData,
                onChanged: (v) => notifier.toggleEncryptedData(v),
                icon: Icons.lock_outline_rounded,
              ),
              _buildSwitchCard(
                title: 'Cloud Backup',
                subtitle: 'End-to-end encrypted sync to cloud storage',
                value: security.cloudBackup,
                onChanged: (v) => notifier.toggleCloudBackup(v),
                icon: Icons.cloud_done_outlined,
              ),
              _buildSwitchCard(
                title: 'Auto Backup',
                subtitle: 'Automatically back up ledger daily at midnight',
                value: security.autoBackup,
                onChanged: (v) => notifier.toggleAutoBackup(v),
                icon: Icons.sync_rounded,
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchCard({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.textPrimary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: AppColors.primaryDark,
            activeTrackColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
