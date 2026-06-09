import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../constants/app_color.dart';
import '../../constants/app_spacing.dart';
import '../../extensions/localization_extension.dart';
import '../../routes/routes_config.dart';
import '../../widgets/skeleton/skeleton_profile_page.dart';
import '../../widgets/app_dialog/app_confirm_dialog.dart';
import '../../widgets/app_toast/app_toast_service.dart';
import '../main/main_page_model.dart';
import 'profile_page_model.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/profile_quick_actions_section.dart';
import 'widgets/profile_account_card.dart';
import 'widgets/profile_settings_section.dart';
import 'widgets/profile_empty_view.dart';

class ProfilePage extends BasePage<ProfilePageModel, ProfilePageState> {
  ProfilePage({super.key}) : super(provider: profilePageProvider);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState
    extends
        BasePageConsumerState<ProfilePage, ProfilePageModel, ProfilePageState> {
  static const _tabIndex = 4;
  bool _settleListenerSet = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryLoadIfSettled();
    });
  }

  void _tryLoadIfSettled() {
    final settled = ref.read(mainPageProvider.select((s) => s.settledIndex));
    if (settled == _tabIndex) {
      pageModel.loadProfile();
    }
  }

  @override
  void onBuild() {
    if (!_settleListenerSet) {
      _settleListenerSet = true;
      ref.listen(mainPageProvider.select((s) => s.settledIndex), (prev, next) {
        if (next == _tabIndex && prev != _tabIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            pageModel.loadProfile();
          });
        }
      });
    }
  }

  @override
  Widget renderPage(BuildContext context) {
    final state = read;

    if (state.loadState == AppLoadState.loading && !state.hasProfile) {
      return const SkeletonProfilePage();
    }

    if (state.loadState == AppLoadState.error || !state.hasProfile) {
      return state.hasProfile
          ? _buildContent(state)
          : ProfileEmptyView(onRetry: pageModel.loadProfile);
    }

    return RefreshIndicator(
      onRefresh: pageModel.refreshProfile,
      child: _buildContent(state),
    );
  }

  Widget _buildContent(ProfilePageState state) {
    final profile = state.profile!;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: AppSpacing.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          ProfileHeaderCard(
            profile: profile,
            level: state.level,
            streakDays: state.streakDays,
            provider: state.authUser?.provider,
          ),

          // const SizedBox(height: AppSpacing.s20),

          // Main Goals
          // ProfileGoalSection(
          //   goals: profile.mainGoals,
          //   onSetupGoals: _goToLearningGoals,
          // ),
          const SizedBox(height: AppSpacing.s20),

          // Quick Actions
          ProfileQuickActionsSection(
            hasCheckedInToday: state.hasCheckedInToday,
            hasReviewedToday: state.hasReviewedToday,
            onMorningCheckinTap: _goToMorningCheckin,
            onDailyReviewTap: _goToDailyReview,
          ),

          const SizedBox(height: AppSpacing.s20),

          // Settings
          ProfileSettingsSection(
            onScheduleTap: _goToScheduleEditor,
            onLearningGoalsTap: _goToLearningGoals,
            onLearningRoadmapTap: _goToLearningRoadmap,
            onReminderSettingsTap: _goToReminderSettings,
            onQuestRulesTap: _goToQuestRules,
          ),

          const SizedBox(height: AppSpacing.s20),

          // Account
          ProfileAccountCard(
            isLoading: state.isLockedPage,
            onSignOut: _handleSignOut,
          ),
        ],
      ),
    );
  }

  void _goToMorningCheckin() {
    Navigator.pushNamed(context, RoutesConfig.morningCheckin);
  }

  void _goToDailyReview() {
    Navigator.pushNamed(context, RoutesConfig.dailyReview);
  }

  void _goToScheduleEditor() {
    Navigator.pushNamed(context, RoutesConfig.scheduleEditor);
  }

  void _goToReminderSettings() {
    Navigator.pushNamed(context, RoutesConfig.reminderSettings);
  }

  void _goToQuestRules() {
    Navigator.pushNamed(context, RoutesConfig.questRules);
  }

  void _goToLearningGoals() {
    Navigator.pushNamed(context, RoutesConfig.learningGoals);
  }

  void _goToLearningRoadmap() {
    Navigator.pushNamed(context, RoutesConfig.learningRoadmap);
  }

  Future<void> _handleSignOut() async {
    final l10n = context.l10n;

    final confirmed = await AppConfirmDialog.show(
      context: context,
      title: l10n.profileSignOutTitle,
      message: l10n.profileSignOutMessage,
      confirmText: l10n.profileSignOut,
      cancelText: l10n.commonCancel,
      confirmColor: AppColor.danger,
    );

    if (confirmed != true) return;

    final success = await pageModel.signOut();

    if (!mounted) return;

    if (success) {
      AppToastService.success(context, l10n.profileSignOutSuccess);

      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesConfig.login,
        (route) => false,
      );
    } else {
      AppToastService.error(
        context,
        read.errorMessage ?? l10n.profileSignOutError,
      );
    }
  }
}
