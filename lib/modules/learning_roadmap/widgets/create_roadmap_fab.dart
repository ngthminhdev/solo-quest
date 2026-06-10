import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../extensions/localization_extension.dart';

class CreateRoadmapFab extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isGenerating;
  final String? generationMessage;

  const CreateRoadmapFab({
    super.key,
    required this.onPressed,
    this.isGenerating = false,
    this.generationMessage,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (isGenerating) {
      return Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColor.bgRaised,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(color: AppColor.cyan.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColor.cyan.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColor.cyan),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              generationMessage ?? 'Đang tạo lộ trình...',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColor.cyan,
              ),
            ),
          ],
        ),
      );
    }

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
