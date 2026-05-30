import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/app_config.dart';
import 'config/app_session.dart';
import 'routes/router.dart';
import 'routes/routes_config.dart';
import 'services/http_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppConfig.load(configFile: 'assets/config.yaml');

  await HttpService.warmUp(apiHost: AppConfig.instance.apiHost);

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C5CE7)),
        useMaterial3: true,
      ),
    );
  }
}
