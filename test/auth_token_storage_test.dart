import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:solo_quest/services/auth_token_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    SharedPreferences.setMockInitialValues({});
  });

  test('saves and reads tokens from secure storage', () async {
    final storage = AuthTokenStorage();

    await storage.saveSessionTokens(
      accessToken: 'access-1',
      refreshToken: 'refresh-1',
    );

    expect(await storage.getAccessToken(), 'access-1');
    expect(await storage.getRefreshToken(), 'refresh-1');
    expect(await storage.hasTokens(), isTrue);
  });

  test('clears secure tokens and auth state', () async {
    final storage = AuthTokenStorage();

    await storage.saveSessionTokens(
      accessToken: 'access-2',
      refreshToken: 'refresh-2',
    );
    await storage.clear();

    expect(await storage.getAccessToken(), isNull);
    expect(await storage.getRefreshToken(), isNull);
    expect(await storage.hasTokens(), isFalse);
  });

  test('migrates legacy SharedPreferences token keys on read', () async {
    SharedPreferences.setMockInitialValues({
      'access_token': 'legacy-access',
      'refresh_token': 'legacy-refresh',
    });

    final storage = AuthTokenStorage();

    expect(await storage.getAccessToken(), 'legacy-access');
    expect(await storage.getRefreshToken(), 'legacy-refresh');
    expect(await storage.hasTokens(), isTrue);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('access_token'), isNull);
    expect(prefs.getString('refresh_token'), isNull);
  });
}
