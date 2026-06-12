import 'package:flutter/material.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';

class ProgressHeader extends StatelessWidget {
  const ProgressHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
          Text(
            l10n.progressHeaderTitle,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.02,
              color: AppColor.fg,
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            l10n.progressHeaderSubtitle,
            style: TextStyle(
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
