import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../extensions/localization_extension.dart';
import '../../../widgets/app_state/app_empty_state.dart';

class LearningRoadmapEmptyView extends StatelessWidget {
  final VoidCallback? onCreateRoadmap;

  const LearningRoadmapEmptyView({
    super.key,
    this.onCreateRoadmap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppEmptyState(
      icon: RemixIcons.map_2_line,
      title: l10n.lrEmptyTitle,
      message: l10n.lrEmptyMessage,
      action: onCreateRoadmap != null
          ? OutlinedButton.icon(
              onPressed: onCreateRoadmap,
              icon: const Icon(RemixIcons.add_line, size: 18),
              label: Text(l10n.lrEmptyButton),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColor.cyan,
                side: BorderSide(color: AppColor.primaryBorder),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
              ),
            )
          : null,
    );
  }
}
