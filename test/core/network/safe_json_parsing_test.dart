import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/services/http_services.dart';

/// Tests for safe JSON parsing behavior in HTTP responses.
/// Verifies that non-JSON response bodies (e.g. "404 page not found")
/// do not cause FormatException crashes.
void main() {
  group('Safe JSON parsing', () {
    test('valid JSON map parses correctly', () {
      const body = '{"error":"test_error","message":"Test message"}';
      final parsed = safeParseJson(body);
      expect(parsed, isA<Map<String, dynamic>>());
      expect((parsed as Map<String, dynamic>)['error'], 'test_error');
    });

    test('non-JSON plain text returns null without throwing FormatException', () {
      const body = '404 page not found';
      expect(() => safeParseJson(body), returnsNormally);
      expect(safeParseJson(body), isNull);
    });

    test('empty string returns null', () {
      const body = '';
      expect(safeParseJson(body), isNull);
    });

    test('HTML response returns null without throwing', () {
      const body = '<html><body><h1>404 Not Found</h1></body></html>';
      expect(() => safeParseJson(body), returnsNormally);
      expect(safeParseJson(body), isNull);
    });

    test('JSON array parses correctly', () {
      const body = '[1,2,3]';
      final parsed = safeParseJson(body);
      expect(parsed, isA<List>());
    });

    test('malformed JSON returns null without throwing', () {
      const body = '{"error": "unclosed';
      expect(() => safeParseJson(body), returnsNormally);
      expect(safeParseJson(body), isNull);
    });

    test('whitespace-only string returns null', () {
      const body = '   ';
      expect(safeParseJson(body), isNull);
    });
  });

  group('Auth token masking', () {
    test('Bearer token is masked correctly', () {
      const auth = 'Bearer abc123def456ghi789xyz';
      expect(maskAuthHeader(auth), 'Bearer abc123...9xyz');
    });

    test('short token is fully masked', () {
      const auth = 'Bearer shorttoken';
      expect(maskAuthHeader(auth), 'Bearer ***');
    });

    test('null returns none', () {
      expect(maskAuthHeader(null), 'none');
    });

    test('empty returns none', () {
      expect(maskAuthHeader(''), 'none');
    });
  });

  group('HTTP response log sanitizer', () {
    test('masks nested access_token and refresh_token in JSON', () {
      final jsonStr = jsonEncode({
        'code': 200,
        'message': 'Success',
        'data': {
          'access_token': 'secret-jwt-token-123456',
          'refresh_token': 'secret-refresh-token-7890',
          'token_type': 'Bearer',
          'user': {
            'id': 'u1',
            'email': 'user@example.com',
            'has_completed_onboarding': false,
          }
        }
      });

      final sanitized = HttpService.sanitizeResponseBody(jsonStr);
      final decoded = jsonDecode(sanitized) as Map<String, dynamic>;

      expect(decoded['code'], 200);
      expect(decoded['message'], 'Success');
      expect((decoded['data'] as Map)['access_token'], '***masked***');
      expect((decoded['data'] as Map)['refresh_token'], '***masked***');
      expect((decoded['data'] as Map)['token_type'], 'Bearer');
      expect(((decoded['data'] as Map)['user'] as Map)['email'], 'user@example.com');
      expect(((decoded['data'] as Map)['user'] as Map)['has_completed_onboarding'], isFalse);
    });

    test('masks case-insensitive and normalized underscore/camelCase sensitive keys', () {
      final jsonStr = jsonEncode({
        'ACCESS_TOKEN': 'val1',
        'refreshToken': 'val2',
        'id_Token': 'val3',
        'Client_Secret': 'val4',
        'apiKey': 'val5',
        'password': 'val6',
        'safeField': 'keepMe',
      });

      final sanitized = HttpService.sanitizeResponseBody(jsonStr);
      final decoded = jsonDecode(sanitized) as Map<String, dynamic>;

      expect(decoded['ACCESS_TOKEN'], '***masked***');
      expect(decoded['refreshToken'], '***masked***');
      expect(decoded['id_Token'], '***masked***');
      expect(decoded['Client_Secret'], '***masked***');
      expect(decoded['apiKey'], '***masked***');
      expect(decoded['password'], '***masked***');
      expect(decoded['safeField'], 'keepMe');
    });

    test('masks token-like fields in raw text using regex fallback', () {
      const rawText = 'Error: access_token=jwt123, status=400, refresh_token: "refresh456"';
      final sanitized = HttpService.sanitizeResponseBody(rawText);
      expect(sanitized, contains('access_token=***masked***'));
      expect(sanitized, contains('status=400'));
      expect(sanitized, contains('refresh_token: "***masked***"'));
    });

    test('does not modify safe normal fields or structure', () {
      final jsonStr = jsonEncode({
        'code': 200,
        'data': {
          'user': {
            'level': 5,
            'streak': 12,
          }
        }
      });
      final sanitized = HttpService.sanitizeResponseBody(jsonStr);
      expect(sanitized, jsonStr);
    });
  });
}

/// Mirrors HttpService._safeParseJson logic
dynamic safeParseJson(String body) {
  if (body.isEmpty) return null;
  try {
    return jsonDecode(body);
  } on FormatException {
    return null;
  }
}

/// Mirrors HttpService._maskAuthHeader logic
String maskAuthHeader(String? authHeader) {
  if (authHeader == null || authHeader.isEmpty) return 'none';
  if (authHeader.startsWith('Bearer ')) {
    final token = authHeader.substring(7);
    if (token.length > 12) {
      return 'Bearer ${token.substring(0, 6)}...${token.substring(token.length - 4)}';
    }
    return 'Bearer ***';
  }
  return authHeader;
}
