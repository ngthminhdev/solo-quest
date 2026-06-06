import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../constants/app_spacing.dart';
import '../../../extensions/localization_extension.dart';
import '../../../widgets/app_section_header/app_section_header.dart';
import 'profile_menu_tile.dart';

class ProfileSettingsSection extends StatelessWidget {
  final VoidCallback onScheduleTap;
  final VoidCallback? onLearningGoalsTap;
  final VoidCallback? onLearningRoadmapTap;
  final VoidCallback onReminderSettingsTap;
  final VoidCallback onQuestRulesTap;

  const ProfileSettingsSection({
    super.key,
    required this.onScheduleTap,
    this.onLearningGoalsTap,
    this.onLearningRoadmapTap,
    required this.onReminderSettingsTap,
    required this.onQuestRulesTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(title: l10n.profileSettingsTitle),
          const SizedBox(height: AppSpacing.s12),

          ProfileMenuTile(
            icon: RemixIcons.calendar_line,
            title: l10n.profileScheduleTileTitle,
            subtitle: l10n.profileScheduleTileSubtitle,
            onTap: onScheduleTap,
          ),

          const SizedBox(height: AppSpacing.s12),

          // UI reactivated; backend integration pending

          // if (onLearningGoalsTap != null) ...[
          //   const SizedBox(height: AppSpacing.s12),
          //   ProfileMenuTile(
          //     icon: RemixIcons.focus_3_line,
          //     title: l10n.profileLearningGoalsTileTitle,
          //     subtitle: l10n.profileLearningGoalsTileSubtitle,
          //     onTap: onLearningGoalsTap!,
          //   ),
          // ],

          // if (onLearningRoadmapTap != null) ...[
          //   const SizedBox(height: AppSpacing.s12),
          //   ProfileMenuTile(
          //     icon: RemixIcons.road_map_line,
          //     title: l10n.profileLearningRoadmapTileTitle,
          //     subtitle: l10n.profileLearningRoadmapTileSubtitle,
          //     onTap: onLearningRoadmapTap!,
          //   ),
          // ],

          ProfileMenuTile(
            icon: RemixIcons.notification_3_line,
            title: l10n.profileReminderSettingsTileTitle,
            subtitle: l10n.profileReminderSettingsTileSubtitle,
            onTap: onReminderSettingsTap,
          ),

          const SizedBox(height: AppSpacing.s12),

          ProfileMenuTile(
            icon: RemixIcons.settings_3_line,
            title: l10n.profileQuestRulesTileTitle,
            subtitle: l10n.profileQuestRulesTileSubtitle,
            onTap: onQuestRulesTap,
          ),
        ],
      ),
    );
  }
}
