import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../widgets/app_section/app_section_header.dart';
import '../../../extensions/localization_extension.dart';

class ReviewSatisfactionSelectorCard extends StatelessWidget {
  final int? value;
  final ValueChanged<int> onChanged;

  const ReviewSatisfactionSelectorCard({
    super.key,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final satisfactionLabels = [
      context.l10n.dailyReviewSatisVeryLow,
      context.l10n.dailyReviewSatisLow,
      context.l10n.dailyReviewSatisNormal,
      context.l10n.dailyReviewSatisHigh,
      context.l10n.dailyReviewSatisVeryHigh,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: context.l10n.dailyReviewSatisfactionLabel,
          dotColor: AppColor.expGold,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: Column(
            children: [
              Row(
                children: List.generate(5, (index) {
                  final level = index + 1;
                  final isSelected = value == level;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: GestureDetector(
                        onTap: () => onChanged(level),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColor.expGoldDim
                                : AppColor.surface,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(
                              color: isSelected
                                  ? AppColor.accentBorder
                                  : AppColor.border,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '$level',
                                style: TextStyle(
                                  fontFamily: 'JetBrains Mono',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? AppColor.expGold
                                      : AppColor.fgSecondary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                satisfactionLabels[index],
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? AppColor.expGold
                                      : AppColor.fgMuted,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
