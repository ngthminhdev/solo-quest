import 'package:flutter/material.dart';

import '../modules/splash/splash_page.dart';
import '../modules/home/home_page.dart';
import 'routes_config.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesConfig.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case RoutesConfig.main:
        return MaterialPageRoute(builder: (_) => const HomePage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found: ${settings.name}')),
          ),
        );
    }
  }
}
