import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';

class CheckinStepIndicator extends StatelessWidget {
  final double progress;
  final bool hasCheckedIn;

  const CheckinStepIndicator({
    super.key,
    required this.progress,
    required this.hasCheckedIn,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.morningCheckinStepTitle,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.08,
                  color: AppColor.fgSecondary,
                ),
              ),
              Text(
                hasCheckedIn
                    ? context.l10n.morningCheckinCompleted
                    : '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: hasCheckedIn ? AppColor.success : AppColor.cyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: AppColor.surface,
              valueColor: AlwaysStoppedAnimation<Color>(
                hasCheckedIn ? AppColor.success : AppColor.cyan,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
