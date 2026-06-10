import 'dart:async';
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_constant.dart';
import '../../services/auth_service.dart';
import '../../services/auth_token_storage.dart';
import '../../services/local_storage_service.dart';
import '../../routes/routes_config.dart';
import '../../config/app_session.dart';
import '../api/services/notification_api_service.dart';
import 'local_notification_service.dart';
import 'fcm_notification_payload.dart';
import '../../widgets/app_dialog/reminder_dialog.dart';
import '../../modules/main/main_page_model.dart';
import '../../services/service_providers.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Standard background handler. Runs in a separate isolate.
  debugPrint('[FCM BACKGROUND] Message received: ${message.messageId}');
}

class FcmService {
  final Ref? _ref;
  final NotificationApiService _apiService;
  final LocalNotificationService _localNotificationService;
  final LocalStorageService _localStorageService;
  final AuthService _authService;
  final FirebaseMessaging? _mockMessaging;
  final bool _skipFirebaseInit;
  FcmNotificationPayload? _pendingPayload;

  StreamSubscription<String>? _tokenRefreshSub;
  StreamSubscription<String>? _localTapSub;
  bool _firebaseInitialized = false;

  Future<void>? _initializeFuture;
  Future<void>? _registerFuture;
  String? _pendingRefreshToken;

  FcmService({
    Ref? ref,
    NotificationApiService? apiService,
    LocalNotificationService? localNotificationService,
    LocalStorageService? localStorageService,
    AuthService? authService,
    FirebaseMessaging? mockMessaging,
    bool skipFirebaseInit = false,
  })  : _ref = ref,
        _apiService = apiService ?? NotificationApiService(),
        _localNotificationService = localNotificationService ?? LocalNotificationService(),
        _localStorageService = localStorageService ?? LocalStorageService(),
        _authService = authService ?? AuthService(
          localStorageService: LocalStorageService(),
          tokenStorage: AuthTokenStorage(),
        ),
        _mockMessaging = mockMessaging,
        _skipFirebaseInit = skipFirebaseInit;

  /// Initializes FCM listeners, permissions, and registers current token if authenticated.
  Future<void> initialize() {
    final existing = _initializeFuture;
    if (existing != null) {
      if (kDebugMode) {
        debugPrint('[FCM] initialize skipped: already running');
      }
      return existing;
    }

    final future = _initializeInternal();
    _initializeFuture = future;

    return future.whenComplete(() {
      _initializeFuture = null;
    });
  }

  Future<void> _initializeInternal() async {
    try {
      // 1. Initialize Firebase if not already initialized and not skipped in tests
      if (!_skipFirebaseInit && !_firebaseInitialized) {
        await Firebase.initializeApp();
        FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
        _firebaseInitialized = true;
        if (kDebugMode) {
          debugPrint('[FCM] Firebase initialized successfully');
        }
      }

      // 2. Setup message listeners (skipped in unit tests)
      if (!_skipFirebaseInit) {
        _setupMessageHandlers();
      }

      // 3. Request permissions in a user-safe way
      await requestPermission();

      // 4. Token refresh listener
      if (_tokenRefreshSub == null) {
        final onTokenRefreshStream = _skipFirebaseInit
            ? (_mockMessaging?.onTokenRefresh ?? const Stream<String>.empty())
            : FirebaseMessaging.instance.onTokenRefresh;

        _tokenRefreshSub = onTokenRefreshStream.listen((token) async {
          final displayToken = _maskToken(token);
          if (kDebugMode) {
            debugPrint('[FCM] Token refreshed: $displayToken');
          }
          await _registerToken(token);
        });
        if (kDebugMode) {
          debugPrint('[FCM] Token refresh listener attached');
        }
      } else {
        if (kDebugMode) {
          debugPrint('[FCM] token refresh listener already attached');
        }
      }

      // 5. Register current token if user is authenticated
      await registerCurrentToken();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[FCM] Initialization failed: $e');
      }
    }
  }

  /// Request permissions without blocking the user or app flow.
  Future<void> requestPermission() async {
    try {
      if (_skipFirebaseInit) {
        if (kDebugMode) {
          debugPrint('[FCM] Mock requestPermission called');
        }
        return;
      }
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (kDebugMode) {
        debugPrint('[FCM] Notification permission status: ${settings.authorizationStatus}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[FCM] Request permission error: $e');
      }
    }
  }

  Future<String?> getToken() async {
    try {
      if (_skipFirebaseInit) {
        final mock = _mockMessaging;
        return mock != null ? await mock.getToken() : 'mock-token';
      }
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[FCM] Error getting token: $e');
      }
      return null;
    }
  }

  /// Fetch device token and register it with the backend if authenticated.
  Future<void> registerCurrentToken() async {
    try {
      final token = await getToken();
      if (token == null) {
        if (kDebugMode) {
          debugPrint('[FCM] Cannot register: FCM token is null');
        }
        return;
      }
      await _registerToken(token);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[FCM] Error in registerCurrentToken: $e');
      }
    }
  }

  /// Logic to register a specific token to the backend, preventing duplicate spam.
  Future<void> _registerToken(String token) async {
    if (_registerFuture != null) {
      if (kDebugMode) {
        debugPrint('[FCM] token registration skipped: already running. Queueing token for later.');
      }
      _pendingRefreshToken = token;
      return _registerFuture!;
    }

    final future = _registerTokenInternal(token);
    _registerFuture = future;

    try {
      await future;
    } finally {
      _registerFuture = null;
      final pending = _pendingRefreshToken;
      if (pending != null) {
        _pendingRefreshToken = null;
        if (kDebugMode) {
          debugPrint('[FCM] Running pending token registration');
        }
        scheduleMicrotask(() => _registerToken(pending));
      }
    }
  }

  Future<void> _registerTokenInternal(String token) async {
    try {
      final isAuthenticated = await _authService.isAuthenticated();
      if (!isAuthenticated) {
        if (kDebugMode) {
          debugPrint('[FCM] token registration skipped: unauthenticated');
        }
        return;
      }

      final currentUser = await _authService.getCurrentUser();
      final userId = currentUser?.id ?? '';
      if (userId.isEmpty) {
        if (kDebugMode) {
          debugPrint('[FCM] token registration skipped: unauthenticated (no user ID)');
        }
        return;
      }

      // Check cache to avoid duplicate registration
      final cachedToken = await _localStorageService.getString(AppStorageKey.fcmLastRegisteredToken);
      final cachedUserId = await _localStorageService.getString(AppStorageKey.fcmLastRegisteredUserId);

      if (cachedToken == token && cachedUserId == userId) {
        if (kDebugMode) {
          debugPrint('[FCM] token registration skipped: already registered');
        }
        return;
      }

      final platform = _getPlatform();
      final deviceName = await _getDeviceName();

      if (kDebugMode) {
        debugPrint('[FCM] registering token for user=${_maskUserId(userId)}, token=${_maskToken(token)}');
      }

      final responseDto = await _apiService.registerToken(
        token: token,
        platform: platform,
        deviceName: deviceName,
      );

      // Verify still authenticated before saving to cache!
      final stillAuthenticated = await _authService.isAuthenticated();
      if (!stillAuthenticated) {
        if (kDebugMode) {
          debugPrint('[FCM] Registration completed but skipped saving cache: user logged out during request');
        }
        return;
      }

      // Save to cache
      await _localStorageService.setString(AppStorageKey.fcmLastRegisteredToken, token);
      await _localStorageService.setString(AppStorageKey.fcmLastRegisteredUserId, userId);
      await _localStorageService.setString(AppStorageKey.fcmLastRegisteredTokenId, responseDto.id);

      if (kDebugMode) {
        debugPrint('[FCM] token registered successfully. ID: ${responseDto.id}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[FCM] Error registering token: $e');
      }
    }
  }

  /// Handle unregistration during logout.
  Future<void> handleLogout() async {
    // Clear in-flight registration state
    _pendingRefreshToken = null;
    _registerFuture = null;

    try {
      final tokenId = await _localStorageService.getString(AppStorageKey.fcmLastRegisteredTokenId);
      if (tokenId != null && tokenId.isNotEmpty) {
        await _apiService.deleteToken(tokenId);
        if (kDebugMode) {
          debugPrint('[FCM] Unregistered token from backend');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[FCM] Error deleting token from backend during logout: $e (continuing)');
      }
    } finally {
      // Clear local cache regardless of API call outcome
      await _localStorageService.remove(AppStorageKey.fcmLastRegisteredToken);
      await _localStorageService.remove(AppStorageKey.fcmLastRegisteredUserId);
      await _localStorageService.remove(AppStorageKey.fcmLastRegisteredTokenId);
      if (kDebugMode) {
        debugPrint('[FCM] Local token cache cleared');
      }
    }
  }

  /// Helper to mask sensitive token
  String _maskToken(String? token) {
    if (token == null || token.isEmpty) return 'null';
    if (token.length > 8) {
      return '${token.substring(0, 4)}...${token.substring(token.length - 4)}';
    }
    return '***';
  }

  /// Helper to mask sensitive user ID
  String _maskUserId(String? userId) {
    if (userId == null || userId.isEmpty) return 'null';
    if (userId.length > 6) {
      return '${userId.substring(0, 3)}...${userId.substring(userId.length - 3)}';
    }
    return userId;
  }

  /// Dispose listeners.
  void dispose() {
    _tokenRefreshSub?.cancel();
    _localTapSub?.cancel();
  }

  void _setupMessageHandlers() {
    // 1. Foreground messaging
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        debugPrint('[FCM FOREGROUND] Message received: ${message.messageId}');
        debugPrint('[FCM FOREGROUND] Title: ${message.notification?.title}, Body: ${message.notification?.body}');
        debugPrint('[FCM FOREGROUND] Data: ${message.data}');
      }

      final title = message.notification?.title ?? 'SoloQuest Alert';
      final body = message.notification?.body ?? '';
      
      // Generate a unique ID using hashCode
      final id = message.messageId?.hashCode ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Construct a payload prefix with 'fcm:' followed by JSON string of data
      final payload = 'fcm:${jsonEncode(message.data)}';

      _localNotificationService.showLocalNotification(
        id: id,
        title: title,
        body: body,
        payload: payload,
      );
    });

    // 2. Message opened app (when in background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        debugPrint('[FCM OPENED APP] Message clicked: ${message.messageId}');
        debugPrint('[FCM OPENED APP] Data: ${message.data}');
      }
      _handleNotificationTap(message.data);
    });

    // 3. Initial message (when app was terminated)
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        if (kDebugMode) {
          debugPrint('[FCM INITIAL MESSAGE] Opened app from terminated: ${message.messageId}');
          debugPrint('[FCM INITIAL MESSAGE] Data: ${message.data}');
        }
        _handleNotificationTap(message.data);
      }
    });

    // 4. Local notification tap stream (covers foreground notification tap)
    _localTapSub = _localNotificationService.onTapStream.listen((payload) {
      if (kDebugMode) {
        debugPrint('[LOCAL NOTIFICATION TAP] Payload: $payload');
      }
      if (payload.startsWith('fcm:')) {
        final parsed = FcmNotificationPayload.parse(payload);
        if (parsed != null) {
          handleNotificationPayloadTap(parsed);
        }
      }
    });
  }

  void _handleNotificationTap(Map<dynamic, dynamic> data) {
    final payload = FcmNotificationPayload.fromMap(data);
    handleNotificationPayloadTap(payload);
  }

  Future<void> handleNotificationPayloadTap(FcmNotificationPayload payload) async {
    final isAuthenticated = await _authService.isAuthenticated();
    if (!isAuthenticated) {
      if (kDebugMode) {
        debugPrint('[FCM] Tap received but unauthenticated. Saving pending payload.');
      }
      _pendingPayload = payload;
      
      final navigator = AppSession.navigatorKey.currentState;
      if (navigator != null) {
        navigator.pushNamedAndRemoveUntil(RoutesConfig.login, (route) => false);
      }
      return;
    }

    handleNotificationPayload(payload);
  }

  void processPendingNotificationPayload() {
    final payload = _pendingPayload;
    if (payload != null) {
      if (kDebugMode) {
        debugPrint('[FCM] Processing pending payload: ${payload.event}');
      }
      _pendingPayload = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (kDebugMode) {
          debugPrint('[FCM] Inside post frame callback, running handleNotificationPayload');
        }
        handleNotificationPayload(payload);
      });
    }
  }

  void handleNotificationPayload(FcmNotificationPayload payload) {
    if (kDebugMode) {
      debugPrint('[FCM] handleNotificationPayload invoked for event: ${payload.event}, action: ${payload.action}, questId: ${payload.questId}');
    }
    try {
      final navigator = AppSession.navigatorKey.currentState;
      if (navigator == null) {
        if (kDebugMode) {
          debugPrint('[FCM] Navigator is null, cannot route');
        }
        return;
      }

      // Navigate Home by clearing the stack down to a single MainPage instead
      // of pushing a new one on top. Plain pushNamed stacks a fresh MainPage per
      // reminder, and each MainPage registers its own countdown/reminder
      // listeners — so when a countdown expired the popup was shown once per
      // stacked MainPage, requiring several "close" taps to dismiss them all.
      // removeUntil((route) => false) guarantees exactly one MainPage remains.
      void goHome() {
        _ref?.read(mainPageProvider.notifier).goToTab(0);
        navigator.pushNamedAndRemoveUntil(
          RoutesConfig.home,
          (route) => false,
        );
      }

      // Quest events
      if ((payload.questId != null && payload.questId!.isNotEmpty) || payload.action == 'open_quest_detail') {
        if (payload.questId != null && payload.questId!.isNotEmpty) {
          navigator.pushNamed(
            RoutesConfig.questDetail,
            arguments: {'id': payload.questId},
          );
        } else {
          if (kDebugMode) {
            debugPrint('[FCM] Quest ID is missing, falling back to Home');
          }
          goHome();
        }
        return;
      }

      // Water reminder
      if (payload.reminderType == 'water' || payload.action == 'water_reminder') {
        goHome();
        _showReminderPromptWithSafeguards(payload);
        return;
      }

      // Break time reminder
      if (payload.reminderType == 'break_time' || payload.action == 'start_break_timer') {
        goHome();
        _showReminderPromptWithSafeguards(payload);
        return;
      }

      // Daily review reminder
      if (payload.reminderType == 'daily_review' || payload.action == 'daily_review_reminder') {
        try {
          navigator.pushNamed(RoutesConfig.dailyReview);
        } catch (e) {
          goHome();
          _showReminderPromptWithSafeguards(payload);
        }
        return;
      }

      // Movement, learning, sleep reminders
      final isMovement = payload.reminderType == 'movement' || payload.action == 'movement_reminder';
      final isLearning = payload.reminderType == 'learning' || payload.action == 'learning_reminder';
      final isSleep = payload.reminderType == 'sleep' || payload.action == 'sleep_reminder';

      if (isMovement || isLearning || isSleep) {
        goHome();
        _showReminderPromptWithSafeguards(payload);
        return;
      }

      // Unknown event/action fallback
      if (kDebugMode) {
        debugPrint('[FCM] Unknown event: ${payload.event}, action: ${payload.action}. Falling back to Home.');
      }
      goHome();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[FCM] Error in handleNotificationPayload: $e');
      }
    }
  }

  void _showReminderPromptWithSafeguards(FcmNotificationPayload payload) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = AppSession.navigatorKey.currentContext;
      if (context == null || !context.mounted) {
        _ref?.read(pendingReminderProvider.notifier).state = payload;
        return;
      }

      try {
        final navigator = Navigator.of(context, rootNavigator: true);
        if (navigator.overlay == null) {
          _ref?.read(pendingReminderProvider.notifier).state = payload;
          return;
        }

        ReminderDialog.showReminderPrompt(context, payload, _ref);
      } catch (e) {
        _ref?.read(pendingReminderProvider.notifier).state = payload;
      }
    });
  }

  String _getPlatform() {
    if (kIsWeb) return 'web';
    if (defaultTargetPlatform == TargetPlatform.android) return 'android';
    if (defaultTargetPlatform == TargetPlatform.iOS) return 'ios';
    return 'unknown';
  }

  Future<String> _getDeviceName() async {
    try {
      if (kIsWeb) return 'Web Browser';
      final deviceInfo = DeviceInfoPlugin();
      if (defaultTargetPlatform == TargetPlatform.android) {
        final androidInfo = await deviceInfo.androidInfo;
        return '${androidInfo.brand} ${androidInfo.model}';
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.utsname.machine;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[FCM] Error getting device name: $e');
      }
    }
    return defaultTargetPlatform == TargetPlatform.android ? 'Android device' : 'iOS device';
  }
}
