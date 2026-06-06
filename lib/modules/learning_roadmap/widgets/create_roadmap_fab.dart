import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../extensions/localization_extension.dart';

class CreateRoadmapFab extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateRoadmapFab({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: AppColor.cyan,
      foregroundColor: AppColor.bgDeep,
      elevation: 0,
      extendedPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(RemixIcons.sparkling_2_fill, size: 20),
          const SizedBox(width: 8),
          Text(
            l10n.createRoadmapFab,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      heroTag: 'create_roadmap',
    );
  }
}
