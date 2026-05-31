import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_text_style.dart';
import '../constants/onboarding_constants.dart';
import '../models/onboarding_data.dart';

class OnboardingCompleteStep extends StatelessWidget {
  final OnboardingData data;

  const OnboardingCompleteStep({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColor.levelGradient,
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
          child: const Icon(
            RemixIcons.star_line,
            size: 40,
            color: AppColor.bgDeep,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          OnboardingConstants.step8Title,
          style: AppTextStyle.h1.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 24,
            letterSpacing: 0.04,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          OnboardingConstants.step8Subtitle,
          style: AppTextStyle.body.copyWith(
            color: AppColor.fgSecondary,
            fontSize: 14,
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        _buildSummaryCard(),
        const SizedBox(height: AppSpacing.lg),
        _buildPreviewCard(),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColor.borderGlowViolet),
        boxShadow: const [
          BoxShadow(
            color: AppColor.violetGlow,
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            OnboardingConstants.summaryTitle,
            style: AppTextStyle.monoLabel.copyWith(
              color: AppColor.violet,
              letterSpacing: 0.08,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildSummaryRow('Tên', data.displayName.isEmpty ? '—' : data.displayName),
          _buildSummaryRow(
            'Công việc',
            data.mainActivity.isEmpty ? '—' : data.mainActivity,
          ),
          _buildSummaryRow(
            'Lịch làm',
            data.workStartTime.isNotEmpty && data.workEndTime.isNotEmpty
                ? '${data.workStartTime}–${data.workEndTime}'
                : '—',
          ),
          _buildSummaryRow(
            'Mục tiêu',
            data.mainGoals.isEmpty ? '—' : data.mainGoals.join(' · '),
            highlight: true,
          ),
          _buildSummaryRow(
            'Giờ ngủ',
            data.targetSleepTime.isEmpty ? '—' : data.targetSleepTime,
          ),
          _buildSummaryRow(
            'Break',
            'Mỗi ${data.breakReminderInterval} phút',
          ),
          _buildSummaryRow(
            'Phần thưởng',
            data.preferredRewards.isEmpty
                ? '—'
                : data.preferredRewards.join(' · '),
            highlight: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColor.borderGlowCyan),
        boxShadow: const [
          BoxShadow(
            color: AppColor.cyanGlow,
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            OnboardingConstants.previewTitle,
            style: AppTextStyle.monoLabel.copyWith(
              color: AppColor.cyan,
              letterSpacing: 0.08,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildPreviewQuest('09:30', 'Uống 250ml nước', '+5 EXP'),
          _buildPreviewQuest('10:00', 'Rời khỏi màn hình 5 phút', '+10 EXP'),
          _buildPreviewQuest('18:30', 'Đi bộ 15 phút', '+30 EXP'),
          _buildPreviewQuest('20:30', 'Học Docker cơ bản 20 phút', '+35 EXP'),
          _buildPreviewQuest('23:30', 'Đặt điện thoại xuống 15 phút', '+20 EXP'),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColor.fgSecondary,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: highlight ? AppColor.cyan : AppColor.fg,
              ),
              textAlign: TextAlign.right,
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
            style: const TextStyle(
              fontFamily: 'Exo2',
              fontSize: 12,
              color: AppColor.fgMuted,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColor.fg,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            exp,
            style: const TextStyle(
              fontFamily: 'Exo2',
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
