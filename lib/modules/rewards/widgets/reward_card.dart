import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/reward_model.dart';
import '../../../models/enums/reward_enums.dart';

class RewardCard extends StatelessWidget {
  final RewardModel reward;
  final bool canClaim;
  final VoidCallback? onClaim;

  const RewardCard({
    super.key,
    required this.reward,
    required this.canClaim,
    this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final isClaimed = reward.status == RewardStatus.claimed;
    final isLocked = reward.status == RewardStatus.locked;
    final notEnough = reward.status == RewardStatus.available && !canClaim;

    return Opacity(
      opacity: isClaimed ? 0.55 : 1.0,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s12),
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: _borderColor(isClaimed, isLocked, notEnough),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(reward.iconText, style: const TextStyle(fontSize: 20)),
                const Spacer(),
                if (isClaimed)
                  _statusBadge('Đã đổi', AppColor.success, AppColor.successDim)
                else if (isLocked)
                  _statusBadge('Khóa', AppColor.fgMuted, AppColor.surfaceActive)
                else if (notEnough)
                  _statusBadge(
                      'Thiếu điểm', AppColor.warn, AppColor.warnDim),
              ],
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              reward.title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isClaimed ? AppColor.fgMuted : AppColor.fg,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (reward.description.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.s4),
              Text(
                reward.description,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColor.fgMuted,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const Spacer(),
            Row(
              children: [
                Text(
                  '${reward.costPoints} điểm',
                  style: TextStyle(
                    fontFamily: 'Exo2',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: isClaimed ? AppColor.fgMuted : AppColor.cyan,
                  ),
                ),
                const Spacer(),
                _buildButton(isClaimed, isLocked, notEnough),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(String label, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildButton(bool isClaimed, bool isLocked, bool notEnough) {
    if (isClaimed) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColor.successDim,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(RemixIcons.checkbox_circle_line, size: 12, color: AppColor.success),
            SizedBox(width: 4),
            Text(
              'Đã đổi',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColor.success,
              ),
            ),
          ],
        ),
      );
    }

    if (isLocked) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColor.surfaceActive,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(RemixIcons.lock_line, size: 12, color: AppColor.fgMuted),
            SizedBox(width: 4),
            Text(
              'Đã khóa',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColor.fgMuted,
              ),
            ),
          ],
        ),
      );
    }

    if (notEnough) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColor.warnDim,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: const Text(
          'Chưa đủ điểm',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColor.warn,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onClaim,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColor.cyan,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: const Text(
          'Đổi thưởng',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColor.bgDeep,
          ),
        ),
      ),
    );
  }

  Color _borderColor(bool isClaimed, bool isLocked, bool notEnough) {
    if (isClaimed) return AppColor.successDim;
    if (isLocked) return AppColor.border;
    if (notEnough) return AppColor.warnDim;
    return AppColor.borderGlowCyan;
  }
}
