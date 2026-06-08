import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solo_quest/constants/app_constant.dart';
import 'package:solo_quest/core/api/dto/notification_token_dto.dart';
import 'package:solo_quest/core/api/services/notification_api_service.dart';
import 'package:solo_quest/core/notifications/fcm_service.dart';
import 'package:solo_quest/core/notifications/local_notification_service.dart';
import 'package:solo_quest/models/auth_user_model.dart';
import 'package:solo_quest/services/auth_service.dart';
import 'package:solo_quest/services/local_storage_service.dart';

class FakeNotificationApiService extends Fake implements NotificationApiService {
  String? lastToken;
  String? lastPlatform;
  String? lastDeviceName;
  int registerCount = 0;
  String? lastDeletedTokenId;
  bool failDelete = false;
  Duration delay = Duration.zero;

  @override
  Future<NotificationTokenDto> registerToken({
    required String token,
    required String platform,
    String? deviceName,
  }) async {
    if (delay != Duration.zero) {
      await Future.delayed(delay);
    }
    registerCount++;
    lastToken = token;
    lastPlatform = platform;
    lastDeviceName = deviceName;
    return NotificationTokenDto(
      id: 'registered-id-$registerCount',
      userId: 'user-id-123',
      token: token,
      platform: platform,
      deviceName: deviceName,
      isActive: true,
    );
  }

  @override
  Future<void> deleteToken(String tokenId) async {
    lastDeletedTokenId = tokenId;
    if (failDelete) {
      throw Exception('Server error');
    }
  }
}

class FakeLocalNotificationService extends Fake implements LocalNotificationService {}

class FakeAuthService extends Fake implements AuthService {
  bool authenticated = true;
  AuthUserModel? user = AuthUserModel(
    id: 'user-id-123',
    name: 'Test User',
    email: 'test@example.com',
    provider: 'google',
  );

  @override
  Future<bool> isAuthenticated() async => authenticated;

  @override
  Future<AuthUserModel?> getCurrentUser() async => user;
}

class FakeFirebaseMessaging extends Fake implements FirebaseMessaging {
  String? token = 'fcm-mock-token';
  final StreamController<String> _tokenRefreshController = StreamController<String>.broadcast();

  @override
  Future<String?> getToken({String? serviceWorkerScriptPath, String? vapidKey}) async => token;

  @override
  Stream<String> get onTokenRefresh => _tokenRefreshController.stream;

  void triggerTokenRefresh(String newToken) {
    token = newToken;
    _tokenRefreshController.add(newToken);
  }

  void dispose() {
    _tokenRefreshController.close();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeNotificationApiService fakeApiService;
  late FakeLocalNotificationService fakeLocalNotificationService;
  late LocalStorageService localStorageService;
  late FakeAuthService fakeAuthService;
  late FakeFirebaseMessaging fakeFirebaseMessaging;
  late FcmService fcmService;

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    SharedPreferences.setMockInitialValues({});

    fakeApiService = FakeNotificationApiService();
    fakeLocalNotificationService = FakeLocalNotificationService();
    localStorageService = LocalStorageService();
    fakeAuthService = FakeAuthService();
    fakeFirebaseMessaging = FakeFirebaseMessaging();

    fcmService = FcmService(
      apiService: fakeApiService,
      localNotificationService: fakeLocalNotificationService,
      localStorageService: localStorageService,
      authService: fakeAuthService,
      mockMessaging: fakeFirebaseMessaging,
      skipFirebaseInit: true,
    );
  });

  tearDown(() {
    fakeFirebaseMessaging.dispose();
    fcmService.dispose();
  });

  group('FcmService Registration', () {
    test('does not register when unauthenticated', () async {
      fakeAuthService.authenticated = false;

      await fcmService.initialize();

      expect(fakeApiService.registerCount, 0);
    });

    test('registers token when authenticated', () async {
      fakeAuthService.authenticated = true;

      await fcmService.initialize();

      expect(fakeApiService.registerCount, 1);
      expect(fakeApiService.lastToken, 'fcm-mock-token');
      expect(fakeApiService.lastPlatform, isNotEmpty);
      
      // Verify local storage values
      expect(await localStorageService.getString(AppStorageKey.fcmLastRegisteredToken), 'fcm-mock-token');
      expect(await localStorageService.getString(AppStorageKey.fcmLastRegisteredUserId), 'user-id-123');
      expect(await localStorageService.getString(AppStorageKey.fcmLastRegisteredTokenId), 'registered-id-1');
    });

    test('skips duplicate token registration', () async {
      fakeAuthService.authenticated = true;

      // Seed local storage with same values
      await localStorageService.setString(AppStorageKey.fcmLastRegisteredToken, 'fcm-mock-token');
      await localStorageService.setString(AppStorageKey.fcmLastRegisteredUserId, 'user-id-123');
      await localStorageService.setString(AppStorageKey.fcmLastRegisteredTokenId, 'registered-id-existing');

      await fcmService.initialize();

      expect(fakeApiService.registerCount, 0); // Skip!
    });

    test('calling initialize() twice concurrently results in one backend register call', () async {
      fakeAuthService.authenticated = true;
      fakeApiService.delay = const Duration(milliseconds: 50);

      // Call initialize twice concurrently
      final init1 = fcmService.initialize();
      final init2 = fcmService.initialize();

      await Future.wait([init1, init2]);

      expect(fakeApiService.registerCount, 1);
    });

    test('calling initialize() after cached same token/user skips backend call', () async {
      fakeAuthService.authenticated = true;

      await localStorageService.setString(AppStorageKey.fcmLastRegisteredToken, 'fcm-mock-token');
      await localStorageService.setString(AppStorageKey.fcmLastRegisteredUserId, 'user-id-123');

      await fcmService.initialize();

      expect(fakeApiService.registerCount, 0);
    });

    test('registerCurrentToken() called twice concurrently results in one backend call', () async {
      fakeAuthService.authenticated = true;
      fakeApiService.delay = const Duration(milliseconds: 50);

      final r1 = fcmService.registerCurrentToken();
      final r2 = fcmService.registerCurrentToken();

      await Future.wait([r1, r2]);

      expect(fakeApiService.registerCount, 1);
    });

    test('different user id triggers registration even if token same', () async {
      fakeAuthService.authenticated = true;
      await localStorageService.setString(AppStorageKey.fcmLastRegisteredToken, 'fcm-mock-token');
      await localStorageService.setString(AppStorageKey.fcmLastRegisteredUserId, 'different-user-456');

      await fcmService.initialize();

      expect(fakeApiService.registerCount, 1);
    });

    test('different token triggers registration for same user', () async {
      fakeAuthService.authenticated = true;
      await localStorageService.setString(AppStorageKey.fcmLastRegisteredToken, 'different-token-789');
      await localStorageService.setString(AppStorageKey.fcmLastRegisteredUserId, 'user-id-123');

      await fcmService.initialize();

      expect(fakeApiService.registerCount, 1);
    });

    test('token refresh listener is attached only once', () async {
      fakeAuthService.authenticated = true;

      await fcmService.initialize();
      await fcmService.initialize(); // Initialize a second time

      expect(fakeApiService.registerCount, 1);

      // Trigger a token refresh
      fakeFirebaseMessaging.triggerTokenRefresh('refreshed-token-xyz');

      // Wait a moment for stream listener
      await Future.delayed(const Duration(milliseconds: 10));

      // Should register exactly once for the refresh, bringing total to 2
      expect(fakeApiService.registerCount, 2);
      expect(fakeApiService.lastToken, 'refreshed-token-xyz');
    });

    test('token refresh while unauthenticated does not call backend', () async {
      fakeAuthService.authenticated = true;
      await fcmService.initialize();
      expect(fakeApiService.registerCount, 1);

      // Log out auth service
      fakeAuthService.authenticated = false;

      // Trigger refresh
      fakeFirebaseMessaging.triggerTokenRefresh('refreshed-token-abc');
      await Future.delayed(const Duration(milliseconds: 10));

      expect(fakeApiService.registerCount, 1); // No new registration
    });

    test('token refresh with authenticated user registers once', () async {
      fakeAuthService.authenticated = true;
      await fcmService.initialize();

      fakeFirebaseMessaging.triggerTokenRefresh('refreshed-token-123');
      await Future.delayed(const Duration(milliseconds: 10));

      expect(fakeApiService.registerCount, 2);
    });

    test('logout clears FCM cache', () async {
      await localStorageService.setString(AppStorageKey.fcmLastRegisteredToken, 'fcm-mock-token');
      await localStorageService.setString(AppStorageKey.fcmLastRegisteredUserId, 'user-id-123');
      await localStorageService.setString(AppStorageKey.fcmLastRegisteredTokenId, 'token-id-999');

      await fcmService.handleLogout();

      expect(fakeApiService.lastDeletedTokenId, 'token-id-999');
      expect(await localStorageService.getString(AppStorageKey.fcmLastRegisteredToken), isNull);
      expect(await localStorageService.getString(AppStorageKey.fcmLastRegisteredUserId), isNull);
    });

    test('logout delete failure does not block logout', () async {
      await localStorageService.setString(AppStorageKey.fcmLastRegisteredToken, 'fcm-mock-token');
      await localStorageService.setString(AppStorageKey.fcmLastRegisteredUserId, 'user-id-123');
      await localStorageService.setString(AppStorageKey.fcmLastRegisteredTokenId, 'token-id-999');

      fakeApiService.failDelete = true;

      await fcmService.handleLogout(); // Should not throw

      expect(await localStorageService.getString(AppStorageKey.fcmLastRegisteredToken), isNull);
      expect(await localStorageService.getString(AppStorageKey.fcmLastRegisteredUserId), isNull);
    });

    test('after logout, refresh event does not register token', () async {
      fakeAuthService.authenticated = true;
      await fcmService.initialize();
      expect(fakeApiService.registerCount, 1);

      await fcmService.handleLogout();
      fakeAuthService.authenticated = false;

      fakeFirebaseMessaging.triggerTokenRefresh('refreshed-after-logout');
      await Future.delayed(const Duration(milliseconds: 10));

      expect(fakeApiService.registerCount, 1); // Remains 1, no new call
    });
  });
}
