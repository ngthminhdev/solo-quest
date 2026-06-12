import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;

import '../../base/app_load_state.dart';
import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../constants/app_spacing.dart';
import '../../routes/routes_config.dart';
import '../../widgets/app_scaffold/app_scaffold.dart';
import '../../widgets/app_state/app_loading.dart';
import '../../widgets/app_state/app_error_state.dart';
import '../../widgets/app_toast/app_toast_service.dart';
import '../profile/profile_page_model.dart';
import 'morning_checkin_page_model.dart';
import '../../extensions/localization_extension.dart';
import 'widgets/morning_checkin_header.dart';
import 'widgets/checkin_step_indicator.dart';
import 'widgets/mood_selector_card.dart';
import 'widgets/energy_selector_card.dart';
import 'widgets/availability_selector_card.dart';
import 'widgets/priority_selector_card.dart';
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
  Widget build(BuildContext context) {
    return super.build(context);
  }

  @override
  Widget renderPage(BuildContext context) {
    final state = read;

    if (state.loadState == AppLoadState.loading) {
      return AppScaffold(
        title: context.l10n.morningCheckinPageTitle,
        body: AppLoading(message: context.l10n.morningCheckinLoading),
      );
    }

    if (state.loadState == AppLoadState.error) {
      return AppScaffold(
        title: context.l10n.morningCheckinPageTitle,
        body: AppErrorState(
          message: state.errorMessage ?? context.l10n.morningCheckinToastFailed,
          onRetry: pageModel.loadTodayCheckin,
        ),
      );
    }

    return AppScaffold(
      scroll: false,
      isLocked: state.isLockedPage,
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
                  MoodSelectorCard(
                    value: state.mood,
                    onChanged: pageModel.setMood,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  EnergySelectorCard(
                    value: state.energyLevel,
                    onChanged: pageModel.setEnergyLevel,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  AvailabilitySelectorCard(
                    value: state.availability,
                    onChanged: pageModel.setAvailability,
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  PrioritySelectorCard(
                    value: state.priority,
                    onChanged: pageModel.setPriority,
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
    developer.log('[CHECKIN PAGE] _handleSubmit called');
    final state = read;
    developer.log('[CHECKIN PAGE] canSubmit: ${state.canSubmit}, isLockedPage: ${state.isLockedPage}');

    if (!state.canSubmit) {
      developer.log('[CHECKIN PAGE] Cannot submit - showing warning toast');
      AppToastService.warning(context, context.l10n.morningCheckinToastMissing);
      return;
    }

    developer.log('[CHECKIN PAGE] Calling submitCheckin()');
    final success = await pageModel.submitCheckin();
    developer.log('[CHECKIN PAGE] submitCheckin() returned: $success');

    if (!mounted) return;

    if (success) {
      // Invalidate profile provider to refresh hasCheckedInToday status
      ref.invalidate(profilePageProvider);

      developer.log('[CHECKIN PAGE] Showing success toast');
      AppToastService.success(context, context.l10n.morningCheckinToastSuccess);

      // Wait for toast animation to start before navigating
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      developer.log('[CHECKIN PAGE] Navigating back');
      if (Navigator.of(context).canPop()) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(context, RoutesConfig.home);
      }
    } else {
      developer.log('[CHECKIN PAGE] Showing error toast');
      AppToastService.error(context, context.l10n.morningCheckinToastFailed);
    }
  }
}
