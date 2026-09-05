import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../models/user_profile_model.dart';

class UserAvatar extends StatelessWidget {
  final UserProfileModel user;
  final double size;
  final bool showBadge;
  final VoidCallback? onBadgeTap;
  final VoidCallback? onTap;

  const UserAvatar({
    super.key,
    required this.user,
    this.size = 56,
    this.showBadge = false,
    this.onBadgeTap,
    this.onTap,
  });

  static const List<Map<String, dynamic>> presetAvatars = [
    {
      'id': 1,
      'label': 'Finance Pro',
      'bg': Color(0xFFFFEAA0),
      'icon': Icons.person_rounded,
      'color': Color(0xFF171717),
      'desc': 'Clean minimal executive',
    },
    {
      'id': 2,
      'label': 'Executive',
      'bg': Color(0xFFDCFCE7),
      'icon': Icons.business_center_rounded,
      'color': Color(0xFF16A34A),
      'desc': 'Corporate & business',
    },
    {
      'id': 3,
      'label': 'Tech Lead',
      'bg': Color(0xFFCCFBF1),
      'icon': Icons.laptop_mac_rounded,
      'color': Color(0xFF0D9488),
      'desc': 'Software & developer',
    },
    {
      'id': 4,
      'label': 'Investor',
      'bg': Color(0xFFDBEAFE),
      'icon': Icons.trending_up_rounded,
      'color': Color(0xFF2563EB),
      'desc': 'Stocks & portfolio',
    },
    {
      'id': 5,
      'label': 'Creator',
      'bg': Color(0xFFFCE7F3),
      'icon': Icons.palette_rounded,
      'color': Color(0xFFDB2777),
      'desc': 'Design & arts',
    },
    {
      'id': 6,
      'label': 'Innovator',
      'bg': Color(0xFFEDE9FE),
      'icon': Icons.auto_awesome_rounded,
      'color': Color(0xFF7C3AED),
      'desc': 'AI & intelligence',
    },
    {
      'id': 7,
      'label': 'Nomad',
      'bg': Color(0xFFFFEDD5),
      'icon': Icons.flight_takeoff_rounded,
      'color': Color(0xFFEA580C),
      'desc': 'Travel & lifestyle',
    },
    {
      'id': 8,
      'label': 'Crypto Whale',
      'bg': Color(0xFFFEF3C7),
      'icon': Icons.currency_bitcoin_rounded,
      'color': Color(0xFFD97706),
      'desc': 'Web3 & crypto',
    },
    {
      'id': 9,
      'label': 'Shield Pro',
      'bg': Color(0xFFE0E7FF),
      'icon': Icons.security_rounded,
      'color': Color(0xFF4F46E5),
      'desc': 'Security & privacy',
    },
    {
      'id': 10,
      'label': 'Growth Hacker',
      'bg': Color(0xFFFEE2E2),
      'icon': Icons.rocket_launch_rounded,
      'color': Color(0xFFDC2626),
      'desc': 'Startup & fast scale',
    },
    {
      'id': 11,
      'label': 'Eco Leader',
      'bg': Color(0xFFECFDF5),
      'icon': Icons.eco_rounded,
      'color': Color(0xFF059669),
      'desc': 'Green & sustainability',
    },
    {
      'id': 12,
      'label': 'Initials',
      'bg': Color(0xFFFFD83D),
      'icon': null,
      'color': Color(0xFF171717),
      'desc': 'Dynamic name monogram',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final avatarContent = _buildAvatarContent();

    final avatarBody = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getBgColor(),
        border: Border.all(
          color: const Color(0xFFFFD83D),
          width: size > 60 ? 2.5 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: ClipOval(child: avatarContent),
    );

    Widget result = avatarBody;

    if (showBadge) {
      result = Stack(
        clipBehavior: Clip.none,
        children: [
          avatarBody,
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: onBadgeTap ?? onTap,
              child: Container(
                width: size * 0.35,
                height: size * 0.35,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD83D),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: size * 0.18,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: result,
      );
    }

    return result;
  }

  Color _getBgColor() {
    if (user.avatarPath != null && user.avatarPath!.isNotEmpty) {
      return Colors.grey.shade200;
    }
    if (user.avatarIndex == 12 || user.avatarIndex == -1) {
      return const Color(0xFFFFD83D);
    }
    final found = presetAvatars.firstWhere(
      (a) => a['id'] == user.avatarIndex,
      orElse: () => presetAvatars.first,
    );
    return found['bg'] as Color;
  }

  Widget _buildAvatarContent() {
    // 1. Check if user has picked a custom image file
    if (user.avatarPath != null && user.avatarPath!.isNotEmpty) {
      if (!kIsWeb) {
        final file = File(user.avatarPath!);
        if (file.existsSync()) {
          return Image.file(
            file,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(),
          );
        }
      }
      return Image.network(
        user.avatarPath!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(),
      );
    }

    // 2. Monogram / Initials
    if (user.avatarIndex == 12 || user.avatarIndex == -1) {
      final initials = user.name.trim().isNotEmpty
          ? user.name
              .trim()
              .split(' ')
              .where((e) => e.isNotEmpty)
              .map((e) => e[0].toUpperCase())
              .take(2)
              .join()
          : 'AP';
      return Text(
        initials,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.38,
          letterSpacing: -0.5,
        ),
      );
    }

    // 3. Preset icon avatar
    final found = presetAvatars.firstWhere(
      (a) => a['id'] == user.avatarIndex,
      orElse: () => presetAvatars.first,
    );
    final icon = found['icon'] as IconData?;
    final color = found['color'] as Color;

    return Icon(
      icon ?? Icons.person_rounded,
      size: size * 0.52,
      color: color,
    );
  }

  Widget _buildFallbackIcon() {
    return Icon(
      Icons.person_rounded,
      size: size * 0.52,
      color: AppColors.textPrimary,
    );
  }
}
