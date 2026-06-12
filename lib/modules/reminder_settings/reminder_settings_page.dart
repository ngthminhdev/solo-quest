import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../constants/app_spacing.dart';
import '../../models/reminder_setting_model.dart';
import '../../widgets/app_scaffold/app_scaffold.dart';
import '../../widgets/app_state/app_error_state.dart';
import '../../widgets/app_state/app_loading.dart';
import '../../widgets/app_toast/app_toast_service.dart';
import '../../extensions/localization_extension.dart';
import 'reminder_settings_page_model.dart';
import 'widgets/reminder_list_section.dart';
import 'widgets/reminder_setting_form_sheet.dart';
import 'widgets/reminder_settings_header.dart';
import 'widgets/reminder_summary_card.dart';

class ReminderSettingsPage
    extends BasePage<ReminderSettingsPageModel, ReminderSettingsPageState> {
  ReminderSettingsPage({super.key})
    : super(provider: reminderSettingsPageProvider);

  @override
  ConsumerState<ReminderSettingsPage> createState() =>
      _ReminderSettingsPageState();
}

class _ReminderSettingsPageState
    extends
        BasePageConsumerState<
          ReminderSettingsPage,
          ReminderSettingsPageModel,
          ReminderSettingsPageState
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

    if (state.loadState == AppLoadState.loading && !state.hasSettings) {
      return AppScaffold(
        scroll: false,
        body: Column(
          children: [
            ReminderSettingsHeader(onBack: () => Navigator.of(context).pop()),
            Expanded(
              child: AppLoading(message: context.l10n.reminderSettingsLoading),
            ),
          ],
        ),
      );
    }

    if (state.loadState == AppLoadState.error && !state.hasSettings) {
      return AppScaffold(
        scroll: false,
        body: Column(
          children: [
            ReminderSettingsHeader(onBack: () => Navigator.of(context).pop()),
            Expanded(
              child: AppErrorState(
                message:
                    state.errorMessage ?? context.l10n.reminderSettingsError,
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
          padding: const EdgeInsets.only(bottom: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReminderSettingsHeader(onBack: () => Navigator.of(context).pop()),
              ReminderSummaryCard(
                totalSettings: state.totalSettings,
                enabledCount: state.enabledCount,
                disabledCount: state.disabledCount,
              ),
              const SizedBox(height: AppSpacing.s20),
              ReminderListSection(
                settings: state.filteredSettings,
                selectedType: state.selectedType,
                isLocked: state.isLockedPage,
                onFilterChanged: pageModel.selectType,
                onEdit: _handleEditSetting,
                onToggle: _handleToggleSetting,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleEditSetting(ReminderSettingModel setting) async {
    final result = await ReminderSettingFormSheet.show(
      context,
      initialSetting: setting,
    );

    if (result == null || !mounted) return;

    // Build directly instead of copyWith: the form's nullable fields
    // (maxPerDay, interval, time range) must be able to clear a previous
    // value. copyWith collapses null back to the old value (`x ?? this.x`),
    // so clearing the daily cap would never take effect.
    final updated = ReminderSettingModel(
      id: setting.id,
      type: setting.type,
      title: setting.title,
      description: setting.description,
      status: setting.status,
      frequency: result.frequency,
      startTime: result.startTime,
      endTime: result.endTime,
      intervalMinutes: result.intervalMinutes,
      maxPerDay: result.maxPerDay,
      smartEnabled: result.smartEnabled,
    );

    final success = await pageModel.updateSetting(updated);
    if (!mounted) return;

    if (success) {
      AppToastService.success(
        context,
        context.l10n.reminderSettingsToastUpdateSuccess,
      );
    } else {
      AppToastService.error(
        context,
        context.l10n.reminderSettingsToastUpdateFailed,
      );
    }
  }

  Future<void> _handleToggleSetting(
    ReminderSettingModel setting,
    bool enabled,
  ) async {
    final success = await pageModel.toggleReminder(
      type: setting.type,
      enabled: enabled,
    );
    if (!mounted) return;

    if (success) {
      AppToastService.success(
        context,
        enabled
            ? context.l10n.reminderSettingsToastToggleOn
            : context.l10n.reminderSettingsToastToggleOff,
      );
    } else {
      AppToastService.error(
        context,
        context.l10n.reminderSettingsToastToggleFailed,
      );
    }
  }
}
