import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../constants/app_color.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_text_style.dart';
import '../../extensions/localization_extension.dart';
import '../../routes/routes_config.dart';
import 'welcome_page_model.dart';
import 'widgets/welcome_hero_card.dart';
import 'widgets/welcome_feature_list.dart';
import 'widgets/welcome_action_bar.dart';

class WelcomePage extends BasePage<WelcomePageModel, WelcomePageState> {
  WelcomePage({super.key}) : super(provider: welcomePageProvider);

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState
    extends BasePageConsumerState<WelcomePage, WelcomePageModel, WelcomePageState> {
  @override
  Widget renderPage(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: AppColor.bgDeep,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.xxxl,
          ),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.huge),

              // Hero
              const WelcomeHeroCard(),

              const SizedBox(height: AppSpacing.xl),

              // Subtitle
              Text(
                l10n.welcomeSubtitle,
                style: AppTextStyle.body.copyWith(
                  color: AppColor.fgSecondary,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.xl),

              // System message
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColor.cyanDim,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColor.borderGlowCyan),
                ),
                child: Text(
                  l10n.welcomeSystemMessage,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.cyan,
                    height: 1.6,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Feature list
              const WelcomeFeatureList(),

              const SizedBox(height: AppSpacing.xxl),

              // Action bar
              WelcomeActionBar(
                onStart: () {
                  Navigator.pushNamed(context, RoutesConfig.onboarding);
                },
                onSkip: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RoutesConfig.home,
                    (route) => false,
                  );
                },
              ),

              const SizedBox(height: AppSpacing.lg),

              // Version
              Text(
                l10n.welcomeVersionTag,
                style: AppTextStyle.monoLabel.copyWith(
                  color: AppColor.fgMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
