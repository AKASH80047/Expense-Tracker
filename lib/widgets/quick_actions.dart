import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback onAddExpense;
  final VoidCallback onAddIncome;
  final VoidCallback onTransfer;
  final VoidCallback onScanReceipt;

  const QuickActions({
    super.key,
    required this.onAddExpense,
    required this.onAddIncome,
    required this.onTransfer,
    required this.onScanReceipt,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildActionButton(
            context,
            icon: Icons.add,
            label: 'Add\nExpense',
            iconColor: AppColors.textPrimary,
            bgColor: const Color(0xFFFFD83D),
            onTap: onAddExpense,
          ),
          _buildActionButton(
            context,
            icon: Icons.add,
            label: 'Add\nIncome',
            iconColor: const Color(0xFF16A34A),
            bgColor: const Color(0xFFDCFCE7),
            onTap: onAddIncome,
          ),
          _buildActionButton(
            context,
            icon: Icons.swap_horiz_rounded,
            label: 'Transfer\n',
            iconColor: const Color(0xFF2563EB),
            bgColor: const Color(0xFFDBEAFE),
            onTap: onTransfer,
          ),
          _buildActionButton(
            context,
            icon: Icons.camera_alt_outlined,
            label: 'Scan\nReceipt',
            iconColor: const Color(0xFFE11D48),
            bgColor: const Color(0xFFFFE4E6),
            onTap: onScanReceipt,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color iconColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFF1F2F4), width: 1.2),
            boxShadow: const [AppShadows.card],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  fontSize: 10.5,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
