import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../models/enums/user_enums.dart';
import '../../../widgets/app_section/app_section_header.dart';
import '../constants/morning_checkin_constants.dart';

class DayIntensitySelectorCard extends StatelessWidget {
  final DayIntensity? value;
  final ValueChanged<DayIntensity> onChanged;

  const DayIntensitySelectorCard({
    super.key,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(
          title: MorningCheckinConstants.dayIntensityLabel,
          dotColor: AppColor.success,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: Column(
            children: DayIntensity.values.map((level) {
              final isSelected = value == level;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s8),
                child: GestureDetector(
                  onTap: () => onChanged(level),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.all(AppSpacing.s14),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? AppColor.successDim : AppColor.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: isSelected
                            ? AppColor.success.withValues(alpha: 0.3)
                            : AppColor.border,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(level.iconText,
                            style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: AppSpacing.s12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                level.label,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? AppColor.success
                                      : AppColor.fg,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                level.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSelected
                                      ? AppColor.success.withValues(alpha: 0.7)
                                      : AppColor.fgMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle,
                              size: 20, color: AppColor.success),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
