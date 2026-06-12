import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_text_style.dart';
import '../../../extensions/localization_extension.dart';
import '../models/onboarding_data.dart';
import '../utils/onboarding_display_mapper.dart';

class OnboardingCompleteStep extends StatelessWidget {
  final OnboardingData data;

  const OnboardingCompleteStep({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.bgDeep,
            boxShadow: const [
              BoxShadow(
                color: AppColor.cyanGlow,
                blurRadius: 20,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: AppColor.violetGlow,
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            'assets/icons/app_icon_foreground.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          l10n.onboardingStep8Title,
          style: AppTextStyle.h1.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 24,
            letterSpacing: 0.04,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          l10n.onboardingStep8Subtitle,
          style: AppTextStyle.body.copyWith(
            color: AppColor.fgSecondary,
            fontSize: 14,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        _buildSummaryCard(context),
        const SizedBox(height: AppSpacing.lg),
        _buildPreviewCard(context),
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColor.borderGlowViolet),
        boxShadow: const [
          BoxShadow(color: AppColor.violetGlow, blurRadius: 8, spreadRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.onboardingStep8SummaryTitle,
            style: AppTextStyle.monoLabel.copyWith(
              color: AppColor.violet,
              letterSpacing: 0.08,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildSummaryRow(
            l10n.onboardingStep8LabelName,
            data.displayName.isEmpty ? '—' : data.displayName,
          ),
          _buildSummaryRow(
            l10n.onboardingStep8LabelWork,
            data.mainActivity.isEmpty
                ? '—'
                : OnboardingDisplayMapper.localizedMainActivity(
                    context,
                    data.mainActivity,
                  ),
          ),
          _buildSummaryRow(
            l10n.onboardingStep8LabelSchedule,
            data.workStartTime.isNotEmpty && data.workEndTime.isNotEmpty
                ? '${data.workStartTime}–${data.workEndTime}'
                : '—',
          ),
          _buildSummaryRow(
            l10n.onboardingStep8LabelGoals,
            OnboardingDisplayMapper.localizedGoals(context, data.mainGoals),
            highlight: true,
          ),
          _buildSummaryRow(
            l10n.onboardingStep8LabelSleep,
            data.targetSleepTime.isEmpty ? '—' : data.targetSleepTime,
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColor.borderGlowCyan),
        boxShadow: const [
          BoxShadow(color: AppColor.cyanGlow, blurRadius: 8, spreadRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.onboardingStep8PreviewTitle,
            style: AppTextStyle.monoLabel.copyWith(
              color: AppColor.cyan,
              letterSpacing: 0.08,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildPreviewQuest('09:30', l10n.onboardingStep8QuestWater, '+5 EXP'),
          _buildPreviewQuest(
            '10:00',
            l10n.onboardingStep8QuestBreak,
            '+10 EXP',
          ),
          _buildPreviewQuest('18:30', l10n.onboardingStep8QuestWalk, '+30 EXP'),
          _buildPreviewQuest(
            '20:30',
            l10n.onboardingStep8QuestStudy,
            '+35 EXP',
          ),
          _buildPreviewQuest(
            '23:30',
            l10n.onboardingStep8QuestSleep,
            '+20 EXP',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool highlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: AppColor.fgSecondary),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: highlight ? AppColor.cyan : AppColor.fg,
              ),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewQuest(String time, String name, String exp) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            time,
            style: TextStyle(fontSize: 12, color: AppColor.fgMuted),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColor.fg,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            exp,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColor.expGold,
            ),
          ),
        ],
      ),
    );
  }
}
