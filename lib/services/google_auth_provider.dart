import 'dart:developer' as developer;

import 'package:google_sign_in/google_sign_in.dart';

import '../config/app_config.dart';
import 'auth_exceptions.dart';

class GoogleAuthCredential {
  const GoogleAuthCredential({
    required this.idToken,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  final String idToken;
  final String email;
  final String? displayName;
  final String? photoUrl;
}

abstract class GoogleAuthProvider {
  Future<GoogleAuthCredential> signIn();
  Future<void> signOut();
}

class GoogleSignInAuthProvider implements GoogleAuthProvider {
  bool _initialized = false;
  Future<void>? _initializationFuture;

  @override
  Future<GoogleAuthCredential> signIn() async {
    await _initializeIfNeeded();

    if (!GoogleSignIn.instance.supportsAuthenticate()) {
      _logAuth('[AUTH] Google authenticate unsupported on this platform');
      throw const AuthException(
        code: AuthExceptionCode.googleUnsupported,
        message: 'Google Sign-In chưa hỗ trợ trên nền tảng này.',
      );
    }

    try {
      _logAuth('[AUTH] Google authenticate started');
      final account = await GoogleSignIn.instance.authenticate(
        scopeHint: const ['email', 'profile'],
      );
      _logAuth('[AUTH] Google authenticate success: email=${account.email}');

      final idToken = account.authentication.idToken;
      _logAuth(
        '[AUTH] Google idToken received: ${idToken != null && idToken.isNotEmpty}'
        ', length=${idToken?.length ?? 0}',
      );

      if (idToken == null || idToken.isEmpty) {
        throw const AuthException(
          code: AuthExceptionCode.googleIdTokenMissing,
          message: 'Không lấy được Google ID token',
        );
      }

      return GoogleAuthCredential(
        idToken: idToken,
        email: account.email,
        displayName: account.displayName,
        photoUrl: account.photoUrl,
      );
    } on GoogleSignInException catch (e) {
      _logGoogleException('[AUTH] Google authenticate failed', e);

      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthException(
          code: AuthExceptionCode.googleCancelled,
          message: 'Đã hủy đăng nhập Google',
        );
      }

      throw AuthException(
        code: AuthExceptionCode.googleSignInFailed,
        message: 'Không thể đăng nhập Google. Vui lòng thử lại.',
      );
    } on AuthException {
      rethrow;
    } catch (e, st) {
      _logAuthError('[AUTH] Google authenticate error', e, st);
      throw const AuthException(
        code: AuthExceptionCode.googleSignInFailed,
        message: 'Không thể đăng nhập Google. Vui lòng thử lại.',
      );
    }
  }

  @override
  Future<void> signOut() async {
    if (!_initialized) return;
    await GoogleSignIn.instance.signOut();
  }

  Future<void> _initializeIfNeeded() async {
    if (_initialized) return;
    if (_initializationFuture != null) {
      return _initializationFuture!;
    }

    final authConfig = AppConfig.instance.auth;
    final serverClientId = authConfig.googleWebClientId.trim();
    if (serverClientId.isEmpty) {
      throw const AuthException(
        code: AuthExceptionCode.googleConfigMissing,
        message:
            'Google login chưa được cấu hình. Hãy thêm googleWebClientId trong assets/config.yaml.',
      );
    }

    _initializationFuture = _initialize(serverClientId);
    return _initializationFuture!;
  }

  Future<void> _initialize(String serverClientId) async {
    try {
      _logAuth('[AUTH] Google initialize started');
      await GoogleSignIn.instance.initialize(
        // Android OAuth audit:
        // - applicationId/package name must match the Google Console Android OAuth client.
        // - Debug SHA-1 and SHA-256 must be added to that Android OAuth client.
        // - serverClientId must be the Web OAuth Client ID, not the Android client ID.
        // - Update google-services.json if Firebase/Google Services is later enabled.
        // - If OAuth consent is in Testing, add the current Google account as a test user.
        serverClientId: serverClientId,
      );
      _initialized = true;
      _logAuth('[AUTH] Google initialize success');
    } catch (e, st) {
      _initializationFuture = null;
      _logAuthError('[AUTH] Google initialize failed', e, st);
      throw const AuthException(
        code: AuthExceptionCode.googleSignInFailed,
        message: 'Không thể khởi tạo Google Sign-In. Vui lòng thử lại.',
      );
    }
  }

  void _logGoogleException(String checkpoint, GoogleSignInException error) {
    _logAuth(
      '$checkpoint: type=${error.runtimeType}, code=${error.code}, '
      'message=${error.description}, details=${error.details}',
    );
  }

  void _logAuthError(String checkpoint, Object error, StackTrace stackTrace) {
    developer.log(
      '$checkpoint: type=${error.runtimeType}, message=$error',
      name: 'SoloQuestAuth',
      error: error,
      stackTrace: stackTrace,
    );
  }

  void _logAuth(String message) {
    developer.log(message, name: 'SoloQuestAuth');
  }
}
