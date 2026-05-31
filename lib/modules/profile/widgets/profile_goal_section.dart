import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../widgets/app_section_header/app_section_header.dart';

class ProfileGoalSection extends StatelessWidget {
  final List<String> goals;
  final VoidCallback onSetupGoals;

  const ProfileGoalSection({
    super.key,
    required this.goals,
    required this.onSetupGoals,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(title: 'Mục Tiêu Chính'),
          const SizedBox(height: AppSpacing.s12),

          if (goals.isEmpty)
            _buildEmptyState()
          else
            _buildGoalsList(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        children: [
          Text(
            'Bạn chưa đặt mục tiêu chính.',
            style: TextStyle(
              fontSize: 14,
              color: AppColor.fgMuted,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s12),
          TextButton(
            onPressed: onSetupGoals,
            child: const Text(
              'Thiết lập mục tiêu',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColor.cyan,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsList() {
    return Wrap(
      spacing: AppSpacing.s8,
      runSpacing: AppSpacing.s8,
      children: goals.map((goal) => _GoalChip(goal: goal)).toList(),
    );
  }
}

class _GoalChip extends StatelessWidget {
  final String goal;

  const _GoalChip({required this.goal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s8,
      ),
      decoration: BoxDecoration(
        color: AppColor.cyanDim,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: AppColor.cyan.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            RemixIcons.focus_3_line,
            size: 14,
            color: AppColor.cyan,
          ),
          const SizedBox(width: AppSpacing.s6),
          Text(
            goal,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColor.cyan,
            ),
          ),
        ],
      ),
    );
  }
}
