import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_spacing.dart';
import '../../../widgets/app_state/app_empty_state.dart';

import '../../../extensions/localization_extension.dart';

class ReminderSettingsEmptyView extends StatelessWidget {
  const ReminderSettingsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: AppEmptyState(
        icon: RemixIcons.notification_3_line,
        title: context.l10n.reminderEmptyTitle,
        message: context.l10n.reminderEmptyMessage,
      ),
    );
  }
}
