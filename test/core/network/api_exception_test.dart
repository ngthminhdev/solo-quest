import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/core/network/api_exception.dart';

void main() {
  group('ApiException.fromJson', () {
    test('parses backend error response correctly', () {
      final json = {
        'error': 'validation_error',
        'message': 'Invalid input data',
      };

      final exception = ApiException.fromJson(json, statusCode: 400);

      expect(exception.statusCode, 400);
      expect(exception.error, 'validation_error');
      expect(exception.message, 'Invalid input data');
    });

    test('handles missing error field safely', () {
      final json = {
        'message': 'Something went wrong',
      };

      final exception = ApiException.fromJson(json);

      expect(exception.error, 'unknown_error');
      expect(exception.message, 'Something went wrong');
    });

    test('handles missing message field safely', () {
      final json = {
        'error': 'server_error',
      };

      final exception = ApiException.fromJson(json);

      expect(exception.error, 'server_error');
      expect(exception.message, 'An unknown error occurred');
    });

    test('handles empty JSON safely', () {
      final json = <String, dynamic>{};

      final exception = ApiException.fromJson(json);

      expect(exception.error, 'unknown_error');
      expect(exception.message, 'An unknown error occurred');
    });

    test('includes raw body when provided', () {
      final json = {
        'error': 'test_error',
        'message': 'Test message',
      };

      final exception = ApiException.fromJson(json, rawBody: '{"raw":"body"}');

      expect(exception.rawBody, '{"raw":"body"}');
    });
  });

  group('ApiException factory constructors', () {
    test('network creates network error', () {
      final exception = ApiException.network();

      expect(exception.error, 'network_error');
      expect(exception.message, 'No internet connection');
      expect(exception.statusCode, isNull);
    });

    test('timeout creates timeout error', () {
      final exception = ApiException.timeout();

      expect(exception.error, 'timeout_error');
      expect(exception.message, 'Request timeout');
      expect(exception.statusCode, isNull);
    });

    test('invalidJson creates invalid JSON error', () {
      final exception = ApiException.invalidJson('not json');

      expect(exception.error, 'invalid_json');
      expect(exception.message, 'Invalid JSON response from server');
      expect(exception.rawBody, 'not json');
    });

    test('unauthorized creates 401 error', () {
      final exception = ApiException.unauthorized();

      expect(exception.statusCode, 401);
      expect(exception.error, 'unauthorized');
      expect(exception.message, 'Unauthorized');
    });

    test('serverError creates server error', () {
      final exception = ApiException.serverError(500, 'Internal Server Error');

      expect(exception.statusCode, 500);
      expect(exception.error, 'server_error');
      expect(exception.message, 'Server error: 500');
      expect(exception.rawBody, 'Internal Server Error');
    });
  });

  group('ApiException.toString', () {
    test('formats exception as string', () {
      final exception = ApiException(
        statusCode: 400,
        error: 'test_error',
        message: 'Test message',
      );

      final result = exception.toString();

      expect(result, contains('400'));
      expect(result, contains('test_error'));
      expect(result, contains('Test message'));
    });
  });
}
