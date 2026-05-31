import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../constants/app_spacing.dart';
import '../../routes/routes_config.dart';
import '../../widgets/app_scaffold/app_scaffold.dart';
import '../../widgets/app_state/app_loading.dart';
import '../../widgets/app_state/app_error_state.dart';
import '../../widgets/app_toast/app_toast_service.dart';
import 'morning_checkin_page_model.dart';
import 'constants/morning_checkin_constants.dart';
import 'widgets/morning_checkin_header.dart';
import 'widgets/checkin_step_indicator.dart';
import 'widgets/energy_selector_card.dart';
import 'widgets/stress_selector_card.dart';
import 'widgets/focus_selector_card.dart';
import 'widgets/day_intensity_selector_card.dart';
import 'widgets/main_focus_input_card.dart';
import 'widgets/available_time_blocks_card.dart';
import 'widgets/checkin_note_card.dart';
import 'widgets/checkin_submit_bar.dart';

class MorningCheckinPage
    extends BasePage<MorningCheckinPageModel, MorningCheckinPageState> {
  MorningCheckinPage({super.key}) : super(provider: morningCheckinPageProvider);

  @override
  ConsumerState<MorningCheckinPage> createState() =>
      _MorningCheckinPageState();
}

class _MorningCheckinPageState extends BasePageConsumerState<
    MorningCheckinPage, MorningCheckinPageModel, MorningCheckinPageState> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageModel.loadTodayCheckin();
    });
  }

  @override
  Widget renderPage(BuildContext context) {
    final state = read;

    if (state.loadState == AppLoadState.loading) {
      return AppScaffold(
        title: MorningCheckinConstants.pageTitle,
        body: const AppLoading(message: 'Đang tải...'),
      );
    }

    if (state.loadState == AppLoadState.error) {
      return AppScaffold(
        title: MorningCheckinConstants.pageTitle,
        body: AppErrorState(
          message: state.errorMessage ?? MorningCheckinConstants.toastFailed,
          onRetry: pageModel.loadTodayCheckin,
        ),
      );
    }

    return AppScaffold(
      scroll: false,
      bottom: CheckinSubmitBar(
        canSubmit: state.canSubmit,
        isLoading: state.isLockedPage,
        hasCheckedIn: state.hasCheckedInToday,
        onSubmit: _handleSubmit,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: AppSpacing.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MorningCheckinHeader(),
                  const SizedBox(height: AppSpacing.s14),
                  CheckinStepIndicator(
                    progress: state.requiredProgress,
                    hasCheckedIn: state.hasCheckedInToday,
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  EnergySelectorCard(
                    value: state.energyLevel,
                    onChanged: pageModel.setEnergyLevel,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  StressSelectorCard(
                    value: state.stressLevel,
                    onChanged: pageModel.setStressLevel,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  FocusSelectorCard(
                    value: state.focusLevel,
                    onChanged: pageModel.setFocusLevel,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  DayIntensitySelectorCard(
                    value: state.dayIntensity,
                    onChanged: pageModel.setDayIntensity,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  MainFocusInputCard(
                    value: state.mainFocusToday,
                    onChanged: pageModel.setMainFocusToday,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  AvailableTimeBlocksCard(
                    selectedBlocks: state.availableTimeBlocks,
                    onToggle: pageModel.toggleAvailableTimeBlock,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  CheckinNoteCard(
                    value: state.note,
                    onChanged: pageModel.setNote,
                  ),
                  const SizedBox(height: AppSpacing.s32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    final state = read;

    if (!state.canSubmit) {
      AppToastService.warning(context, MorningCheckinConstants.toastMissing);
      return;
    }

    final success = await pageModel.submitCheckin();

    if (!mounted) return;

    if (success) {
      AppToastService.success(context, MorningCheckinConstants.toastSuccess);
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesConfig.home,
        (route) => false,
      );
    } else {
      AppToastService.error(context, MorningCheckinConstants.toastFailed);
    }
  }
}
