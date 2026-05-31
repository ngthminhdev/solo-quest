import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../models/enums/log_enums.dart';
import '../constants/daily_review_constants.dart';

class DailyMoodSelectorCard extends StatelessWidget {
  final LogMood? mood;
  final int? energyLevel;
  final int? satisfactionLevel;
  final ValueChanged<LogMood> onMoodChanged;
  final ValueChanged<int> onEnergyChanged;
  final ValueChanged<int> onSatisfactionChanged;

  const DailyMoodSelectorCard({
    super.key,
    required this.mood,
    required this.energyLevel,
    required this.satisfactionLevel,
    required this.onMoodChanged,
    required this.onEnergyChanged,
    required this.onSatisfactionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(DailyReviewConstants.sectionMood),
          const SizedBox(height: AppSpacing.s12),

          // Mood label
          _FieldLabel(DailyReviewConstants.labelMood),
          const SizedBox(height: AppSpacing.s8),
          _buildMoodRow(),

          const SizedBox(height: AppSpacing.s14),

          // Energy
          _FieldLabel(DailyReviewConstants.labelEnergy),
          const SizedBox(height: AppSpacing.s8),
          _buildScaleRow(
            selectedValue: energyLevel,
            onChanged: onEnergyChanged,
            minLabel: DailyReviewConstants.energyLow,
            maxLabel: DailyReviewConstants.energyHigh,
            selectedColor: AppColor.cyan,
          ),

          const SizedBox(height: AppSpacing.s14),

          // Satisfaction
          _FieldLabel(DailyReviewConstants.labelSatisfaction),
          const SizedBox(height: AppSpacing.s8),
          _buildScaleRow(
            selectedValue: satisfactionLevel,
            onChanged: onSatisfactionChanged,
            minLabel: DailyReviewConstants.satisLow,
            maxLabel: DailyReviewConstants.satisHigh,
            selectedColor: AppColor.expGold,
          ),
        ],
      ),
    );
  }

  Widget _buildMoodRow() {
    final moods = [
      _MoodOption(LogMood.good, 'Tốt', RemixIcons.emotion_happy_line),
      _MoodOption(LogMood.neutral, 'Bình thường', RemixIcons.emotion_line),
      _MoodOption(LogMood.bad, 'Mệt', RemixIcons.emotion_unhappy_line),
      _MoodOption(LogMood.veryBad, 'Stress', RemixIcons.emotion_sad_line),
    ];

    return Row(
      children: moods.map((option) {
        final isSelected = mood == option.mood;
        return Expanded(
          child: GestureDetector(
            onTap: () => onMoodChanged(option.mood),
            child: Container(
              margin: EdgeInsets.only(
                right: option == moods.last ? 0 : AppSpacing.s8,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.s10,
                horizontal: AppSpacing.s6,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColor.violetDim : AppColor.surface,
                border: Border.all(
                  color: isSelected ? AppColor.violet : AppColor.border,
                ),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Column(
                children: [
                  Icon(
                    option.icon,
                    size: 22,
                    color: isSelected ? AppColor.violet : AppColor.fgMuted,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    option.label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColor.violet : AppColor.fgMuted,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildScaleRow({
    required int? selectedValue,
    required ValueChanged<int> onChanged,
    required String minLabel,
    required String maxLabel,
    required Color selectedColor,
  }) {
    return Column(
      children: [
        Row(
          children: List.generate(5, (index) {
            final value = index + 1;
            final isSelected = selectedValue == value;
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(value),
                child: Container(
                  margin: EdgeInsets.only(
                    right: index < 4 ? AppSpacing.s6 : 0,
                  ),
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected ? selectedColor.withAlpha(40) : AppColor.surface,
                    border: Border.all(
                      color: isSelected ? selectedColor : AppColor.border,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$value',
                    style: TextStyle(
                      fontFamily: 'JetBrains Mono',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? selectedColor : AppColor.fgMuted,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              minLabel,
              style: const TextStyle(fontSize: 11, color: AppColor.fgMuted),
            ),
            Text(
              maxLabel,
              style: const TextStyle(fontSize: 11, color: AppColor.fgMuted),
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'JetBrains Mono',
        fontSize: 11,
        color: AppColor.fgMuted,
        letterSpacing: 0.08,
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        color: AppColor.fgSecondary,
      ),
    );
  }
}

class _MoodOption {
  final LogMood mood;
  final String label;
  final IconData icon;

  const _MoodOption(this.mood, this.label, this.icon);
}
