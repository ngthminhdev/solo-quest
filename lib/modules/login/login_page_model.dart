import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import '../../models/auth_user_model.dart';
import '../../services/auth_exceptions.dart';
import '../../services/auth_service.dart';
import '../../services/auth_session_resolver.dart';
import '../../services/service_providers.dart';
import '../../core/notifications/fcm_service.dart';

class LoginPageState extends BasePageState {
  final AppLoadState loadState;
  final AuthUserModel? user;
  final String? errorMessage;

  LoginPageState({
    this.loadState = AppLoadState.idle,
    this.user,
    this.errorMessage,
    super.isLockedPage,
  });

  @override
  LoginPageState updateState({
    AppLoadState? loadState,
    AuthUserModel? user,
    String? errorMessage,
    bool clearError = false,
    bool? isLockedPage,
  }) {
    return LoginPageState(
      loadState: loadState ?? this.loadState,
      user: user ?? this.user,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      isLockedPage: isLockedPage ?? this.isLockedPage,
    );
  }

  bool get isLoading => loadState == AppLoadState.loading || isLockedPage;
}

class LoginPageModel extends BasePageModel<LoginPageState> {
  LoginPageModel({
    required this.authService,
    required this.sessionResolver,
    required this.fcmService,
  }) : super(LoginPageState());

  final AuthService authService;
  final AuthSessionResolver sessionResolver;
  final FcmService fcmService;

  Future<String?> signInWithGoogle() async {
    if (kDebugMode) {
      developer.log('[AUTH] Google login tapped');
    }

    state = state.updateState(
      loadState: AppLoadState.loading,
      isLockedPage: true,
      clearError: true,
    );

    try {
      final user = await authService.signInWithGoogle();
      return _finishSuccessfulLogin(user);
    } on AuthException catch (e, st) {
      if (e.code == AuthExceptionCode.googleCancelled) {
        if (kDebugMode) {
          developer.log(
            '[AUTH] Google login cancelled: type=${e.runtimeType}, message=${e.message}',
          );
        }
        state = state.updateState(
          loadState: AppLoadState.error,
          errorMessage: e.message,
          isLockedPage: false,
        );
        return null;
      }

      if (kDebugMode) {
        developer.log(
          '[AUTH] Google login failed: type=${e.runtimeType}, code=${e.code}, message=${e.message}',
        );
        developer.log('[AUTH] StackTrace:\n$st');
      }
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage: e.message,
        isLockedPage: false,
      );
      return null;
    } catch (e, st) {
      if (kDebugMode) {
        developer.log('[AUTH] Google login failed: type=${e.runtimeType}, message=$e');
        developer.log('[AUTH] StackTrace:\n$st');
      }
      state = state.updateState(
        loadState: AppLoadState.error,
        isLockedPage: false,
      );
      return null;
    }
  }

  Future<String?> signInWithDevLogin() async {
    if (kDebugMode) {
      developer.log('[AUTH] Dev login tapped');
    }

    state = state.updateState(
      loadState: AppLoadState.loading,
      isLockedPage: true,
      clearError: true,
    );

    try {
      final user = await authService.signInWithDevLogin();
      return _finishSuccessfulLogin(user);
    } catch (e) {
      if (kDebugMode) {
        developer.log('[AUTH] Dev login failed: $e');
      }
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage:
            'Cannot login with dev user. Please check backend dev user bootstrap.',
        isLockedPage: false,
      );
      return null;
    }
  }

  Future<String> _finishSuccessfulLogin(AuthUserModel user) async {
    if (kDebugMode) {
      developer.log('[AUTH] Login success, resolving post-login route...');
    }

    state = state.updateState(
      loadState: AppLoadState.ready,
      user: user,
      isLockedPage: false,
    );

    // Initialize FCM on successful login
    fcmService.initialize().then((_) {
      fcmService.processPendingNotificationPayload();
    }).catchError((e) {
      if (kDebugMode) {
        developer.log('[AUTH] FCM initialization error: $e');
      }
    });

    final route = await sessionResolver.resolveInitialRoute();

    if (kDebugMode) {
      developer.log('[AUTH] Navigating to: $route');
    }

    return route;
  }
}

final loginPageProvider = StateNotifierProvider<LoginPageModel, LoginPageState>(
  (ref) {
    return LoginPageModel(
      authService: ref.read(authServiceProvider),
      sessionResolver: ref.read(authSessionResolverProvider),
      fcmService: ref.read(fcmServiceProvider),
    );
  },
);
