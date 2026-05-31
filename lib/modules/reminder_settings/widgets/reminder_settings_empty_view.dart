import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_spacing.dart';
import '../../../widgets/app_state/app_empty_state.dart';

class ReminderSettingsEmptyView extends StatelessWidget {
  const ReminderSettingsEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: AppEmptyState(
        icon: RemixIcons.notification_3_line,
        title: 'Chưa có nhắc nhở',
        message:
            'SoloQuest sẽ dùng cài đặt nhắc nhở để giúp bạn duy trì nhịp sinh hoạt.',
      ),
    );
  }
}
