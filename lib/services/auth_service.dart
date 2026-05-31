import 'dart:convert';

import '../constants/app_constant.dart';
import '../models/auth_user_model.dart';
import 'local_storage_service.dart';

class AuthService {
  AuthService({required this.localStorageService});

  final LocalStorageService localStorageService;

  Future<AuthUserModel?> getCurrentUser() async {
    final raw = await localStorageService.getString(AppStorageKey.authUser);
    if (raw == null || raw.isEmpty) return null;
    try {
      return AuthUserModel.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  Future<bool> isAuthenticated() async {
    return await localStorageService.getBool(AppStorageKey.isAuthenticated) ==
        true;
  }

  Future<AuthUserModel> signInWithGoogleMock() async {
    await Future.delayed(const Duration(milliseconds: 1200));

    final user = const AuthUserModel(
      id: 'google_mock_user_001',
      name: 'Minh Thanh',
      email: 'minhthanh@gmail.com',
      provider: 'google',
    );

    await localStorageService.setBool(AppStorageKey.isAuthenticated, true);
    await localStorageService.setString(
      AppStorageKey.authUser,
      jsonEncode(user.toJson()),
    );

    return user;
  }

  Future<void> signOut() async {
    await localStorageService.remove(AppStorageKey.isAuthenticated);
    await localStorageService.remove(AppStorageKey.authUser);
  }
}
