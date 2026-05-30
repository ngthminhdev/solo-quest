import 'package:flutter/material.dart';

import '../services/auth_token_storage.dart';

class AppSession {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static final ValueNotifier<int> logoutSignal = ValueNotifier<int>(0);
  static final ValueNotifier<int> upgradeRequiredSignal = ValueNotifier<int>(0);

  static Future<void> handleUnauthorized() async {
    await AuthTokenStorage.clearTokens();
    logoutSignal.value++;
  }
}
