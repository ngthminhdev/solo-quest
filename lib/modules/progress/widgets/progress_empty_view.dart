import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';
import '../../../routes/routes_config.dart';
import '../../../widgets/app_state/app_empty_state.dart';

class ProgressEmptyView extends StatelessWidget {
  const ProgressEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppEmptyState(
      icon: RemixIcons.bar_chart_2_line,
      title: l10n.progressEmptyTitle,
      message: l10n.progressEmptyMessage,
      action: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacementNamed(RoutesConfig.home);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s24,
            vertical: AppSpacing.s12,
          ),
          decoration: BoxDecoration(
            color: AppColor.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.border),
          ),
          child: Text(
            l10n.progressEmptyAction,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColor.cyan,
            ),
          ),
        ),
      ),
    );
  }
}
