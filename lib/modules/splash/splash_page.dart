import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import 'package:remixicon/remixicon.dart';

import '../../constants/app_color.dart';
import '../../constants/app_constant.dart';
import '../../routes/routes_config.dart';
import '../../services/auth_service.dart';
import '../../services/daily_checkin_service.dart';
import '../../services/local_storage_service.dart';
import '../../services/service_providers.dart';

class SplashPageState extends BasePageState {
  final AppLoadState loadState;

  SplashPageState({
    this.loadState = AppLoadState.idle,
    super.isLockedPage,
  });

  @override
  SplashPageState updateState({
    AppLoadState? loadState,
    bool? isLockedPage,
  }) {
    return SplashPageState(
      loadState: loadState ?? this.loadState,
      isLockedPage: isLockedPage ?? this.isLockedPage,
    );
  }
}

class SplashPageModel extends BasePageModel<SplashPageState> {
  SplashPageModel({
    required this.localStorageService,
    required this.dailyCheckinService,
    required this.authService,
  }) : super(SplashPageState());

  final LocalStorageService localStorageService;
  final DailyCheckinService dailyCheckinService;
  final AuthService authService;

  Future<String> resolveInitialRoute() async {
    final authenticated = await authService.isAuthenticated();

    if (!authenticated) {
      return RoutesConfig.login;
    }

    final completed = await localStorageService.getBool(
      AppStorageKey.hasCompletedOnboarding,
    );

    if (completed != true) {
      return RoutesConfig.onboarding;
    }

    final checkedIn = await dailyCheckinService.hasCheckedInToday();

    if (!checkedIn) {
      return RoutesConfig.morningCheckin;
    }

    return RoutesConfig.home;
  }

  Future<void> initialize() async {
    state = state.updateState(loadState: AppLoadState.loading);

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      state = state.updateState(loadState: AppLoadState.ready);
    } catch (e) {
      state = state.updateState(loadState: AppLoadState.error);
    }
  }
}

final splashPageProvider =
    StateNotifierProvider<SplashPageModel, SplashPageState>((ref) {
  return SplashPageModel(
    localStorageService: ref.read(localStorageServiceProvider),
    dailyCheckinService: ref.read(dailyCheckinServiceProvider),
    authService: ref.read(authServiceProvider),
  );
});

class SplashPage extends BasePage<SplashPageModel, SplashPageState> {
  SplashPage({super.key}) : super(provider: splashPageProvider);

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState
    extends BasePageConsumerState<SplashPage, SplashPageModel, SplashPageState> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await pageModel.initialize();
    });
  }

  @override
  void onBuild() {
    listen((previous, next) async {
      if (next.loadState == AppLoadState.ready) {
        final route = await pageModel.resolveInitialRoute();
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(route);
        }
      }
    });
  }

  @override
  Widget renderPage(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgDeep,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColor.levelGradient,
              ),
              child: const Icon(
                RemixIcons.star_fill,
                size: 32,
                color: AppColor.bgDeep,
              ),
            ),
            const SizedBox(height: 24),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColor.cyan, AppColor.violet],
              ).createShader(bounds),
              child: const Text(
                'SoloQuest',
                style: TextStyle(
                  fontFamily: 'Exo2',
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColor.cyan,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
