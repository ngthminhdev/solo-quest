import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../constants/app_color.dart';
import '../../constants/app_spacing.dart';
import '../../models/quest_rule_model.dart';
import '../../widgets/app_button/app_button.dart';
import '../../widgets/app_dialog/app_confirm_dialog.dart';
import '../../widgets/app_scaffold/app_scaffold.dart';
import '../../widgets/app_state/app_error_state.dart';
import '../../widgets/app_state/app_loading.dart';
import '../../widgets/app_toast/app_toast_service.dart';
import 'constants/quest_rules_constants.dart';
import 'quest_rules_page_model.dart';
import 'widgets/quest_daily_limit_card.dart';
import 'widgets/quest_rule_form_sheet.dart';
import 'widgets/quest_rule_list_section.dart';
import 'widgets/quest_rules_header.dart';
import 'widgets/quest_rules_summary_card.dart';
import 'widgets/quest_type_priority_section.dart';

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
      pageModel.loadRules();
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
            const Expanded(
              child: AppLoading(message: 'Đang tải luật tạo quest...'),
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
                message: state.errorMessage ?? 'Không thể tải luật tạo quest',
                onRetry: pageModel.loadRules,
              ),
            ),
          ],
        ),
      );
    }

    return AppScaffold(
      scroll: false,
      body: RefreshIndicator(
        onRefresh: pageModel.refreshRules,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 80),
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
              QuestDailyLimitCard(
                value: state.dailyQuestLimit,
                isLoading: state.isLockedPage,
                onChanged: _handleDailyLimitChanged,
              ),
              QuestTypePrioritySection(rules: state.rules),
              const SizedBox(height: AppSpacing.s8),
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
                  label: 'Khôi phục mặc định',
                  variant: AppButtonVariant.secondary,
                  icon: const Icon(
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
      AppToastService.success(context, QuestRulesConstants.toastUpdateSuccess);
    } else {
      AppToastService.error(context, QuestRulesConstants.toastUpdateFailed);
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
            ? QuestRulesConstants.toastToggleOn
            : QuestRulesConstants.toastToggleOff,
      );
    } else {
      AppToastService.error(context, QuestRulesConstants.toastToggleFailed);
    }
  }

  Future<void> _handleDailyLimitChanged(int value) async {
    final success = await pageModel.updateDailyLimit(value);
    if (!mounted) return;

    if (success) {
      AppToastService.success(
        context,
        QuestRulesConstants.toastDailyLimitSuccess,
      );
    } else {
      AppToastService.error(context, QuestRulesConstants.toastDailyLimitFailed);
    }
  }

  Future<void> _handleResetRules() async {
    final confirmed = await AppConfirmDialog.show(
      context: context,
      title: 'Khôi phục luật mặc định?',
      message:
          'Các tuỳ chỉnh hiện tại sẽ được thay bằng bộ luật mặc định của SoloQuest.',
      confirmText: 'Khôi phục',
      confirmColor: AppColor.warn,
    );

    if (confirmed != true || !mounted) return;

    final success = await pageModel.resetToDefaultRules();
    if (!mounted) return;

    if (success) {
      AppToastService.success(context, QuestRulesConstants.toastResetSuccess);
    } else {
      AppToastService.error(context, QuestRulesConstants.toastResetFailed);
    }
  }
}
