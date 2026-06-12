import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';
import '../../../widgets/app_card/app_card.dart';

class QuestDailyLimitCard extends StatelessWidget {
  final int value;
  final bool isLoading;
  final ValueChanged<int> onChanged;

  const QuestDailyLimitCard({
    super.key,
    required this.value,
    required this.isLoading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppCard(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
      ).copyWith(bottom: AppSpacing.s12),
      padding: const EdgeInsets.all(AppSpacing.s14),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColor.warnDim,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(
              RemixIcons.calendar_check_line,
              size: 20,
              color: AppColor.warn,
            ),
          ),
          const SizedBox(width: AppSpacing.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.questRulesDailyLimitTitle,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColor.fg,
                  ),
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  l10n.questRulesDailyLimitSubtitle,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.35,
                    color: AppColor.fgSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s10),
          _LimitStepper(
            value: value,
            enabled: !isLoading,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _LimitStepper extends StatelessWidget {
  final int value;
  final bool enabled;
  final ValueChanged<int> onChanged;

  const _LimitStepper({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColor.bgRaised,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColor.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepperButton(
            icon: RemixIcons.subtract_line,
            enabled: enabled && value > 1,
            onTap: () => onChanged(value - 1),
          ),
          SizedBox(
            width: 34,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColor.fg,
              ),
            ),
          ),
          _StepperButton(
            icon: RemixIcons.add_line,
            enabled: enabled && value < 20,
            onTap: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _StepperButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: enabled ? AppColor.cyanDim : AppColor.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? AppColor.cyan : AppColor.fgMuted,
        ),
      ),
    );
  }
}
