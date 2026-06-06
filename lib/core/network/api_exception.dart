/// Exception thrown when API requests fail
class ApiException implements Exception {
  final int? statusCode;
  final String error;
  final String message;
  final String? rawBody;

  ApiException({
    this.statusCode,
    required this.error,
    required this.message,
    this.rawBody,
  });

  /// Parse backend error response
  /// Expected format: {"error": "short_error_code", "message": "Human readable message"}
  factory ApiException.fromJson(Map<String, dynamic> json, {int? statusCode, String? rawBody}) {
    return ApiException(
      statusCode: statusCode,
      error: json['error'] as String? ?? 'unknown_error',
      message: json['message'] as String? ?? 'An unknown error occurred',
      rawBody: rawBody,
    );
  }

  /// Network error (no connection)
  factory ApiException.network() {
    return ApiException(
      error: 'network_error',
      message: 'No internet connection',
    );
  }

  /// Timeout error
  factory ApiException.timeout() {
    return ApiException(
      error: 'timeout_error',
      message: 'Request timeout',
    );
  }

  /// Invalid JSON response
  factory ApiException.invalidJson(String rawBody) {
    return ApiException(
      error: 'invalid_json',
      message: 'Invalid JSON response from server',
      rawBody: rawBody,
    );
  }

  /// Unauthorized (401)
  factory ApiException.unauthorized() {
    return ApiException(
      statusCode: 401,
      error: 'unauthorized',
      message: 'Unauthorized',
    );
  }

  /// Generic server error
  factory ApiException.serverError(int statusCode, String rawBody) {
    return ApiException(
      statusCode: statusCode,
      error: 'server_error',
      message: 'Server error: $statusCode',
      rawBody: rawBody,
    );
  }

  @override
  String toString() {
    return 'ApiException(statusCode: $statusCode, error: $error, message: $message)';
  }
}
