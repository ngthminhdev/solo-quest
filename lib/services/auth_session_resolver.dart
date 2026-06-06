import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

import '../constants/app_constant.dart';
import '../core/api/dto/auth_dto.dart';
import '../core/api/services/auth_api_service.dart';
import '../core/api/services/user_api_service.dart';
import '../core/network/api_exception.dart';
import '../routes/routes_config.dart';
import 'auth_token_storage.dart';
import 'daily_checkin_service.dart';
import 'local_storage_service.dart';

class AuthSessionResolver {
  AuthSessionResolver({
    required AuthTokenStorage tokenStorage,
    required LocalStorageService localStorageService,
    required UserApiService userApiService,
    required DailyCheckinService dailyCheckinService,
    AuthApiService? authApiService,
  }) : _tokenStorage = tokenStorage,
       _localStorageService = localStorageService,
       _userApiService = userApiService,
       _dailyCheckinService = dailyCheckinService,
       _authApiService = authApiService ?? AuthApiService();

  final AuthTokenStorage _tokenStorage;
  final LocalStorageService _localStorageService;
  final UserApiService _userApiService;
  final DailyCheckinService _dailyCheckinService;
  final AuthApiService _authApiService;

  Future<String> resolveInitialRoute() async {
    if (kDebugMode) {
      developer.log('[SESSION] Resolving authenticated route...');
    }

    final hasTokens = await _tokenStorage.hasTokens();
    if (!hasTokens) {
      await clearSession();
      return RoutesConfig.login;
    }

    final authUser = await _loadAuthenticatedUser();
    if (authUser == null) {
      return RoutesConfig.login;
    }

    final onboardingCompleted = await _resolveOnboardingCompleted(authUser);
    await _localStorageService.setBool(
      AppStorageKey.hasCompletedOnboarding,
      onboardingCompleted,
    );

    if (!onboardingCompleted) {
      return RoutesConfig.onboarding;
    }

    final checkedIn = await _resolveDailyCheckIn();
    if (!checkedIn) {
      return RoutesConfig.morningCheckin;
    }

    return RoutesConfig.home;
  }

  Future<void> clearSession() async {
    await _localStorageService.remove(AppStorageKey.isAuthenticated);
    await _localStorageService.remove(AppStorageKey.authUser);
    await _tokenStorage.clear();
  }

  Future<AuthUserDto?> _loadAuthenticatedUser() async {
    try {
      return await _authApiService.getMe();
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        await clearSession();
        return null;
      }

      if (kDebugMode) {
        developer.log('[SESSION] /auth/me unavailable, trying /users/me: $e');
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log('[SESSION] /auth/me failed, trying /users/me: $e');
      }
    }

    try {
      final user = await _userApiService.getMe();
      return AuthUserDto(
        id: user.id,
        displayName: user.name,
        email: user.email,
        avatarUrl: user.avatarUrl,
        level: user.level,
        currentLevelExp: user.currentLevelExp,
        nextLevelExp: user.nextLevelExp,
        totalExp: user.totalExp,
        rewardPoints: user.rewardPoints,
        streakDays: user.streakDays,
        totalCompletedQuests: user.totalCompletedQuests,
      );
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        await clearSession();
      }

      if (kDebugMode) {
        developer.log('[SESSION] /users/me validation failed: $e');
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        developer.log('[SESSION] /users/me validation error: $e');
      }
      return null;
    }
  }

  Future<bool> _resolveOnboardingCompleted(AuthUserDto authUser) async {
    return authUser.hasCompletedOnboarding;
  }

  Future<bool> _resolveDailyCheckIn() async {
    try {
      final status = await _userApiService.getDailyStatus();
      return status.hasCheckedIn;
    } catch (e) {
      if (kDebugMode) {
        developer.log('[SESSION] Daily status unavailable, using local fallback: $e');
      }
      return _dailyCheckinService.hasCheckedInToday();
    }
  }
}
