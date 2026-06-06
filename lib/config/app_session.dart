import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

import '../constants/app_constant.dart';
import '../routes/routes_config.dart';
import '../services/auth_token_storage.dart';

class AppSession {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final ValueNotifier<int> logoutSignal = ValueNotifier<int>(0);
  static final ValueNotifier<int> upgradeRequiredSignal = ValueNotifier<int>(0);

  /// Handle 401 unauthorized response.
  /// Clears tokens, local auth state, and navigates to login.
  static Future<void> handleUnauthorized() async {
    if (kDebugMode) {
      developer.log('[AUTH] handleUnauthorized called — clearing all auth state');
    }

    await AuthTokenStorage.clearTokens();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppStorageKey.isAuthenticated);
    await prefs.remove(AppStorageKey.authUser);
    logoutSignal.value++;

    final navigator = navigatorKey.currentState;
    if (navigator != null) {
      navigator.pushNamedAndRemoveUntil(
        RoutesConfig.login,
        (route) => false,
      );
      if (kDebugMode) {
        developer.log('[AUTH] Navigated to Login via handleUnauthorized');
      }
    } else {
      if (kDebugMode) {
        developer.log('[AUTH] Navigator state is null — cannot navigate');
      }
    }
  }
}
