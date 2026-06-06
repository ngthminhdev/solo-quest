import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

import '../constants/app_constant.dart';
import '../core/api/services/auth_api_service.dart';
import '../core/api/dto/auth_dto.dart';
import '../core/network/api_exception.dart';
import '../models/auth_user_model.dart';
import 'auth_exceptions.dart';
import 'auth_token_storage.dart';
import 'google_auth_provider.dart';
import 'local_storage_service.dart';

class AuthService {
  AuthService({
    required this.localStorageService,
    required this.tokenStorage,
    AuthApiService? authApiService,
    GoogleAuthProvider? googleAuthProvider,
  }) : _authApiService = authApiService ?? AuthApiService(),
       _googleAuthProvider = googleAuthProvider ?? GoogleSignInAuthProvider();

  final LocalStorageService localStorageService;
  final AuthTokenStorage tokenStorage;
  final AuthApiService _authApiService;
  final GoogleAuthProvider _googleAuthProvider;

  Future<AuthUserModel?> getCurrentUser() async {
    final raw = await localStorageService.getString(AppStorageKey.authUser);
    if (raw == null || raw.isEmpty) return null;
    try {
      return AuthUserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (e, st) {
      if (kDebugMode) {
        developer.log(
          '[AUTH] Failed to decode cached auth user: type=${e.runtimeType}, message=$e',
          error: e,
          stackTrace: st,
        );
      }
      return null;
    }
  }

  Future<bool> isAuthenticated() async {
    return tokenStorage.hasTokens();
  }

  /// Sign in with Google and exchange the Google ID token for backend tokens.
  Future<AuthUserModel> signInWithGoogle() async {
    if (kDebugMode) {
      developer.log('[AUTH] signInWithGoogle called');
    }

    final googleCredential = await _googleAuthProvider.signIn();

    try {
      if (kDebugMode) {
        developer.log(
          '[AUTH] Backend Google login started: idTokenExists=${googleCredential.idToken.isNotEmpty}, idTokenLength=${googleCredential.idToken.length}',
        );
      }

      final session = await _authApiService.googleLogin(
        idToken: googleCredential.idToken,
      );

      if (kDebugMode) {
        developer.log('[AUTH] Backend Google login success');
      }

      return _saveSession(session, providerFallback: 'google');
    } on ApiException catch (e, st) {
      if (kDebugMode) {
        developer.log(
          '[AUTH] Backend Google login failure: type=${e.runtimeType}, status=${e.statusCode}, error=${e.error}, message=${e.message}',
          error: e,
          stackTrace: st,
        );
      }
      throw AuthException(
        code: AuthExceptionCode.googleBackendRejected,
        message: e.message.isNotEmpty
            ? e.message
            : 'Backend không chấp nhận Google ID token.',
      );
    } catch (e, st) {
      if (kDebugMode) {
        developer.log(
          '[AUTH] Backend Google login failure: type=${e.runtimeType}, message=$e',
          error: e,
          stackTrace: st,
        );
      }
      throw const AuthException(
        code: AuthExceptionCode.googleBackendRejected,
        message: 'Không thể xác thực Google với backend. Vui lòng thử lại.',
      );
    }
  }

  /// Debug-only backend dev login fallback.
  Future<AuthUserModel> signInWithDevLogin() async {
    if (kDebugMode) {
      developer.log('[AUTH] signInWithDevLogin called');
    }

    final session = await _authApiService.devLogin();

    if (kDebugMode) {
      developer.log(
        '[AUTH] Dev login success: user=${session.user.displayName}, hasAccessToken=${session.accessToken.isNotEmpty}, hasRefreshToken=${session.refreshToken.isNotEmpty}',
      );
    }

    return _saveSession(session, providerFallback: 'dev');
  }

  Future<AuthUserDto?> getCurrentBackendUser() async {
    return _authApiService.getMe();
  }

  /// Legacy mock method - kept for compatibility but now calls explicit dev login.
  @Deprecated('Use signInWithDevLogin() instead')
  Future<AuthUserModel> signInWithGoogleMock() async {
    return signInWithDevLogin();
  }

  Future<void> signOut() async {
    if (kDebugMode) {
      developer.log('[AUTH] signOut called');
    }

    final hasRefreshToken = await tokenStorage.getRefreshToken() != null;

    // Try backend logout, but don't fail if it errors.
    try {
      if (hasRefreshToken) {
        await _authApiService.logout();
        if (kDebugMode) {
          developer.log('[AUTH] Backend logout success');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log('[AUTH] Backend logout failed (continuing local logout): $e');
      }
    }

    try {
      await _googleAuthProvider.signOut();
    } catch (e) {
      if (kDebugMode) {
        developer.log('[AUTH] Google signOut failed (continuing local logout): $e');
      }
    }

    await localStorageService.remove(AppStorageKey.isAuthenticated);
    await localStorageService.remove(AppStorageKey.authUser);
    await tokenStorage.clear();

    if (kDebugMode) {
      developer.log('[AUTH] Local auth state cleared');
    }
  }

  Future<AuthUserModel> _saveSession(
    AuthSessionDto session, {
    required String providerFallback,
  }) async {
    await tokenStorage.saveSessionTokens(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );

    if (kDebugMode) {
      developer.log('[AUTH] Tokens saved');
    }

    final user = AuthUserModel(
      id: session.user.id,
      name: session.user.displayName,
      email: session.user.email ?? '',
      avatarUrl: session.user.avatarUrl,
      provider: session.user.provider.isNotEmpty
          ? session.user.provider
          : providerFallback,
    );

    await localStorageService.setBool(AppStorageKey.isAuthenticated, true);
    await localStorageService.setString(
      AppStorageKey.authUser,
      jsonEncode(user.toJson()),
    );

    if (kDebugMode) {
      developer.log('[AUTH] Local auth state saved (isAuthenticated=true)');
    }

    return user;
  }
}
