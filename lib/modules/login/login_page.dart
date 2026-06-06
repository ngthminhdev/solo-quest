import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../constants/app_color.dart';
import '../../constants/app_spacing.dart';
import '../../extensions/localization_extension.dart';
import 'login_page_model.dart';
import 'widgets/login_logo_section.dart';
import 'widgets/google_sign_in_button.dart';
import 'widgets/login_error_banner.dart';
import 'widgets/login_footer_note.dart';

class LoginPage extends BasePage<LoginPageModel, LoginPageState> {
  LoginPage({super.key}) : super(provider: loginPageProvider);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState
    extends BasePageConsumerState<LoginPage, LoginPageModel, LoginPageState> {
  @override
  Widget renderPage(BuildContext context) {
    final state = read;

    return Scaffold(
      backgroundColor: AppColor.bgDeep,
      body: SafeArea(
        child: Stack(
          children: [
            // Radial glow background
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.4),
                    radius: 0.8,
                    colors: [
                      AppColor.cyan.withAlpha(20),
                      AppColor.violet.withAlpha(10),
                      AppColor.transparent,
                    ],
                    stops: const [0.0, 0.4, 1.0],
                  ),
                ),
              ),
            ),

            // Content
            Positioned.fill(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.xxxl,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.vertical -
                        AppSpacing.xxxl * 2,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: AppSpacing.huge),

                      // Logo + App name
                      const LoginLogoSection(),

                      const SizedBox(height: AppSpacing.xxxl),

                      // Heading
                      Text(
                        context.l10n.loginTitle,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColor.fg,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: AppSpacing.s12),

                      // Description
                      Text(
                        context.l10n.loginSubtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColor.fgSecondary,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: AppSpacing.xl),

                      // Error banner
                      if (state.errorMessage != null)
                        LoginErrorBanner(message: state.errorMessage),

                      if (state.errorMessage != null)
                        const SizedBox(height: AppSpacing.s16),

                      // Google sign-in button
                      GoogleSignInButton(
                        isLoading: state.isLoading,
                        onPressed: _handleGoogleSignIn,
                      ),

                      if (kDebugMode) ...[
                        const SizedBox(height: AppSpacing.s12),
                        _DevLoginButton(
                          isLoading: state.isLoading,
                          onPressed: _handleDevSignIn,
                        ),
                      ],

                      const SizedBox(height: AppSpacing.xxxl),

                      // Footer notes
                      const LoginFooterNote(),

                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    final route = await pageModel.signInWithGoogle();

    if (!mounted) return;

    if (route != null) {
      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    }
  }

  Future<void> _handleDevSignIn() async {
    final route = await pageModel.signInWithDevLogin();

    if (!mounted) return;

    if (route != null) {
      Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
    }
  }
}

class _DevLoginButton extends StatelessWidget {
  const _DevLoginButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: 44,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColor.border),
        ),
        child: const Center(
          child: Text(
            'Continue with Dev Login',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColor.fg,
            ),
          ),
        ),
      ),
    );
  }
}
