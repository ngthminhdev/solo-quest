import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solo_quest/core/api/dto/auth_dto.dart';
import 'package:solo_quest/core/api/services/auth_api_service.dart';
import 'package:solo_quest/core/network/api_exception.dart';
import 'package:solo_quest/services/auth_exceptions.dart';
import 'package:solo_quest/services/auth_service.dart';
import 'package:solo_quest/services/auth_token_storage.dart';
import 'package:solo_quest/services/google_auth_provider.dart';
import 'package:solo_quest/services/local_storage_service.dart';

class FakeGoogleAuthProvider extends Fake implements GoogleAuthProvider {
  GoogleAuthCredential credential = const GoogleAuthCredential(
    idToken: 'google-id-token',
    email: 'user@example.com',
    displayName: 'Google User',
  );

  @override
  Future<GoogleAuthCredential> signIn() async => credential;

  @override
  Future<void> signOut() async {}
}

class FakeAuthApiService extends Fake implements AuthApiService {
  Object? googleLoginError;
  String? receivedIdToken;

  @override
  Future<AuthSessionDto> googleLogin({required String idToken}) async {
    receivedIdToken = idToken;
    final error = googleLoginError;
    if (error != null) throw error;

    return AuthSessionDto(
      accessToken: 'backend-access-token',
      refreshToken: 'backend-refresh-token',
      user: AuthUserDto(
        id: 'user-1',
        displayName: 'Backend User',
        email: 'backend@example.com',
        provider: 'google',
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthTokenStorage tokenStorage;
  late FakeGoogleAuthProvider googleAuthProvider;
  late FakeAuthApiService authApiService;
  late AuthService authService;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    SharedPreferences.setMockInitialValues({});
    tokenStorage = AuthTokenStorage();
    googleAuthProvider = FakeGoogleAuthProvider();
    authApiService = FakeAuthApiService();
    authService = AuthService(
      localStorageService: LocalStorageService(),
      tokenStorage: tokenStorage,
      authApiService: authApiService,
      googleAuthProvider: googleAuthProvider,
    );
  });

  test('Google login exchanges idToken and saves backend tokens', () async {
    final user = await authService.signInWithGoogle();

    expect(authApiService.receivedIdToken, 'google-id-token');
    expect(user.id, 'user-1');
    expect(user.name, 'Backend User');
    expect(await tokenStorage.getAccessToken(), 'backend-access-token');
    expect(await tokenStorage.getRefreshToken(), 'backend-refresh-token');
  });

  test(
    'Google backend rejection returns backend message and saves no tokens',
    () async {
      authApiService.googleLoginError = ApiException(
        statusCode: 401,
        error: 'invalid_google_token',
        message: 'Google token rejected by backend',
      );

      final call = authService.signInWithGoogle();

      await expectLater(
        call,
        throwsA(
          isA<AuthException>()
              .having(
                (e) => e.code,
                'code',
                AuthExceptionCode.googleBackendRejected,
              )
              .having(
                (e) => e.message,
                'message',
                'Google token rejected by backend',
              ),
        ),
      );
      expect(await tokenStorage.hasTokens(), isFalse);
    },
  );
}
