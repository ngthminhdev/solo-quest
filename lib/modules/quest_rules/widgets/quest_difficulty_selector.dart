import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_color.dart';
import '../../../constants/app_radius.dart';
import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';
import '../../../models/enums/quest_enums.dart';

class QuestDifficultySelector extends StatelessWidget {
  final QuestDifficulty value;
  final ValueChanged<QuestDifficulty> onChanged;

  const QuestDifficultySelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return GestureDetector(
      onTap: () => _showDifficultyPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s12,
          vertical: AppSpacing.s10,
        ),
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: AppColor.border),
        ),
        child: Row(
          children: [
            Icon(
              _iconFor(value),
              size: 18,
              color: AppColor.cyan,
            ),
            const SizedBox(width: AppSpacing.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value.getLocalizedLabel(l10n),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColor.fg,
                    ),
                  ),
                  Text(
                    value.getLocalizedDescription(l10n),
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColor.fgMuted,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              RemixIcons.arrow_down_s_line,
              size: 18,
              color: AppColor.fgMuted,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDifficultyPicker(BuildContext context) async {
    final l10n = context.l10n;

    final result = await showModalBottomSheet<QuestDifficulty>(
      context: context,
      backgroundColor: AppColor.bgRaised,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                  child: Text(
                    l10n.questRulesGeneralDifficultySelectorTitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColor.fg,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                ...QuestDifficulty.values.map((difficulty) {
                  final selected = value == difficulty;
                  return InkWell(
                    onTap: () => Navigator.of(context).pop(difficulty),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s16,
                        vertical: AppSpacing.s14,
                      ),
                      color: selected ? AppColor.cyanDim : null,
                      child: Row(
                        children: [
                          Icon(
                            _iconFor(difficulty),
                            size: 18,
                            color: selected ? AppColor.cyan : AppColor.fgMuted,
                          ),
                          const SizedBox(width: AppSpacing.s12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  difficulty.getLocalizedLabel(l10n),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: selected ? AppColor.cyan : AppColor.fg,
                                  ),
                                ),
                                Text(
                                  difficulty.getLocalizedDescription(l10n),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColor.fgMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (selected)
                            Icon(
                              RemixIcons.check_line,
                              size: 18,
                              color: AppColor.cyan,
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );

    if (result != null) {
      onChanged(result);
    }
  }

  IconData _iconFor(QuestDifficulty difficulty) {
    switch (difficulty) {
      case QuestDifficulty.easy:
        return RemixIcons.leaf_line;
      case QuestDifficulty.medium:
        return RemixIcons.flashlight_line;
      case QuestDifficulty.hard:
        return RemixIcons.fire_line;
    }
  }
}
