import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../extensions/localization_extension.dart';
import '../../../widgets/app_button/app_button.dart';
import '../../../widgets/app_state/app_empty_state.dart';

class QuestRulesEmptyView extends StatelessWidget {
  final VoidCallback? onReset;

  const QuestRulesEmptyView({super.key, this.onReset});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        AppEmptyState(
          icon: RemixIcons.inbox_archive_line,
          title: l10n.questRulesEmptyTitle,
          message: l10n.questRulesEmptyMessage,
        ),
        if (onReset != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppButton(
              label: l10n.questRulesResetDefault,
              onPressed: onReset,
            ),
          ),
      ],
    );
  }
}
