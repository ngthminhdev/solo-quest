import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';
import '../../../generated/l10n/app_localizations.dart';
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
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(title: l10n.profileGoalSectionTitle),
          const SizedBox(height: AppSpacing.s12),

          if (goals.isEmpty)
            _buildEmptyState(l10n)
          else
            _buildGoalsList(l10n, goals),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        children: [
          Text(
            l10n.profileGoalEmpty,
            style: const TextStyle(fontSize: 14, color: AppColor.fgMuted),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s12),
          TextButton(
            onPressed: onSetupGoals,
            child: Text(
              l10n.profileGoalSetupButton,
              style: const TextStyle(
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

  Widget _buildGoalsList(
    AppLocalizations l10n,
    List<String> displayGoals,
  ) {
    final primaryGoal = displayGoals.first;
    final secondaryGoals = displayGoals.skip(1).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColor.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColor.primarySoft,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: AppColor.primaryBorder),
                ),
                child: const Icon(
                  RemixIcons.focus_3_line,
                  size: 18,
                  color: AppColor.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.s10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.profileGoalPursuing,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColor.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.s2),
                    Text(
                      l10n.profileGoalFromProfile,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColor.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _GoalCountBadge(count: displayGoals.length),
            ],
          ),
          const SizedBox(height: AppSpacing.s14),
          _PrimaryGoalRow(goal: primaryGoal),
          if (secondaryGoals.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s10),
            ...secondaryGoals.map((goal) => _SecondaryGoalRow(goal: goal)),
          ],
        ],
      ),
    );
  }
}

class _GoalCountBadge extends StatelessWidget {
  final int count;

  const _GoalCountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: AppColor.primarySoft,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColor.primaryBorder),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: AppColor.primary,
        ),
      ),
    );
  }
}

class _PrimaryGoalRow extends StatelessWidget {
  final String goal;

  const _PrimaryGoalRow({required this.goal});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s12),
      decoration: BoxDecoration(
        gradient: AppColor.questCyanGradient,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColor.primaryBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColor.primarySoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              RemixIcons.crosshair_2_line,
              size: 15,
              color: AppColor.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.s10),
          Expanded(
            child: Text(
              goal,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColor.textPrimary,
                height: 1.25,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _SecondaryGoalRow extends StatelessWidget {
  final String goal;

  const _SecondaryGoalRow({required this.goal});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s8),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s10,
        vertical: AppSpacing.s8,
      ),
      decoration: BoxDecoration(
        color: AppColor.bgRaised,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColor.border),
      ),
      child: Row(
        children: [
          const Icon(
            RemixIcons.checkbox_blank_circle_line,
            size: 14,
            color: AppColor.primary,
          ),
          const SizedBox(width: AppSpacing.s8),
          Expanded(
            child: Text(
              goal,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColor.textSecondary,
                height: 1.25,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
