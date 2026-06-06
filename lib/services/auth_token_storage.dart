import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthTokenStorage {
  AuthTokenStorage({FlutterSecureStorage? secureStorage})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const FlutterSecureStorage _defaultSecureStorage =
      FlutterSecureStorage();

  final FlutterSecureStorage _secureStorage;

  Future<String?> getAccessToken() async {
    return _readToken(_accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return _readToken(_refreshTokenKey);
  }

  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: _accessTokenKey, value: token);
  }

  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _refreshTokenKey, value: token);
  }

  Future<void> saveSessionTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await saveAccessToken(accessToken);
    await saveRefreshToken(refreshToken);
  }

  Future<bool> hasTokens() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    return accessToken != null && refreshToken != null;
  }

  Future<void> clear() async {
    await _secureStorage.delete(key: _accessTokenKey);
    await _secureStorage.delete(key: _refreshTokenKey);
    await _clearLegacySharedPreferenceTokens();
  }

  static Future<void> clearTokens() async {
    await _defaultSecureStorage.delete(key: _accessTokenKey);
    await _defaultSecureStorage.delete(key: _refreshTokenKey);
    await _clearLegacySharedPreferenceTokens();
  }

  Future<String?> _readToken(String key) async {
    final secureValue = await _secureStorage.read(key: key);
    if (secureValue != null && secureValue.isNotEmpty) {
      return secureValue;
    }

    final prefs = await SharedPreferences.getInstance();
    final legacyValue = prefs.getString(key);
    if (legacyValue != null && legacyValue.isNotEmpty) {
      await _secureStorage.write(key: key, value: legacyValue);
      await prefs.remove(key);
      return legacyValue;
    }

    return null;
  }

  static Future<void> _clearLegacySharedPreferenceTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }
}
