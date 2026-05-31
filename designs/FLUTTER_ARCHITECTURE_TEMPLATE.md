# Flutter Architecture Template - Mine Wallet Pattern

## 📁 Project Structure

```
lib/
├── main.dart                    # Entry point, load config, init services
├── base/                        # Base classes cho toàn bộ app
│   ├── base_page.dart          # BasePage<T, S> extends ConsumerStatefulWidget
│   ├── base_page_state.dart    # BasePageConsumerState<T, S> với helper methods
│   ├── base_page_model.dart    # BasePageModel extends StateNotifier<S>
│   ├── base_service.dart       # Base service class (nếu cần)
│   └── app_load_state.dart     # Enum: idle, loading, ready, error
├── config/                      # App configuration & global state
│   ├── app_config.dart         # Load từ YAML (apiHost, version, env)
│   ├── app_session.dart        # Session management, logout signal, navigatorKey
│   ├── app_global.dart         # Global data (wallets, user, categories)
│   └── app_theme_registry.dart # Theme registration
├── constants/                   # App-wide constants
│   ├── app_constant.dart       # Business constants
│   └── app_color.dart          # Color definitions
├── models/                      # Data models
│   ├── user_model.dart
│   ├── transaction_model.dart
│   └── api/                    # API-specific models
├── services/                    # Service layer
│   ├── http_services.dart      # Base HTTP service với builder pattern
│   ├── *_http_service.dart     # Domain-specific HTTP services
│   ├── local_storage_service.dart  # SharedPreferences wrapper
│   ├── auth_token_storage.dart     # JWT token management
│   ├── app_logger_service.dart     # Logging service
│   ├── app_log_queue_service.dart  # Log queue for remote logging
│   ├── push_notification_service.dart  # Firebase messaging
│   └── google_login_service.dart   # Google Sign-In
├── routes/                      # Navigation
│   ├── routes_config.dart      # Named route definitions
│   └── router.dart             # Route handler logic
├── modules/                     # Feature modules (MVVM pattern)
│   ├── splash/
│   │   ├── splash_page.dart
│   │   └── splash_page_model.dart
│   ├── auth/
│   │   ├── welcome_page.dart
│   │   └── welcome_page_model.dart
│   ├── home/
│   │   ├── home_page.dart
│   │   ├── home_page_model.dart
│   │   └── constants/
│   └── [feature]/
│       ├── [feature]_page.dart       # View (extends BasePage)
│       └── [feature]_page_model.dart # ViewModel + State
├── widgets/                     # Reusable widgets
│   ├── app_button/
│   ├── app_dialog/
│   ├── loading/
│   └── [widget_name]/
├── helpers/                     # Helper utilities
│   ├── date_helper.dart
│   ├── number_helper.dart
│   └── device_helper.dart
└── utils/                       # Utility functions
    ├── format_utils.dart
    └── subscription_utils.dart
```

## 🏗️ Architecture Pattern: MVVM + Riverpod

### State Management Flow

```
User Action → Page (View) → PageModel (ViewModel) → Service Layer → API
                ↑                                                      ↓
                └──────────── State Update ←─────────────────────────┘
```

### Core Components

#### 1. **Base Page Pattern**

```dart
// base/base_page.dart
abstract class BasePage<T extends StateNotifier<S>, S> extends ConsumerStatefulWidget {
  final ProviderListenable<S> provider;
  final Refreshable<T> notifierProvider;
  
  BasePage({required StateNotifierProvider<T, S> provider});
  BasePage.autoDispose({required AutoDisposeStateNotifierProvider<T, S> provider});
}

// base/base_page_state.dart
abstract class BasePageConsumerState<T extends StateNotifier<S>, S> 
    extends ConsumerState<BasePage<T, S>> with AutomaticKeepAliveClientMixin {
  
  T get pageModel => ref.read(widget.notifierProvider);  // Access notifier
  S get read => ref.read(widget.provider);               // Read state once
  void listen(void Function(S? previous, S next) listener) => 
      ref.listen(widget.provider, listener);             // Listen to changes
  
  Widget renderPage(BuildContext context);  // Abstract - implement UI
  void onBuild() {}  // Hook before build
  
  @override
  bool get wantKeepAlive => true;  // Keep alive in PageView
}
```

#### 2. **State + ViewModel Pattern**

```dart
// modules/[feature]/[feature]_page_model.dart

// 1. State class - immutable data container
class FeaturePageState extends BasePageState {
  final List<Item> items;
  final int currentPage;
  final bool isLoading;
  final AppLoadState loadState;
  
  FeaturePageState({
    required this.items,
    required this.currentPage,
    required this.isLoading,
    this.loadState = AppLoadState.idle,
    super.isLockedPage,
  });
  
  @override
  FeaturePageState updateState({
    List<Item>? items,
    int? currentPage,
    bool? isLoading,
    AppLoadState? loadState,
    bool? isLockedPage,
  }) {
    return FeaturePageState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
      loadState: loadState ?? this.loadState,
      isLockedPage: isLockedPage ?? this.isLockedPage,
    );
  }
}

// 2. ViewModel - business logic
class FeaturePageModel extends BasePageModel<FeaturePageState> {
  FeaturePageModel() : super(FeaturePageState(
    items: const [],
    currentPage: 0,
    isLoading: false,
    loadState: AppLoadState.idle,
  ));
  
  Future<void> fetchItems({bool reset = false}) async {
    if (state.isLoading) return;
    
    state = state.updateState(
      isLoading: true,
      loadState: AppLoadState.loading,
    );
    
    try {
      final response = await ItemHttpService.getItems(page: state.currentPage + 1);
      final fetched = response.data?.items ?? [];
      
      state = state.updateState(
        items: reset ? fetched : [...state.items, ...fetched],
        currentPage: state.currentPage + 1,
        isLoading: false,
        loadState: AppLoadState.ready,
      );
    } catch (e) {
      state = state.updateState(
        isLoading: false,
        loadState: AppLoadState.error,
      );
    }
  }
  
  FeaturePageState get readState => state;
}

// 3. Provider declaration
final featurePageProvider = StateNotifierProvider<FeaturePageModel, FeaturePageState>(
  (ref) => FeaturePageModel()
);
```

#### 3. **Page Implementation**

```dart
// modules/[feature]/[feature]_page.dart
class FeaturePage extends BasePage<FeaturePageModel, FeaturePageState> {
  FeaturePage({super.key}) : super(provider: featurePageProvider);
  
  @override
  ConsumerState<FeaturePage> createState() => _FeaturePageState();
}

class _FeaturePageState extends BasePageConsumerState<FeaturePageModel, FeaturePageState> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageModel.fetchItems();
    });
  }
  
  @override
  void onBuild() {
    // Listen to state changes
    listen((previous, next) {
      if (next.loadState == AppLoadState.error) {
        // Show error toast
      }
    });
  }
  
  @override
  Widget renderPage(BuildContext context) {
    final state = read;  // Get current state
    
    return Scaffold(
      appBar: AppBar(title: Text('Feature')),
      body: state.loadState == AppLoadState.loading
          ? LoadingWidget()
          : ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (context, index) => ItemWidget(state.items[index]),
            ),
    );
  }
}
```

## 🌐 HTTP Service Layer

### Base HTTP Service (Builder Pattern)

```dart
// services/http_services.dart - Key features:
// - Shared IOClient với connection pooling
// - Automatic JWT injection từ SharedPreferences
// - Auto-handle 401: refresh token hoặc logout
// - Request/response logging với performance tracking
// - Retry logic cho SocketException/HttpException

class HttpService {
  static http.Client _sharedClient = _createClient();
  
  String host = '';
  String method = '';
  Map<String, dynamic> body = {};
  Map<String, String?> queries = {};
  List<String?> paths = ['api'];
  
  // Builder methods
  HttpService withHost(String apiHost) { host = apiHost; return this; }
  HttpService withVersion(String version) { paths.add(version); return this; }
  HttpService withPath(String? path) { paths.add(path); return this; }
  HttpService makeGet() { method = 'GET'; return this; }
  HttpService makePost() { method = 'POST'; return this; }
  HttpService makePut() { method = 'PUT'; return this; }
  HttpService makeDelete() { method = 'DELETE'; return this; }
  HttpService withBody(Map<String, dynamic> data) { body.addAll(data); return this; }
  HttpService withQueries(Map<String, String?> data) { queries.addAll(data); return this; }
  HttpService skipUnauthorizedHandler() { _skipUnauthorizedHandler = true; return this; }
  
  // Execute
  Future<Response<dynamic>> execute({int timeout = 240});
  Future<Response<T>> executeModel<T>(T Function(dynamic json) fromJsonT, {int timeout = 240});
  
  // Static helpers
  static Future<void> warmUp({required String apiHost, String path = 'health', int count = 3});
  static void resetClient();
}

// Response wrapper
class Response<T> {
  final int? code;
  final String? message;
  final T? data;
  
  Response({this.code, this.message, this.data});
  
  factory Response.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT);
  Response<R> cast<R>(R Function(dynamic json) fromJsonR);
}
```

### Domain HTTP Services

```dart
// services/[domain]_http_service.dart
class UserHttpService {
  static Future<Response<UserProfileData>> getProfile() {
    return HttpService()
        .withHost(AppConfig.instance.apiHost)
        .withVersion('v1')
        .withPath('users')
        .withPath('me')
        .withPath('profile')
        .makeGet()
        .executeModel(UserProfileData.fromJson);
  }
  
  static Future<Response<UserProfileData>> updateProfile({
    String? username,
    String? avatarUrl,
  }) {
    return HttpService()
        .withHost(AppConfig.instance.apiHost)
        .withVersion('v1')
        .withPath('users')
        .withPath('me')
        .withPath('profile')
        .makePut()
        .withBody({
          if (username != null) 'username': username,
          if (avatarUrl != null) 'avatar_url': avatarUrl,
        })
        .executeModel(UserProfileData.fromJson);
  }
}
```

## 💾 Local Storage

### SharedPreferences Wrapper

```dart
// services/local_storage_service.dart
class LocalStorageService {
  Future<bool> setString(String key, String value) async {
    SharedPreferences local = await SharedPreferences.getInstance();
    return local.setString(key, value);
  }
  
  Future<String?> getString(String key) async {
    SharedPreferences local = await SharedPreferences.getInstance();
    return local.getString(key);
  }
  
  // setInt, getInt, setDouble, getDouble, setBool, getBool, remove...
}
```

### JWT Token Storage

```dart
// services/auth_token_storage.dart
class AuthTokenStorage {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }
  
  static Future<void> saveSessionTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
  }
  
  static Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }
}
```

## 🔧 Configuration Management

### App Config (YAML-based)

```dart
// config/app_config.dart
class AppConfig {
  static AppConfig? _instance;
  static AppConfig get instance => _instance!;
  
  final String apiHost;
  final String appVersion;
  final String env;  // local, development, production
  final bool isWriteLogToServer;
  
  String get scheme => env == 'local' ? 'http' : 'https';
  int get versionCode => parseVersionCode(appVersion);
  
  static Future<void> load({String configFile = 'assets/config.yaml'}) async {
    final yamlString = await rootBundle.loadString(configFile);
    final yamlMap = loadYaml(yamlString) as YamlMap;
    _instance = AppConfig._(
      apiHost: yamlMap['apiHost'] as String,
      appVersion: (yamlMap['appVersion'] ?? '1.0.0').toString(),
      env: (yamlMap['env'] ?? 'production').toString(),
      isWriteLogToServer: parseBoolFlag(yamlMap['isWriteLogToServer'], defaultValue: true),
    );
  }
}
```

```yaml
# assets/config.yaml
apiHost: "api.production.com"
appVersion: "1.2.3"
env: "production"
isWriteLogToServer: true
```

### Session Management

```dart
// config/app_session.dart
class AppSession {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final ValueNotifier<int> logoutSignal = ValueNotifier<int>(0);
  static final ValueNotifier<int> upgradeRequiredSignal = ValueNotifier<int>(0);
  
  static Future<void> handleUnauthorized() async {
    await AuthTokenStorage.clearTokens();
    logoutSignal.value++;
  }
}
```

## 🧭 Navigation

### Route Configuration

```dart
// routes/routes_config.dart
class RoutesConfig {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String main = '/main';
  static const String transactionDetail = '/transaction-detail';
  static const String settings = '/settings';
}
```

### Router Implementation

```dart
// routes/router.dart
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesConfig.splash:
        return MaterialPageRoute(builder: (_) => SplashPage());
      case RoutesConfig.welcome:
        return MaterialPageRoute(builder: (_) => WelcomePage());
      case RoutesConfig.main:
        return MaterialPageRoute(builder: (_) => MainPage());
      case RoutesConfig.transactionDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => TransactionDetailPage(transactionId: args?['id']),
        );
      default:
        return MaterialPageRoute(builder: (_) => NotFoundPage());
    }
  }
}
```

## 📱 Push Notifications (Firebase)

```dart
// services/push_notification_service.dart
class PushNotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  
  static Future<void> initialize() async {
    await _messaging.requestPermission();
    
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle foreground message
    });
    
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle notification tap when app is in background
    });
  }
  
  static Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}
```

## 📊 Logging Service

```dart
// services/app_logger_service.dart
void log(
  String message, {
  String? name,
  int level = 0,  // 0: info, 900: warning, 1000: error
  Object? error,
  StackTrace? stackTrace,
}) {
  // Log to console
  print('[$name] $message');
  
  // Queue for remote logging if enabled
  if (AppConfig.instance.isWriteLogToServer) {
    AppLogQueueService.instance.enqueue(
      LogQueueEntry(
        name: name ?? 'app',
        message: message,
        level: level,
        timestamp: DateTime.now(),
      ),
    );
  }
}
```

## 🎨 Theme System

```dart
// services/app_theme_service.dart
class AppThemeService {
  static AppThemeService? _instance;
  static AppThemeService get instance => _instance!;
  
  final ValueNotifier<String> themeNotifier = ValueNotifier<String>('dracula');
  
  void setTheme(String themeId) {
    themeNotifier.value = themeId;
    // Save to SharedPreferences
  }
}

// config/app_theme_registry.dart
class AppThemeRegistry {
  static final Map<String, AppTheme> themes = {
    'dracula': DraculaTheme(),
    'tokyonight': TokyonightTheme(),
    'cosmic_dusk': CosmicDuskTheme(),
  };
}
```

## 🔑 Key Principles

### 1. **Separation of Concerns**
- **View (Page)**: UI rendering only, no business logic
- **ViewModel (PageModel)**: Business logic, state management
- **Service**: API calls, data persistence
- **Model**: Data structures

### 2. **Immutable State**
- State classes are immutable
- Use `updateState()` method để tạo state mới
- Riverpod tự động rebuild UI khi state thay đổi

### 3. **Single Source of Truth**
- Mỗi feature có 1 provider duy nhất
- Global data trong `AppGlobal`
- Session state trong `AppSession`

### 4. **Error Handling**
- HTTP service tự động handle 401, 503, timeout
- AppLoadState để track loading/error states
- Try-catch trong ViewModel, không throw lên View

### 5. **Performance**
- Shared HTTP client với connection pooling
- `wantKeepAlive = true` cho PageView tabs
- Lazy loading với pagination
- Connection pool warm-up khi app khởi động

## 🚀 Initialization Flow

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Load config
  const configFile = String.fromEnvironment(
    'APP_CONFIG_FILE',
    defaultValue: 'assets/config.yaml',
  );
  await AppConfig.load(configFile: configFile);
  
  // 2. Initialize services
  await PushNotificationService.initialize();
  AppThemeService.initialize();
  AppLogQueueService.initialize();
  
  // 3. Warm up HTTP connection pool
  await HttpService.warmUp(apiHost: AppConfig.instance.apiHost);
  
  // 4. Run app
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppSession.navigatorKey,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: RoutesConfig.splash,
    );
  }
}
```

## 📦 Essential Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.6.1      # State management
  http: ^1.2.2                  # HTTP client
  shared_preferences: ^2.3.2    # Local storage
  firebase_messaging: ^16.1.3   # Push notifications
  google_sign_in: ^6.3.0        # Google auth
  yaml: ^3.1.2                  # Config parsing
  intl: ^0.20.2                 # Formatting (currency, date)
```

## 🎯 Usage Example

### Creating a New Feature

1. **Create model** in `lib/models/[feature]_model.dart`
2. **Create HTTP service** in `lib/services/[feature]_http_service.dart`
3. **Create state + viewmodel** in `lib/modules/[feature]/[feature]_page_model.dart`
4. **Create page** in `lib/modules/[feature]/[feature]_page.dart`
5. **Add route** in `lib/routes/routes_config.dart` và `router.dart`

---

**Template này capture toàn bộ architecture patterns, service layers, và best practices từ Mine Wallet project. Sử dụng làm blueprint khi init Flutter project mới với MVVM + Riverpod pattern.**
