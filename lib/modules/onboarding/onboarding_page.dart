import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../constants/app_color.dart';
import '../../extensions/localization_extension.dart';
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
    final state = read;

    return Scaffold(
      backgroundColor: AppColor.bgDeep,
      body: SafeArea(
        child: Column(
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
              isLoading: state.isLockedPage,
              onBack: pageModel.previousStep,
              onNext: _handleNextOrFinish,
            ),
          ],
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
    final state = read;
    final l10n = context.l10n;

    if (!state.canContinue) {
      AppToastService.warning(context, l10n.onboardingValidation);
      return;
    }

    if (!state.isLastStep) {
      pageModel.nextStep();
      return;
    }

    final success = await pageModel.completeOnboarding();

    if (!mounted) return;

    if (success) {
      AppToastService.success(context, l10n.onboardingComplete);

      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesConfig.morningCheckin,
        (route) => false,
      );
    } else {
      AppToastService.error(
        context,
        read.errorMessage ?? l10n.onboardingCompleteError,
      );
    }
  }
}
