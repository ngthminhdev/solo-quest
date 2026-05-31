import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../models/enums/reward_enums.dart';
import '../constants/rewards_constants.dart';

class RewardsFilterBar extends StatelessWidget {
  final RewardType? selectedType;
  final ValueChanged<RewardType?> onTypeChanged;
  final VoidCallback onClearFilter;

  const RewardsFilterBar({
    super.key,
    this.selectedType,
    required this.onTypeChanged,
    required this.onClearFilter,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
        children: [
          _buildChip(
            label: RewardsConstants.filterAll,
            iconText: '🏷️',
            type: null,
          ),
          ...RewardType.values.map((type) => _buildChip(
                label: type.label,
                iconText: type.iconText,
                type: type,
              )),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required String iconText,
    required RewardType? type,
  }) {
    final isSelected = selectedType == type;

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.s8),
      child: GestureDetector(
        onTap: () => onTypeChanged(type),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s12,
            vertical: AppSpacing.s8,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColor.cyanDim : AppColor.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColor.borderGlowCyan : AppColor.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(iconText, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: AppSpacing.s4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColor.cyan : AppColor.fgSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
