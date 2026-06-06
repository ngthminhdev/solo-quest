import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_radius.dart';
import '../../../models/enums/user_enums.dart';
import '../../../widgets/app_section/app_section_header.dart';
import '../../../extensions/localization_extension.dart';

class AvailabilitySelectorCard extends StatelessWidget {
  final Availability? value;
  final ValueChanged<Availability> onChanged;

  const AvailabilitySelectorCard({
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
          title: context.l10n.morningCheckinAvailabilityLabel,
          dotColor: AppColor.warn,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
          child: Row(
            children: Availability.values.map((level) {
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
                        color: isSelected ? AppColor.warnDim : AppColor.surface,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: isSelected
                              ? AppColor.warningBorder
                              : AppColor.border,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(level.iconText,
                              style: const TextStyle(fontSize: 18)),
                          const SizedBox(height: 4),
                          Text(
                            level.getLocalizedLabel(context.l10n),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppColor.warn
                                  : AppColor.fgSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
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
