import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/app_config.dart';
import 'config/app_session.dart';
import 'config/app_theme_registry.dart';
import 'generated/l10n/app_localizations.dart';
import 'routes/router.dart';
import 'routes/routes_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppConfig.load(configFile: 'assets/config.yaml');

  runApp(const ProviderScope(child: MyApp()));
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
