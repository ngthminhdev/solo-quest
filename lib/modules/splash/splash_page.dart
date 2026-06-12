import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page.dart';
import '../../base/base_page_consumer_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';

import '../../constants/app_color.dart';
import '../../services/auth_session_resolver.dart';
import '../../services/service_providers.dart';
import '../../core/notifications/fcm_service.dart';
import '../../routes/routes_config.dart';

class SplashPageState extends BasePageState {
  final AppLoadState loadState;

  SplashPageState({this.loadState = AppLoadState.idle, super.isLockedPage});

  @override
  SplashPageState updateState({AppLoadState? loadState, bool? isLockedPage}) {
    return SplashPageState(
      loadState: loadState ?? this.loadState,
      isLockedPage: isLockedPage ?? this.isLockedPage,
    );
  }
}

class SplashPageModel extends BasePageModel<SplashPageState> {
  SplashPageModel({
    required this.sessionResolver,
    required this.fcmService,
  }) : super(SplashPageState());

  final AuthSessionResolver sessionResolver;
  final FcmService fcmService;

  Future<String> resolveInitialRoute() async {
    if (kDebugMode) {
      developer.log('[SPLASH] Checking stored session...');
    }

    final route = await sessionResolver.resolveInitialRoute();
    if (route != RoutesConfig.login) {
      fcmService.initialize().then((_) {
        fcmService.processPendingNotificationPayload();
      }).catchError((e) {
        if (kDebugMode) {
          developer.log('[SPLASH] FCM initialization error: $e');
        }
      });
    }
    return route;
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
        sessionResolver: ref.read(authSessionResolverProvider),
        fcmService: ref.read(fcmServiceProvider),
      );
    });

class SplashPage extends BasePage<SplashPageModel, SplashPageState> {
  SplashPage({super.key}) : super(provider: splashPageProvider);

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState
    extends
        BasePageConsumerState<SplashPage, SplashPageModel, SplashPageState> {
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
                color: AppColor.bgDeep,
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/icons/app_icon_foreground.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 24),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [AppColor.cyan, AppColor.violet],
              ).createShader(bounds),
              child: Text(
                'SoloQuest',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColor.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
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
