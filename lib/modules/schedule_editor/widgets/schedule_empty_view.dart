import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_spacing.dart';
import '../constants/schedule_editor_constants.dart';

class ScheduleEmptyView extends StatelessWidget {
  const ScheduleEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s32,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColor.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColor.border),
            ),
            child: const Icon(
              RemixIcons.calendar_event_line,
              size: 36,
              color: AppColor.fgMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(
            ScheduleEditorConstants.emptyTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColor.fg,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            ScheduleEditorConstants.emptyMessage,
            style: TextStyle(
              fontSize: 13,
              color: AppColor.fgMuted,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
