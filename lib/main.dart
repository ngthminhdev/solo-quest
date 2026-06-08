import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'config/app_config.dart';
import 'config/app_session.dart';
import 'config/app_theme_registry.dart';
import 'generated/l10n/app_localizations.dart';
import 'routes/router.dart';
import 'routes/routes_config.dart';
import 'services/http_services.dart';
import 'services/service_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  const configFile = String.fromEnvironment('APP_CONFIG_FILE', defaultValue: 'assets/config.yaml');
  await AppConfig.load(configFile: configFile);
  HttpService.setSharedHost(AppConfig.instance.apiHost);

  debugPrint('[CONFIG] API Host: ${AppConfig.instance.apiHost}');

  final container = ProviderContainer();
  await container.read(localNotificationServiceProvider).initialize();

  runApp(ProviderScope(parent: container, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solo Quest',
      navigatorKey: AppSession.navigatorKey,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: RoutesConfig.splash,
      theme: AppThemeRegistry.darkTheme,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('vi'),
    );
  }
}
