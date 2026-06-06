import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';

enum ExtraStudyDuration {
  fifteen(15, '15m'),
  twentyFive(25, '25m'),
  fortyFive(45, '45m'),
  sixty(60, '60m');

  final int minutes;
  final String label;

  const ExtraStudyDuration(this.minutes, this.label);
}

class StudyMoreTodayCard extends StatefulWidget {
  final Function(int minutes)? onStartExtraStudy;
  final VoidCallback? onViewProgress;

  const StudyMoreTodayCard({
    super.key,
    this.onStartExtraStudy,
    this.onViewProgress,
  });

  @override
  State<StudyMoreTodayCard> createState() => _StudyMoreTodayCardState();
}

class _StudyMoreTodayCardState extends State<StudyMoreTodayCard> {
  ExtraStudyDuration? _selectedDuration;

  String _durationLabel(ExtraStudyDuration duration) {
    final l10n = context.l10n;
    switch (duration) {
      case ExtraStudyDuration.fifteen:
        return l10n.lrStudyMoreDuration15;
      case ExtraStudyDuration.twentyFive:
        return l10n.lrStudyMoreDuration25;
      case ExtraStudyDuration.fortyFive:
        return l10n.lrStudyMoreDuration45;
      case ExtraStudyDuration.sixty:
        return l10n.lrStudyMoreDuration60;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: BoxDecoration(
        color: AppColor.surface,
        border: Border.all(color: AppColor.border),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                RemixIcons.add_circle_line,
                size: 16,
                color: AppColor.violet,
              ),
              const SizedBox(width: AppSpacing.s8),
              Text(
                l10n.lrStudyMoreTitle,
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: AppColor.violet,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.s10),

          Text(
            l10n.lrStudyMoreDescription,
            style: TextStyle(
              fontSize: 12,
              color: AppColor.fgMuted,
              height: 1.4,
            ),
          ),

          const SizedBox(height: AppSpacing.s12),

          // Duration chips
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            children: ExtraStudyDuration.values.map((duration) {
              final isSelected = _selectedDuration == duration;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDuration =
                        isSelected ? null : duration;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s12,
                    vertical: AppSpacing.s8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor.violetDim
                        : AppColor.surfaceHover,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(
                      color: isSelected
                          ? AppColor.secondaryStrongBorder
                          : AppColor.border,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        RemixIcons.time_line,
                        size: 14,
                        color:
                            isSelected ? AppColor.violet : AppColor.fgMuted,
                      ),
                      const SizedBox(width: AppSpacing.s4),
                      Text(
                        _durationLabel(duration),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color:
                              isSelected ? AppColor.violet : AppColor.fgSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          if (_selectedDuration != null) ...[
            const SizedBox(height: AppSpacing.s12),

            // Start extra study button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  widget.onStartExtraStudy?.call(_selectedDuration!.minutes);
                },
                icon: const Icon(RemixIcons.play_fill, size: 16),
                label: Text(l10n.lrStudyMoreButton(_selectedDuration!.label)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.violet,
                  foregroundColor: AppColor.bgDeep,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.s8),

            // View progress link
            TextButton.icon(
              onPressed: widget.onViewProgress,
              icon: const Icon(RemixIcons.bar_chart_2_line, size: 14),
              label: Text(l10n.lrStudyMoreViewProgress),
              style: TextButton.styleFrom(
                foregroundColor: AppColor.fgSecondary,
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],

          // Note about local-only tracking
          const SizedBox(height: AppSpacing.s4),
          // TODO: Backend integration — extra study time is tracked locally.
          // Backend should expose an endpoint to persist extra study sessions.
        ],
      ),
    );
  }
}
