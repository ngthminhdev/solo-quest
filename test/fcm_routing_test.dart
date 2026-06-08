import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:solo_quest/generated/l10n/app_localizations.dart';
import 'package:solo_quest/config/app_config.dart';
import 'package:solo_quest/config/app_session.dart';
import 'package:solo_quest/core/notifications/fcm_notification_payload.dart';
import 'package:solo_quest/core/notifications/local_notification_service.dart';
import 'package:solo_quest/core/timer/countdown_session.dart';
import 'package:solo_quest/core/timer/countdown_timer_service.dart';
import 'package:solo_quest/routes/routes_config.dart';
import 'package:solo_quest/services/auth_service.dart';
import 'package:solo_quest/services/service_providers.dart';
import 'package:solo_quest/modules/main/main_page.dart';
import 'package:solo_quest/modules/main/main_page_model.dart';
import 'package:solo_quest/widgets/page_header/page_header.dart';

class FakeAuthService extends Fake implements AuthService {
  bool authenticated = true;
  @override
  Future<bool> isAuthenticated() async => authenticated;
}

class FakeLocalNotificationService extends Fake implements LocalNotificationService {
  final StreamController<String> _tapController = StreamController<String>.broadcast();

  @override
  Future<void> initialize() async {}

  @override
  Future<void> scheduleCountdownNotification(CountdownSession session) async {}

  @override
  Future<void> cancelCountdownNotification(String questId) async {}

  @override
  Stream<String> get onTapStream => _tapController.stream;

  void triggerTap(String payload) {
    _tapController.add(payload);
  }

  void dispose() {
    _tapController.close();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeAuthService fakeAuth;
  late FakeLocalNotificationService fakeLocalNotifications;
  String? lastNavigatedRoute;
  dynamic lastNavigatedArguments;

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    SharedPreferences.setMockInitialValues({});

    const mockYaml = '''
apiHost: "http://localhost:8080"
appVersion: "1.0.0"
env: "local"
isWriteLogToServer: false
auth:
  googleWebClientId: ""
  googleAndroidClientId: ""
  googleIosClientId: ""
''';

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      'flutter/assets',
      (message) async {
        return ByteData.view(utf8.encoder.convert(mockYaml).buffer);
      },
    );

    await AppConfig.load();

    fakeAuth = FakeAuthService();
    fakeLocalNotifications = FakeLocalNotificationService();
    lastNavigatedRoute = null;
    lastNavigatedArguments = null;
  });

  tearDown(() {
    fakeLocalNotifications.dispose();
  });

  Widget buildTestApp() {
    return MaterialApp(
      navigatorKey: AppSession.navigatorKey,
      initialRoute: '/',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('vi'),
      onGenerateRoute: (settings) {
        lastNavigatedRoute = settings.name;
        lastNavigatedArguments = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Page: ${settings.name}')),
          ),
        );
      },
    );
  }

  group('FCM Notification Routing Tests', () {
    testWidgets('quest_reminder routes to questDetail', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(fakeAuth),
            localNotificationServiceProvider.overrideWithValue(fakeLocalNotifications),
          ],
          child: buildTestApp(),
        ),
      );

      final container = ProviderScope.containerOf(tester.element(find.byType(Scaffold)));
      final fcmService = container.read(fcmServiceProvider);

      final payload = FcmNotificationPayload.fromMap({
        'event': 'quest_reminder',
        'quest_id': 'quest_123',
        'action': 'open_quest_detail',
      });

      fcmService.handleNotificationPayload(payload);
      await tester.pumpAndSettle();

      expect(lastNavigatedRoute, RoutesConfig.questDetail);
      expect(lastNavigatedArguments, {'id': 'quest_123'});
    });

    testWidgets('quest_snooze routes to questDetail', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(fakeAuth),
            localNotificationServiceProvider.overrideWithValue(fakeLocalNotifications),
          ],
          child: buildTestApp(),
        ),
      );

      final container = ProviderScope.containerOf(tester.element(find.byType(Scaffold)));
      final fcmService = container.read(fcmServiceProvider);

      final payload = FcmNotificationPayload.fromMap({
        'event': 'quest_snooze',
        'quest_id': 'quest_456',
        'action': 'open_quest_detail',
      });

      fcmService.handleNotificationPayload(payload);
      await tester.pumpAndSettle();

      expect(lastNavigatedRoute, RoutesConfig.questDetail);
      expect(lastNavigatedArguments, {'id': 'quest_456'});
    });

    testWidgets('missing quest_id falls back to Home', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(fakeAuth),
            localNotificationServiceProvider.overrideWithValue(fakeLocalNotifications),
          ],
          child: buildTestApp(),
        ),
      );

      final container = ProviderScope.containerOf(tester.element(find.byType(Scaffold)));
      final fcmService = container.read(fcmServiceProvider);

      final payload = FcmNotificationPayload.fromMap({
        'event': 'quest_reminder',
        'action': 'open_quest_detail',
      });

      fcmService.handleNotificationPayload(payload);
      await tester.pumpAndSettle();

      expect(lastNavigatedRoute, RoutesConfig.home);
    });

    testWidgets('water reminder opens water prompt on Home', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(fakeAuth),
            localNotificationServiceProvider.overrideWithValue(fakeLocalNotifications),
          ],
          child: buildTestApp(),
        ),
      );

      final container = ProviderScope.containerOf(tester.element(find.byType(Scaffold)));
      final fcmService = container.read(fcmServiceProvider);

      final payload = FcmNotificationPayload.fromMap({
        'event': 'reminder_setting',
        'reminder_type': 'water',
        'action': 'water_reminder',
      });

      fcmService.handleNotificationPayload(payload);
      await tester.pump();
      await tester.pumpAndSettle();

      expect(lastNavigatedRoute, RoutesConfig.home);
      expect(find.text('Uống nước'), findsOneWidget);
    });

    testWidgets('break_time opens break prompt and starts countdown on confirm', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(fakeAuth),
            localNotificationServiceProvider.overrideWithValue(fakeLocalNotifications),
          ],
          child: buildTestApp(),
        ),
      );

      final container = ProviderScope.containerOf(tester.element(find.byType(Scaffold)));
      final fcmService = container.read(fcmServiceProvider);

      final payload = FcmNotificationPayload.fromMap({
        'event': 'reminder_setting',
        'reminder_type': 'break_time',
        'action': 'start_break_timer',
        'countdown_enabled': 'true',
        'countdown_minutes': '5',
      });

      fcmService.handleNotificationPayload(payload);
      await tester.pump();
      await tester.pumpAndSettle();

      expect(lastNavigatedRoute, RoutesConfig.home);
      expect(find.text('Nghỉ mắt một chút'), findsOneWidget);

      // Tap confirm button
      await tester.tap(find.text('Bắt đầu nghỉ 5 phút'));
      await tester.pumpAndSettle();

      final timerState = container.read(countdownTimerServiceProvider);
      expect(timerState, isNotNull);
      expect(timerState!.reminderType, 'break_time');
      expect(timerState.durationMinutes, 5);
      expect(timerState.source, 'reminder_setting');
    });

    testWidgets('daily_review routes to review screen', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(fakeAuth),
            localNotificationServiceProvider.overrideWithValue(fakeLocalNotifications),
          ],
          child: buildTestApp(),
        ),
      );

      final container = ProviderScope.containerOf(tester.element(find.byType(Scaffold)));
      final fcmService = container.read(fcmServiceProvider);

      final payload = FcmNotificationPayload.fromMap({
        'event': 'reminder_setting',
        'reminder_type': 'daily_review',
        'action': 'daily_review_reminder',
      });

      fcmService.handleNotificationPayload(payload);
      await tester.pumpAndSettle();

      expect(lastNavigatedRoute, RoutesConfig.dailyReview);
    });

    testWidgets('unknown event routes Home', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(fakeAuth),
            localNotificationServiceProvider.overrideWithValue(fakeLocalNotifications),
          ],
          child: buildTestApp(),
        ),
      );

      final container = ProviderScope.containerOf(tester.element(find.byType(Scaffold)));
      final fcmService = container.read(fcmServiceProvider);

      final payload = FcmNotificationPayload.fromMap({
        'event': 'unknown_xyz',
      });

      fcmService.handleNotificationPayload(payload);
      await tester.pumpAndSettle();

      expect(lastNavigatedRoute, RoutesConfig.home);
    });

    testWidgets('unauthenticated tap routes to login and stores pending payload', (tester) async {
      fakeAuth.authenticated = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(fakeAuth),
            localNotificationServiceProvider.overrideWithValue(fakeLocalNotifications),
          ],
          child: buildTestApp(),
        ),
      );

      final container = ProviderScope.containerOf(tester.element(find.byType(Scaffold)));
      final fcmService = container.read(fcmServiceProvider);

      final data = {
        'event': 'quest_reminder',
        'quest_id': 'quest_abc',
      };
      
      fcmService.handleNotificationPayloadTap(FcmNotificationPayload.fromMap(data));
      await tester.pumpAndSettle();

      expect(lastNavigatedRoute, RoutesConfig.login);

      fakeAuth.authenticated = true;
      fcmService.processPendingNotificationPayload();
      tester.binding.scheduleFrame();
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpAndSettle();

      expect(lastNavigatedRoute, RoutesConfig.questDetail);
      expect(lastNavigatedArguments, {'id': 'quest_abc'});
    });
  });

  group('Main Tab Synchronization and Prompt Tests', () {
    late FakeAuthService fakeAuth;
    late FakeLocalNotificationService fakeLocalNotifications;

    setUp(() {
      fakeAuth = FakeAuthService();
      fakeLocalNotifications = FakeLocalNotificationService();
    });

    Widget buildRealMainPageApp() {
      return MaterialApp(
        navigatorKey: AppSession.navigatorKey,
        initialRoute: '/home',
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('vi'),
        onGenerateRoute: (settings) {
          lastNavigatedRoute = settings.name;
          lastNavigatedArguments = settings.arguments;
          if (settings.name == '/home') {
            return MaterialPageRoute(builder: (_) => MainPage());
          }
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(child: Text('Page: ${settings.name}')),
            ),
          );
        },
      );
    }

    testWidgets('selecting Profile shows Profile body and Profile header', (tester) async {
      final model = MainPageModel();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(fakeAuth),
            localNotificationServiceProvider.overrideWithValue(fakeLocalNotifications),
            mainPageProvider.overrideWithProvider(
              StateNotifierProvider<MainPageModel, MainPageState>((ref) {
                model.state = MainPageState(
                  listOfPages: [
                    const Text('Home Content'),
                    const Text('Logs Content'),
                    const Text('Progress Content'),
                    const Text('Learning Content'),
                    const Text('Profile Content'),
                  ],
                  selectedIndex: 0,
                  settledIndex: 0,
                );
                return model;
              }),
            ),
          ],
          child: buildRealMainPageApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Initially selected is Home (index 0)
      expect(find.descendant(of: find.byType(PageHeader), matching: find.text('Trang Chủ')), findsOneWidget); // Header title
      expect(find.text('Home Content'), findsOneWidget); // Body content

      // Go to Profile tab (index 4)
      model.goToTab(4);
      await tester.pumpAndSettle();

      expect(find.descendant(of: find.byType(PageHeader), matching: find.text('Hồ Sơ')), findsOneWidget); // Header title
      expect(find.text('Profile Content'), findsOneWidget); // Body content
    });

    testWidgets('water notification selects Home tab before showing prompt', (tester) async {
      final model = MainPageModel();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(fakeAuth),
            localNotificationServiceProvider.overrideWithValue(fakeLocalNotifications),
            mainPageProvider.overrideWithProvider(
              StateNotifierProvider<MainPageModel, MainPageState>((ref) {
                model.state = MainPageState(
                  listOfPages: [
                    const Text('Home Content'),
                    const Text('Logs Content'),
                    const Text('Progress Content'),
                    const Text('Learning Content'),
                    const Text('Profile Content'),
                  ],
                  selectedIndex: 4, // Start on Profile
                  settledIndex: 4,
                );
                return model;
              }),
            ),
          ],
          child: buildRealMainPageApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Verify we are on Profile page first
      expect(find.descendant(of: find.byType(PageHeader), matching: find.text('Hồ Sơ')), findsOneWidget);
      expect(find.text('Profile Content'), findsOneWidget);

      final container = ProviderScope.containerOf(tester.element(find.byType(MainPage)));
      final fcmService = container.read(fcmServiceProvider);

      final payload = FcmNotificationPayload.fromMap({
        'event': 'reminder_setting',
        'reminder_type': 'water',
        'action': 'water_reminder',
      });

      fcmService.handleNotificationPayload(payload);
      // Let navigation and post-frame callback run
      await tester.pump();
      await tester.pumpAndSettle();

      // Selected tab and body should both switch back to Home
      expect(find.descendant(of: find.byType(PageHeader), matching: find.text('Trang Chủ')), findsOneWidget);
      expect(find.text('Home Content'), findsOneWidget);
      
      // Prompt dialog should be shown
      expect(find.text('Uống nước'), findsOneWidget);
    });

    testWidgets('break_time notification selects Home tab before showing break prompt', (tester) async {
      final model = MainPageModel();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(fakeAuth),
            localNotificationServiceProvider.overrideWithValue(fakeLocalNotifications),
            mainPageProvider.overrideWithProvider(
              StateNotifierProvider<MainPageModel, MainPageState>((ref) {
                model.state = MainPageState(
                  listOfPages: [
                    const Text('Home Content'),
                    const Text('Logs Content'),
                    const Text('Progress Content'),
                    const Text('Learning Content'),
                    const Text('Profile Content'),
                  ],
                  selectedIndex: 4, // Start on Profile
                  settledIndex: 4,
                );
                return model;
              }),
            ),
          ],
          child: buildRealMainPageApp(),
        ),
      );

      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(tester.element(find.byType(MainPage)));
      final fcmService = container.read(fcmServiceProvider);

      final payload = FcmNotificationPayload.fromMap({
        'event': 'reminder_setting',
        'reminder_type': 'break_time',
        'action': 'start_break_timer',
        'countdown_enabled': 'true',
        'countdown_minutes': '5',
      });

      fcmService.handleNotificationPayload(payload);
      await tester.pump();
      await tester.pumpAndSettle();

      // Selected tab and body should both switch back to Home
      expect(find.descendant(of: find.byType(PageHeader), matching: find.text('Trang Chủ')), findsOneWidget);
      expect(find.text('Home Content'), findsOneWidget);

      // Prompt dialog should be shown
      expect(find.text('Nghỉ mắt một chút'), findsOneWidget);
    });
  });
}
