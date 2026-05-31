import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../constants/rewards_constants.dart';

class RewardLinkRow extends StatelessWidget {
  final VoidCallback onProgressTap;
  final VoidCallback onLogsTap;
  final VoidCallback onProfileTap;

  const RewardLinkRow({
    super.key,
    required this.onProgressTap,
    required this.onLogsTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s10,
        AppSpacing.s16,
        0,
      ),
      child: Row(
        children: [
          Expanded(
            child: _LinkItem(
              icon: RemixIcons.bar_chart_2_line,
              iconBg: AppColor.cyanDim,
              iconColor: AppColor.cyan,
              label: RewardsConstants.linkProgressLabel,
              onTap: onProgressTap,
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          Expanded(
            child: _LinkItem(
              icon: RemixIcons.file_text_line,
              iconBg: AppColor.violetDim,
              iconColor: AppColor.violet,
              label: RewardsConstants.linkLogsLabel,
              onTap: onLogsTap,
            ),
          ),
          const SizedBox(width: AppSpacing.s8),
          Expanded(
            child: _LinkItem(
              icon: RemixIcons.user_3_line,
              iconBg: AppColor.warnDim,
              iconColor: AppColor.warn,
              label: RewardsConstants.linkProfileLabel,
              onTap: onProfileTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _LinkItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.s12,
          horizontal: AppSpacing.s10,
        ),
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColor.border),
        ),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(height: AppSpacing.s6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColor.fgSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
