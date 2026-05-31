import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../constants/app_color.dart';
import '../../extensions/localization_extension.dart';
import '../../models/reward_model.dart';
import '../../widgets/app_scaffold/app_scaffold.dart';
import '../../widgets/app_state/app_loading.dart';
import '../../widgets/app_state/app_error_state.dart';
import '../../widgets/app_toast/app_toast_service.dart';
import 'rewards_page_model.dart';
import 'widgets/reward_wallet_card.dart';
import 'widgets/rewards_scroll_section.dart';
import 'widgets/badge_showcase.dart';
import 'widgets/reward_history_list.dart';
import 'widgets/protection_banner.dart';
import 'widgets/reward_create_section.dart';
import 'widgets/rewards_empty_view.dart';

class RewardsPage extends BasePage<RewardsPageModel, RewardsPageState> {
  RewardsPage({super.key}) : super(provider: rewardsPageProvider);

  @override
  ConsumerState<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState
    extends BasePageConsumerState<RewardsPage, RewardsPageModel, RewardsPageState> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageModel.loadRewards();
    });
  }

  @override
  void onBuild() {
    listen((previous, next) {
      if (previous?.loadState == AppLoadState.loading &&
          next.loadState == AppLoadState.error &&
          next.errorMessage != null) {
        AppToastService.error(context, next.errorMessage!);
      }
    });
  }

  @override
  Widget renderPage(BuildContext context) {
    final state = read;

    if (state.loadState == AppLoadState.loading && state.rewards.isEmpty) {
      return AppScaffold(
        showBottomNav: false,
        body: AppLoading(message: context.l10n.rewardsLoading),
      );
    }

    if (state.loadState == AppLoadState.error && state.rewards.isEmpty) {
      return AppScaffold(
        showBottomNav: false,
        body: AppErrorState(
          message: state.errorMessage ?? context.l10n.rewardsError,
          onRetry: pageModel.loadRewards,
        ),
      );
    }

    if (!state.hasRewards && state.loadState == AppLoadState.ready) {
      return AppScaffold(
        showBottomNav: false,
        body: const RewardsEmptyView(),
      );
    }

    return AppScaffold(
      showBottomNav: false,
      scroll: false,
      body: RefreshIndicator(
        color: AppColor.cyan,
        backgroundColor: AppColor.bgRaised,
        onRefresh: pageModel.refreshRewards,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wallet
              RewardWalletCard(
                availablePoints: state.availablePoints,
                weeklyEarned: 120,
                claimedCount: state.claimedRewardCount,
                badgeCount: 5,
                exp: state.progress?.totalExp ?? 0,
                nextLevelExp: state.progress?.nextLevelExp ?? 0,
              ),

              // Rewards scroll
              RewardsScrollSection(
                rewards: state.rewards,
                availablePoints: state.availablePoints,
                onClaim: _handleClaimReward,
              ),

              // Badges
              const BadgeShowcase(),

              // Create reward
              const RewardCreateSection(),

              // History
              const RewardHistoryList(),

              // Protection
              const ProtectionBanner(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleClaimReward(RewardModel reward) async {
    final state = read;

    if (!state.canClaim(reward)) {
      AppToastService.warning(context, context.l10n.rewardsNotEnough);
      return;
    }

    final success = await pageModel.claimReward(reward.id);
    if (mounted) {
      if (success) {
        AppToastService.success(context, context.l10n.rewardsClaimed);
      } else {
        AppToastService.error(context, context.l10n.rewardsClaimFailed);
      }
    }
  }
}
