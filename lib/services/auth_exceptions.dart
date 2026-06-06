enum AuthExceptionCode {
  googleConfigMissing,
  googleCancelled,
  googleUnsupported,
  googleIdTokenMissing,
  googleSignInFailed,
  googleBackendRejected,
}

class AuthException implements Exception {
  const AuthException({required this.code, required this.message});

  final AuthExceptionCode code;
  final String message;

  @override
  String toString() => message;
}
