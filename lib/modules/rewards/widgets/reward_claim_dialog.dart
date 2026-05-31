import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/reward_model.dart';
import '../constants/rewards_constants.dart';

class RewardClaimDialog extends StatelessWidget {
  final RewardModel reward;
  final int availablePoints;

  const RewardClaimDialog({
    super.key,
    required this.reward,
    required this.availablePoints,
  });

  static Future<bool?> show(
    BuildContext context, {
    required RewardModel reward,
    required int availablePoints,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => RewardClaimDialog(
        reward: reward,
        availablePoints: availablePoints,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final remaining = availablePoints - reward.costPoints;
    final canConfirm = availablePoints >= reward.costPoints;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s24),
      decoration: const BoxDecoration(
        color: AppColor.bgRaised,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(reward.iconText, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      RewardsConstants.claimDialogTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColor.fg,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reward.title,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColor.fgSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context, false),
                child: const Icon(
                  RemixIcons.close_line,
                  size: 22,
                  color: AppColor.fgMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s20),
          _infoRow('Chi phí', '${reward.costPoints} điểm', AppColor.cyan),
          const SizedBox(height: AppSpacing.s8),
          _infoRow('Điểm hiện có', '$availablePoints điểm', AppColor.cyan),
          const SizedBox(height: AppSpacing.s8),
          _infoRow(
            'Còn lại sau đổi',
            '${canConfirm ? remaining : availablePoints} điểm',
            canConfirm ? AppColor.success : AppColor.danger,
          ),
          const SizedBox(height: AppSpacing.s24),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context, false),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColor.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColor.border),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      RewardsConstants.claimDialogCancel,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColor.fgSecondary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: canConfirm
                      ? () => Navigator.pop(context, true)
                      : null,
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: canConfirm ? AppColor.cyan : AppColor.fgMuted,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      RewardsConstants.claimDialogConfirm,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color:
                            canConfirm ? AppColor.bgDeep : AppColor.bgRaised,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColor.fgMuted,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Exo2',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
