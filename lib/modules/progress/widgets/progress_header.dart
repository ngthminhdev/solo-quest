import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../constants/progress_constants.dart';

class ProgressHeader extends StatelessWidget {
  const ProgressHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s16,
        AppSpacing.s16,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            ProgressConstants.headerTitle,
            style: TextStyle(
              fontFamily: 'Exo2',
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.02,
              color: AppColor.fg,
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            ProgressConstants.headerSubtitle,
            style: const TextStyle(
              fontSize: 13,
              color: AppColor.fgSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
