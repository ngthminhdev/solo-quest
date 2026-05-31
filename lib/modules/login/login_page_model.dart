import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import '../../constants/app_constant.dart';
import '../../models/auth_user_model.dart';
import '../../routes/routes_config.dart';
import '../../services/auth_service.dart';
import '../../services/daily_checkin_service.dart';
import '../../services/local_storage_service.dart';
import '../../services/service_providers.dart';

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
    required this.localStorageService,
    required this.dailyCheckinService,
  }) : super(LoginPageState());

  final AuthService authService;
  final LocalStorageService localStorageService;
  final DailyCheckinService dailyCheckinService;

  Future<String?> signInWithGoogle() async {
    state = state.updateState(
      loadState: AppLoadState.loading,
      isLockedPage: true,
      clearError: true,
    );

    try {
      final user = await authService.signInWithGoogleMock();
      state = state.updateState(
        loadState: AppLoadState.ready,
        user: user,
        isLockedPage: false,
      );
      return resolvePostLoginRoute();
    } catch (_) {
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage: 'Không thể đăng nhập bằng Google. Vui lòng thử lại.',
        isLockedPage: false,
      );
      return null;
    }
  }

  Future<String> resolvePostLoginRoute() async {
    final onboardingDone =
        await localStorageService.getBool(AppStorageKey.hasCompletedOnboarding) ==
            true;

    if (!onboardingDone) {
      return RoutesConfig.onboarding;
    }

    final checkedIn = await dailyCheckinService.hasCheckedInToday();

    if (!checkedIn) {
      return RoutesConfig.morningCheckin;
    }

    return RoutesConfig.home;
  }
}

final loginPageProvider =
    StateNotifierProvider<LoginPageModel, LoginPageState>((ref) {
  return LoginPageModel(
    authService: ref.read(authServiceProvider),
    localStorageService: ref.read(localStorageServiceProvider),
    dailyCheckinService: ref.read(dailyCheckinServiceProvider),
  );
});
