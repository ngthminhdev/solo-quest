import '../../services/auth_token_storage.dart';

/// Token storage for authentication
/// Compatibility wrapper around the canonical secure [AuthTokenStorage].
@Deprecated('Use AuthTokenStorage from lib/services/auth_token_storage.dart')
class TokenStorage {
  TokenStorage({AuthTokenStorage? delegate})
    : _delegate = delegate ?? AuthTokenStorage();

  final AuthTokenStorage _delegate;

  Future<void> setAccessToken(String token) => _delegate.saveAccessToken(token);

  Future<void> setRefreshToken(String token) =>
      _delegate.saveRefreshToken(token);

  Future<void> setTokens({
    required String accessToken,
    required String refreshToken,
  }) => _delegate.saveSessionTokens(
    accessToken: accessToken,
    refreshToken: refreshToken,
  );

  Future<String?> getAccessToken() => _delegate.getAccessToken();

  Future<String?> getRefreshToken() => _delegate.getRefreshToken();

  Future<bool> hasTokens() => _delegate.hasTokens();

  Future<void> clearTokens() => _delegate.clear();
}
