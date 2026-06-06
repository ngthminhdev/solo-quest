import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../models/enums/user_enums.dart';
import '../../../widgets/app_section/app_section_header.dart';
import '../../../extensions/localization_extension.dart';

class PrioritySelectorCard extends StatelessWidget {
  final CheckinPriority? value;
  final ValueChanged<CheckinPriority> onChanged;

  const PrioritySelectorCard({
    super.key,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: context.l10n.morningCheckinPriorityLabel,
          dotColor: AppColor.success,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: Column(
            children: CheckinPriority.values.map((level) {
              final isSelected = value == level;
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.s8),
                child: GestureDetector(
                  onTap: () => onChanged(level),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.all(AppSpacing.s14),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColor.successDim : AppColor.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: isSelected
                            ? AppColor.successBorder
                            : AppColor.border,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(level.iconText,
                            style: const TextStyle(fontSize: 20)),
                        const SizedBox(width: AppSpacing.s12),
                        Expanded(
                          child: Text(
                            level.getLocalizedLabel(context.l10n),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppColor.success
                                  : AppColor.fg,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(RemixIcons.checkbox_circle_fill,
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
