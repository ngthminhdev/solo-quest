import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../constants/app_color.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_spacing.dart';
import '../../core/utils/enum_mapper.dart';
import '../../models/enums/quest_enums.dart';
import '../../models/quest_rule_model.dart';
import '../../widgets/app_button/app_button.dart';
import '../../widgets/app_card/app_card.dart';
import '../../widgets/app_dialog/app_confirm_dialog.dart';
import '../../widgets/app_form/app_toggle_row.dart';
import '../../widgets/app_scaffold/app_scaffold.dart';
import '../../widgets/app_state/app_error_state.dart';
import '../../widgets/app_state/app_loading.dart';
import '../../widgets/app_toast/app_toast_service.dart';
import '../../extensions/localization_extension.dart';
import 'quest_rules_page_model.dart';
import 'widgets/quest_daily_limit_card.dart';
import 'widgets/quest_difficulty_selector.dart';
import 'widgets/quest_rule_form_sheet.dart';
import 'widgets/quest_rule_list_section.dart';
import 'widgets/quest_rules_header.dart';
import 'widgets/quest_rules_summary_card.dart';

class QuestRulesPage
    extends BasePage<QuestRulesPageModel, QuestRulesPageState> {
  QuestRulesPage({super.key}) : super(provider: questRulesPageProvider);

  @override
  ConsumerState<QuestRulesPage> createState() => _QuestRulesPageState();
}

class _QuestRulesPageState
    extends
        BasePageConsumerState<
          QuestRulesPage,
          QuestRulesPageModel,
          QuestRulesPageState
        > {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageModel.loadSettings();
    });
  }

  @override
  Widget renderPage(BuildContext context) {
    final state = read;

    if (state.loadState == AppLoadState.loading && !state.hasRules) {
      return AppScaffold(
        scroll: false,
        body: Column(
          children: [
            QuestRulesHeader(onBack: () => Navigator.of(context).pop()),
            Expanded(
              child: AppLoading(message: context.l10n.questRulesLoading),
            ),
          ],
        ),
      );
    }

    if (state.loadState == AppLoadState.error && !state.hasRules) {
      return AppScaffold(
        scroll: false,
        body: Column(
          children: [
            QuestRulesHeader(onBack: () => Navigator.of(context).pop()),
            Expanded(
              child: AppErrorState(
                message: state.errorMessage ?? context.l10n.questRulesError,
                onRetry: pageModel.loadSettings,
              ),
            ),
          ],
        ),
      );
    }

    return AppScaffold(
      scroll: false,
      isLocked: state.isLockedPage,
      body: RefreshIndicator(
        onRefresh: pageModel.refreshSettings,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          // padding: const EdgeInsets.only(bottom: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QuestRulesHeader(onBack: () => Navigator.of(context).pop()),
              QuestRulesSummaryCard(
                totalRules: state.totalRules,
                enabledCount: state.enabledCount,
                disabledCount: state.disabledCount,
                dailyQuestLimit: state.dailyQuestLimit,
              ),
              // Global settings card
              _GlobalSettingsCard(
                difficulty: state.globalDifficulty,
                difficultyLabel: state.globalDifficultyLabel,
                autoAdjustEnabled: state.autoAdjustEnabled,
                restDayEnabled: state.restDayEnabled,
                preferredDuration: state.preferredDuration,
                preferredDurationLabel: state.preferredDurationLabel,
                isLocked: state.isLockedPage,
                onDifficultyChanged: _handleDifficultyChanged,
                onAutoAdjustToggled: _handleAutoAdjustToggled,
                onRestDayToggled: _handleRestDayToggled,
                onPreferredDurationChanged: _handlePreferredDurationChanged,
              ),
              QuestDailyLimitCard(
                value: state.dailyQuestLimit,
                isLoading: state.isLockedPage,
                onChanged: _handleDailyLimitChanged,
              ),
              // QuestTypePrioritySection(rules: state.rules),
              // const SizedBox(height: AppSpacing.s8),
              QuestRuleListSection(
                rules: state.filteredRules,
                selectedType: state.selectedType,
                isLocked: state.isLockedPage,
                onFilterChanged: pageModel.selectType,
                onEdit: _handleEditRule,
                onToggle: _handleToggleRule,
                onReset: _handleResetRules,
              ),
              const SizedBox(height: AppSpacing.s12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s16),
                child: AppButton(
                  label: context.l10n.questRulesResetDefault,
                  variant: AppButtonVariant.secondary,
                  icon: Icon(
                    RemixIcons.refresh_line,
                    size: 16,
                    color: AppColor.fg,
                  ),
                  onPressed: state.isLockedPage ? null : _handleResetRules,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleEditRule(QuestRuleModel rule) async {
    final result = await QuestRuleFormSheet.show(context, initialRule: rule);

    if (result == null || !mounted) return;

    final updated = QuestRuleModel(
      id: rule.id,
      type: rule.type,
      title: result.title,
      description: result.description,
      enabled: rule.enabled,
      difficulty: result.difficulty,
      minIntervalMinutes: result.minIntervalMinutes,
      maxPerDay: result.maxPerDay,
      activeTimeRange: result.activeTimeRange,
      activeWeekdays: result.activeWeekdays,
      priority: result.priority,
      adaptToEnergy: result.adaptToEnergy,
      adaptToStress: result.adaptToStress,
      adaptToSchedule: result.adaptToSchedule,
    );

    final success = await pageModel.updateRule(updated);
    if (!mounted) return;

    if (success) {
      AppToastService.success(context, context.l10n.questRulesToastUpdateSuccess);
    } else {
      AppToastService.error(context, context.l10n.questRulesToastUpdateFailed);
    }
  }

  Future<void> _handleToggleRule(QuestRuleModel rule, bool enabled) async {
    final success = await pageModel.toggleRule(
      ruleId: rule.id,
      enabled: enabled,
    );
    if (!mounted) return;

    if (success) {
      AppToastService.success(
        context,
        enabled
            ? context.l10n.questRulesToastToggleOn
            : context.l10n.questRulesToastToggleOff,
      );
    } else {
      AppToastService.error(context, context.l10n.questRulesToastToggleFailed);
    }
  }

  Future<void> _handleDailyLimitChanged(int value) async {
    final success = await pageModel.updateDailyLimit(value);
    if (!mounted) return;

    if (success) {
      AppToastService.success(
        context,
        context.l10n.questRulesToastDailyLimitSuccess,
      );
    } else {
      AppToastService.error(context, context.l10n.questRulesToastDailyLimitFailed);
    }
  }

  Future<void> _handleDifficultyChanged(String difficulty) async {
    final success = await pageModel.updateGlobalDifficulty(difficulty);
    if (!mounted) return;
    if (!success) {
      AppToastService.error(context, context.l10n.questRulesToastDifficultyFailed);
    }
  }

  Future<void> _handleAutoAdjustToggled(bool enabled) async {
    final success = await pageModel.toggleAutoAdjust(enabled);
    if (!mounted) return;
    if (!success) {
      AppToastService.error(context, context.l10n.questRulesToastAutoAdjustFailed);
    }
  }

  Future<void> _handleRestDayToggled(bool enabled) async {
    final success = await pageModel.toggleRestDay(enabled);
    if (!mounted) return;
    if (!success) {
      AppToastService.error(context, context.l10n.questRulesToastRestDayFailed);
    }
  }

  Future<void> _handlePreferredDurationChanged(String duration) async {
    final success = await pageModel.updatePreferredDuration(duration);
    if (!mounted) return;
    if (!success) {
      AppToastService.error(context, context.l10n.questRulesToastDurationFailed);
    }
  }

  Future<void> _handleResetRules() async {
    final confirmed = await AppConfirmDialog.show(
      context: context,
      title: context.l10n.questRulesResetConfirmTitle,
      message: context.l10n.questRulesResetConfirmMessage,
      confirmText: context.l10n.questRulesResetConfirmButton,
      confirmColor: AppColor.warn,
    );

    if (confirmed != true || !mounted) return;

    final success = await pageModel.resetToDefaultRules();
    if (!mounted) return;

    if (success) {
      AppToastService.success(context, context.l10n.questRulesToastResetSuccess);
    } else {
      AppToastService.error(context, context.l10n.questRulesToastResetFailed);
    }
  }
}

class _GlobalSettingsCard extends StatelessWidget {
  final String difficulty;
  final String difficultyLabel;
  final bool autoAdjustEnabled;
  final bool restDayEnabled;
  final String preferredDuration;
  final String preferredDurationLabel;
  final bool isLocked;
  final ValueChanged<String> onDifficultyChanged;
  final ValueChanged<bool> onAutoAdjustToggled;
  final ValueChanged<bool> onRestDayToggled;
  final ValueChanged<String> onPreferredDurationChanged;

  const _GlobalSettingsCard({
    required this.difficulty,
    required this.difficultyLabel,
    required this.autoAdjustEnabled,
    required this.restDayEnabled,
    required this.preferredDuration,
    required this.preferredDurationLabel,
    required this.isLocked,
    required this.onDifficultyChanged,
    required this.onAutoAdjustToggled,
    required this.onRestDayToggled,
    required this.onPreferredDurationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppCard(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
      ).copyWith(bottom: AppSpacing.s12),
      padding: const EdgeInsets.all(AppSpacing.s14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColor.violet.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  RemixIcons.equalizer_line,
                  size: 18,
                  color: AppColor.violet,
                ),
              ),
              const SizedBox(width: AppSpacing.s10),
              Text(
                l10n.questRulesGeneralSettings,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColor.fg,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s12),

          // Difficulty selector
          _FieldLabel(l10n.questRulesGeneralDifficulty),
          const SizedBox(height: AppSpacing.s6),
          QuestDifficultySelector(
            value: _toQuestDifficulty(difficulty),
            onChanged: (value) => onDifficultyChanged(value.name),
          ),
          const SizedBox(height: AppSpacing.s14),

          // Preferred duration
          _FieldLabel(l10n.questRulesGeneralDuration),
          const SizedBox(height: AppSpacing.s6),
          _DurationSelector(
            value: preferredDuration,
            label: preferredDurationLabel,
            onChanged: onPreferredDurationChanged,
          ),
          const SizedBox(height: AppSpacing.s14),

          // Toggles
          Opacity(
            opacity: isLocked ? 0.5 : 1.0,
            child: IgnorePointer(
              ignoring: isLocked,
              child: AppToggleRow(
                title: l10n.questRulesGeneralAutoAdjust,
                subtitle: l10n.questRulesGeneralAutoAdjustSub,
                value: autoAdjustEnabled,
                onChanged: onAutoAdjustToggled,
              ),
            ),
          ),
          Opacity(
            opacity: isLocked ? 0.5 : 1.0,
            child: IgnorePointer(
              ignoring: isLocked,
              child: AppToggleRow(
                title: l10n.questRulesGeneralRestDay,
                subtitle: l10n.questRulesGeneralRestDaySub,
                value: restDayEnabled,
                onChanged: onRestDayToggled,
              ),
            ),
          ),
        ],
      ),
    );
  }

  QuestDifficulty _toQuestDifficulty(String value) {
    return parseQuestDifficulty(value);
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: AppColor.fgSecondary,
      ),
    );
  }
}

class _DurationSelector extends StatelessWidget {
  final String value;
  final String label;
  final ValueChanged<String> onChanged;

  const _DurationSelector({
    required this.value,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: ['short', 'medium', 'long'].map((d) {
        final selected = value == d;
        String dLabel;
        switch (d) {
          case 'short':
            dLabel = l10n.questRulesGeneralDurationShort;
            break;
          case 'long':
            dLabel = l10n.questRulesGeneralDurationLong;
            break;
          default:
            dLabel = l10n.questRulesGeneralDurationMedium;
        }
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: d == 'long' ? 0 : AppSpacing.s8),
            child: GestureDetector(
              onTap: () => onChanged(d),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.s10),
                decoration: BoxDecoration(
                  color: selected ? AppColor.cyanDim : AppColor.surface,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(
                    color: selected ? AppColor.borderGlowCyan : AppColor.border,
                  ),
                ),
                child: Center(
                  child: Text(
                    dLabel,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: selected ? AppColor.cyan : AppColor.fgSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
