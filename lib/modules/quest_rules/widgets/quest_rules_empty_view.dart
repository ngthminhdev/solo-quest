import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../widgets/app_button/app_button.dart';
import '../../../widgets/app_state/app_empty_state.dart';
import '../constants/quest_rules_constants.dart';

class QuestRulesEmptyView extends StatelessWidget {
  final VoidCallback? onReset;

  const QuestRulesEmptyView({super.key, this.onReset});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppEmptyState(
          icon: RemixIcons.inbox_archive_line,
          title: QuestRulesConstants.emptyTitle,
          message: QuestRulesConstants.emptyMessage,
        ),
        if (onReset != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppButton(label: 'Khôi phục mặc định', onPressed: onReset),
          ),
      ],
    );
  }
}
