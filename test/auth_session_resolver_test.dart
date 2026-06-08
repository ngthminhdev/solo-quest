import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solo_quest/core/api/dto/auth_dto.dart';
import 'package:solo_quest/core/api/dto/user_dto.dart';
import 'package:solo_quest/core/api/services/auth_api_service.dart';
import 'package:solo_quest/core/api/services/user_api_service.dart';
import 'package:solo_quest/core/network/api_exception.dart';
import 'package:solo_quest/routes/routes_config.dart';
import 'package:solo_quest/services/auth_session_resolver.dart';
import 'package:solo_quest/services/auth_token_storage.dart';
import 'package:solo_quest/services/daily_checkin_service.dart';
import 'package:solo_quest/services/local_storage_service.dart';

class FakeAuthApiService extends Fake implements AuthApiService {
  AuthUserDto? user;
  Object? error;

  @override
  Future<AuthUserDto> getMe() async {
    final error = this.error;
    if (error != null) throw error;
    return user!;
  }
}

class FakeUserApiService extends Fake implements UserApiService {
  bool onboardingCompleted = true;
  bool hasCheckedIn = true;
  Object? getMeError;

  @override
  Future<UserProfileDto> getMe() async {
    final error = getMeError;
    if (error != null) throw error;
    return UserProfileDto(
      id: 'user-1',
      email: 'user@example.com',
      name: 'Test User',
      level: 1,
      currentLevelExp: 0,
      nextLevelExp: 100,
      totalExp: 0,
      rewardPoints: 0,
      streakDays: 0,
      totalCompletedQuests: 0,
      mainGoals: const [],
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
  }

  @override
  Future<OnboardingStatusDto> getOnboardingStatus() async {
    return OnboardingStatusDto(completed: onboardingCompleted);
  }

  @override
  Future<DailyStatusDto> getDailyStatus() async {
    return DailyStatusDto(
      hasCheckedIn: hasCheckedIn,
      hasReviewed: false,
      totalCount: 0,
      completedCount: 0,
      skippedCount: 0,
      pendingCount: 0,
      activeCount: 0,
      snoozedCount: 0,
      completionRate: 0.0,
      earnedExpToday: 0,
      streakDays: 0,
    );
  }
}

class FakeDailyCheckinService extends Fake implements DailyCheckinService {
  bool checkedIn = false;

  @override
  Future<bool> hasCheckedInToday() async => checkedIn;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthTokenStorage tokenStorage;
  late FakeAuthApiService authApiService;
  late FakeUserApiService userApiService;
  late FakeDailyCheckinService dailyCheckinService;
  late AuthSessionResolver resolver;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    SharedPreferences.setMockInitialValues({});
    tokenStorage = AuthTokenStorage();
    authApiService = FakeAuthApiService();
    userApiService = FakeUserApiService();
    dailyCheckinService = FakeDailyCheckinService();
    resolver = AuthSessionResolver(
      tokenStorage: tokenStorage,
      localStorageService: LocalStorageService(),
      userApiService: userApiService,
      dailyCheckinService: dailyCheckinService,
      authApiService: authApiService,
    );
  });

  AuthUserDto user({bool onboarded = true}) {
    return AuthUserDto(
      id: 'user-1',
      displayName: 'Test User',
      email: 'user@example.com',
      hasCompletedOnboarding: onboarded,
    );
  }

  Future<void> saveTokens() {
    return tokenStorage.saveSessionTokens(
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
    );
  }

  test('no token routes to login', () async {
    final route = await resolver.resolveInitialRoute();

    expect(route, RoutesConfig.login);
  });

  test(
    'token with incomplete backend onboarding routes to onboarding',
    () async {
      await saveTokens();
      authApiService.user = user(onboarded: false);
      userApiService.onboardingCompleted = false;

      final route = await resolver.resolveInitialRoute();

      expect(route, RoutesConfig.onboarding);
    },
  );

  test(
    'onboarded user without daily check-in routes to morning check-in',
    () async {
      await saveTokens();
      authApiService.user = user();
      userApiService.hasCheckedIn = false;

      final route = await resolver.resolveInitialRoute();

      expect(route, RoutesConfig.morningCheckin);
    },
  );

  test('onboarded user with daily check-in routes to home', () async {
    await saveTokens();
    authApiService.user = user();
    userApiService.hasCheckedIn = true;

    final route = await resolver.resolveInitialRoute();

    expect(route, RoutesConfig.home);
  });

  test('auth/me 401 clears tokens and routes to login', () async {
    await saveTokens();
    authApiService.error = ApiException.unauthorized();

    final route = await resolver.resolveInitialRoute();

    expect(route, RoutesConfig.login);
    expect(await tokenStorage.hasTokens(), isFalse);
  });
}
