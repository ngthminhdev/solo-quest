import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../constants/app_color.dart';
import '../../constants/app_radius.dart';
import '../../extensions/localization_extension.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../routes/routes_config.dart';
import '../../widgets/app_toast/app_toast_service.dart';
import 'onboarding_page_model.dart';
import 'widgets/onboarding_progress_header.dart';
import 'widgets/onboarding_step_container.dart';
import 'widgets/onboarding_bottom_bar.dart';
import 'widgets/onboarding_welcome_step.dart';
import 'widgets/onboarding_basic_info_step.dart';
import 'widgets/onboarding_work_study_step.dart';
import 'widgets/onboarding_health_activity_step.dart';
import 'widgets/onboarding_goals_step.dart';
import 'widgets/onboarding_schedule_step.dart';
import 'widgets/onboarding_complete_step.dart';

class OnboardingPage
    extends BasePage<OnboardingPageModel, OnboardingPageState> {
  OnboardingPage({super.key}) : super(provider: onboardingPageProvider);

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState
    extends
        BasePageConsumerState<
          OnboardingPage,
          OnboardingPageModel,
          OnboardingPageState
        > {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageModel.prefillFromProfile();
    });
  }

  @override
  Widget renderPage(BuildContext context) {
    final l10n = context.l10n;
    final state = read;

    return Scaffold(
      backgroundColor: AppColor.bgDeep,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                OnboardingProgressHeader(
                  currentStep: state.currentStep,
                  totalSteps: state.totalSteps,
                  progress: state.progress,
                ),
                Expanded(
                  child: state.currentStep == 0
                      ? OnboardingWelcomeStep(data: state.data)
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight - 24,
                                ),
                                child: OnboardingStepContainer(
                                  child: _buildStep(state),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                OnboardingBottomBar(
                  currentStep: state.currentStep,
                  canGoBack: !state.isFirstStep,
                  canContinue: state.canContinue,
                  isLastStep: state.isLastStep,
                  isLoading: state.isLockedPage || state.isGeneratingQuests,
                  onBack: pageModel.previousStep,
                  onNext: _handleNextOrFinish,
                ),
              ],
            ),
            if (state.isGeneratingQuests)
              _buildGeneratingOverlay(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneratingOverlay(AppLocalizations l10n) {
    return Container(
      color: AppColor.overlay,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 48),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColor.surfaceElevated,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            border: Border.all(color: AppColor.borderGlowCyan),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColor.cyan,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.onboardingGeneratingQuestsTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColor.fg,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.onboardingGeneratingQuestsSubtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColor.fgSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(OnboardingPageState state) {
    switch (state.currentStep) {
      case 1:
        return OnboardingBasicInfoStep(
          data: state.data,
          onDisplayNameChanged: pageModel.updateDisplayName,
          onAgeChanged: pageModel.updateAge,
          onGenderChanged: pageModel.updateGender,
          onHeightChanged: pageModel.updateHeight,
          onWeightChanged: pageModel.updateWeight,
        );
      case 2:
        return OnboardingWorkStudyStep(
          data: state.data,
          onMainActivityChanged: pageModel.updateMainActivity,
          onWorkScheduleChanged: pageModel.updateWorkScheduleType,
          onWorkStartTimeChanged: pageModel.updateWorkStartTime,
          onWorkEndTimeChanged: pageModel.updateWorkEndTime,
          onFreeTimeToggled: pageModel.togglePreferredFreeTime,
        );
      case 3:
        return OnboardingHealthActivityStep(
          data: state.data,
          onActivityLevelChanged: pageModel.updateActivityLevel,
          onLastWorkoutChanged: pageModel.updateLastWorkout,
          onLimitationToggled: pageModel.toggleHealthLimitation,
        );
      case 4:
        return OnboardingGoalsStep(
          data: state.data,
          onGoalToggled: pageModel.toggleMainGoal,
        );
      case 5:
        return OnboardingScheduleStep(
          data: state.data,
          onWakeUpChanged: pageModel.updateWakeUpTime,
          onTargetSleepChanged: pageModel.updateTargetSleepTime,
          onFreeTimeStartChanged: pageModel.updateFreeTimeStart,
          onFreeTimeEndChanged: pageModel.updateFreeTimeEnd,
          onLearningTimeToggled: pageModel.toggleLearningTimePreference,
          onMovementTimeToggled: pageModel.toggleMovementTimePreference,
        );
      case 6:
        return OnboardingCompleteStep(data: state.data);
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _handleNextOrFinish() async {
    final l10n = context.l10n;

    if (!read.canContinue) {
      AppToastService.warning(context, l10n.onboardingValidation);
      return;
    }

    if (!read.isLastStep) {
      pageModel.nextStep();
      return;
    }

    // Prevent double-submit while saving or generating
    if (read.isLockedPage || read.isGeneratingQuests) return;

    final success = await pageModel.completeOnboarding();

    if (!mounted) return;

    if (success) {
      _navigateHome(l10n);
    } else {
      AppToastService.error(
        context,
        read.errorMessage ?? l10n.onboardingCompleteError,
      );
    }
  }

  void _navigateHome(AppLocalizations l10n) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesConfig.home,
      (route) => false,
    );

    // Show fallback message after navigation if generate-today failed
    if (read.postOnboardingFallbackMessage != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          AppToastService.info(context, l10n.onboardingGenerateQuestsFallbackMessage);
        }
      });
    }
  }
}
