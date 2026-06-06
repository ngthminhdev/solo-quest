import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/core/utils/date_time_parser.dart';

void main() {
  group('parseUtcDateTime', () {
    test('parses UTC timestamp correctly', () {
      final result = parseUtcDateTime('2026-06-01T10:30:00Z');
      expect(result, isNotNull);
      expect(result!.isUtc, isTrue);
      expect(result.year, 2026);
      expect(result.month, 6);
      expect(result.day, 1);
      expect(result.hour, 10);
      expect(result.minute, 30);
      expect(result.second, 0);
    });

    test('parses timestamp without Z suffix', () {
      final result = parseUtcDateTime('2026-06-01T10:30:00');
      expect(result, isNotNull);
      expect(result!.isUtc, isTrue);
    });

    test('returns null for null input', () {
      final result = parseUtcDateTime(null);
      expect(result, isNull);
    });

    test('returns null for empty string', () {
      final result = parseUtcDateTime('');
      expect(result, isNull);
    });

    test('returns null for invalid format', () {
      final result = parseUtcDateTime('invalid-date');
      expect(result, isNull);
    });
  });

  group('parseUtcDateOnly', () {
    test('parses date-only string as UTC midnight', () {
      final result = parseUtcDateOnly('2026-06-01');
      expect(result, isNotNull);
      expect(result!.isUtc, isTrue);
      expect(result.year, 2026);
      expect(result.month, 6);
      expect(result.day, 1);
      expect(result.hour, 0);
      expect(result.minute, 0);
      expect(result.second, 0);
    });

    test('parses timestamp with time component', () {
      final result = parseUtcDateOnly('2026-06-01T10:30:00Z');
      expect(result, isNotNull);
      expect(result!.isUtc, isTrue);
      expect(result.hour, 10);
    });

    test('returns null for null input', () {
      final result = parseUtcDateOnly(null);
      expect(result, isNull);
    });

    test('returns null for empty string', () {
      final result = parseUtcDateOnly('');
      expect(result, isNull);
    });

    test('returns null for invalid format', () {
      final result = parseUtcDateOnly('invalid-date');
      expect(result, isNull);
    });
  });

  group('formatUtcDateTime', () {
    test('formats DateTime to ISO8601 string', () {
      final dateTime = DateTime.utc(2026, 6, 1, 10, 30, 0);
      final result = formatUtcDateTime(dateTime);
      expect(result, '2026-06-01T10:30:00.000Z');
    });

    test('converts local DateTime to UTC before formatting', () {
      final dateTime = DateTime(2026, 6, 1, 10, 30, 0);
      final result = formatUtcDateTime(dateTime);
      expect(result, isNotNull);
      expect(result, contains('2026-06-01'));
    });

    test('returns null for null input', () {
      final result = formatUtcDateTime(null);
      expect(result, isNull);
    });
  });

  group('formatUtcDateOnly', () {
    test('formats DateTime to date-only string', () {
      final dateTime = DateTime.utc(2026, 6, 1, 10, 30, 0);
      final result = formatUtcDateOnly(dateTime);
      expect(result, '2026-06-01');
    });

    test('formats single-digit month and day with leading zeros', () {
      final dateTime = DateTime.utc(2026, 3, 5);
      final result = formatUtcDateOnly(dateTime);
      expect(result, '2026-03-05');
    });

    test('returns null for null input', () {
      final result = formatUtcDateOnly(null);
      expect(result, isNull);
    });
  });
}
