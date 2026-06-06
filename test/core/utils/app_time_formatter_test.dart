import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/core/utils/app_time_formatter.dart';

void main() {
  group('AppTimeFormatter parsing', () {
    test('parseBackendDateTime parses UTC timestamp', () {
      final result = AppTimeFormatter.parseBackendDateTime('2026-06-02T09:30:00Z');
      expect(result, isNotNull);
      expect(result!.isUtc, isTrue);
      expect(result.year, 2026);
      expect(result.month, 6);
      expect(result.day, 2);
      expect(result.hour, 9);
      expect(result.minute, 30);
    });

    test('parseBackendDateTime returns null for null', () {
      expect(AppTimeFormatter.parseBackendDateTime(null), isNull);
    });

    test('parseBackendDateTime returns null for empty', () {
      expect(AppTimeFormatter.parseBackendDateTime(''), isNull);
    });

    test('parseBackendDateTime returns null for invalid', () {
      expect(AppTimeFormatter.parseBackendDateTime('not-a-date'), isNull);
    });

    test('parseBackendDateOnly parses date-only string', () {
      final result = AppTimeFormatter.parseBackendDateOnly('2026-06-02');
      expect(result, isNotNull);
      expect(result!.year, 2026);
      expect(result.month, 6);
      expect(result.day, 2);
      expect(result.hour, 0);
      expect(result.minute, 0);
    });

    test('parseBackendDateOnly preserves date without timezone shift', () {
      final result = AppTimeFormatter.parseBackendDateOnly('2026-06-02');
      expect(result!.isUtc, isTrue);
      expect(result.year, 2026);
      expect(result.month, 6);
      expect(result.day, 2);
    });
  });

  group('AppTimeFormatter conversion', () {
    test('toLocalDisplay converts UTC to local', () {
      final utc = DateTime.utc(2026, 6, 2, 9, 30, 0);
      final local = AppTimeFormatter.toLocalDisplay(utc);
      expect(local, isNotNull);
      expect(local!.isUtc, isFalse);
    });

    test('toLocalDisplay returns null for null', () {
      expect(AppTimeFormatter.toLocalDisplay(null), isNull);
    });

    test('toUtcStorage converts to UTC', () {
      final local = DateTime(2026, 6, 2, 9, 30, 0);
      final utc = AppTimeFormatter.toUtcStorage(local);
      expect(utc, isNotNull);
      expect(utc!.isUtc, isTrue);
    });

    test('toUtcStorage returns null for null', () {
      expect(AppTimeFormatter.toUtcStorage(null), isNull);
    });
  });

  group('AppTimeFormatter formatting', () {
    test('formatLocalTime formats time in local', () {
      final dt = DateTime(2026, 6, 2, 9, 30, 0);
      final result = AppTimeFormatter.formatLocalTime(dt);
      expect(result, '09:30');
    });

    test('formatLocalTime pads single digits', () {
      final dt = DateTime(2026, 6, 2, 5, 5, 0);
      final result = AppTimeFormatter.formatLocalTime(dt);
      expect(result, '05:05');
    });

    test('formatLocalTime returns null for null', () {
      expect(AppTimeFormatter.formatLocalTime(null), isNull);
    });

    test('formatLocalDate formats date correctly', () {
      final dt = DateTime(2026, 6, 2);
      final result = AppTimeFormatter.formatLocalDate(dt);
      expect(result, '02/06/2026');
    });

    test('formatLocalDate returns null for null', () {
      expect(AppTimeFormatter.formatLocalDate(null), isNull);
    });

    test('formatLocalDateTime formats full datetime', () {
      final dt = DateTime(2026, 6, 2, 14, 30, 0);
      final result = AppTimeFormatter.formatLocalDateTime(dt);
      expect(result, '02/06/2026 14:30');
    });

    test('formatLocalDateTime returns null for null', () {
      expect(AppTimeFormatter.formatLocalDateTime(null), isNull);
    });

    test('formatDateOnly formats date only without timezone shift', () {
      final dt = DateTime.utc(2026, 6, 2, 23, 0, 0);
      final result = AppTimeFormatter.formatDateOnly(dt);
      expect(result, '2026-06-02');
    });

    test('formatDateOnly returns null for null', () {
      expect(AppTimeFormatter.formatDateOnly(null), isNull);
    });

    test('formatLocalDayMonth formats day/month', () {
      final dt = DateTime(2026, 6, 2);
      final result = AppTimeFormatter.formatLocalDayMonth(dt);
      expect(result, '02/06');
    });
  });

  group('AppTimeFormatter relative day', () {
    test('formatRelativeDay returns Hôm nay for today', () {
      final today = DateTime.now();
      final result = AppTimeFormatter.formatRelativeDay(today);
      expect(result, 'Hôm nay');
    });

    test('formatRelativeDay returns Hôm qua for yesterday', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final result = AppTimeFormatter.formatRelativeDay(yesterday);
      expect(result, 'Hôm qua');
    });

    test('formatRelativeDay returns dd/MM for older dates', () {
      final oldDate = DateTime(2026, 1, 15);
      final result = AppTimeFormatter.formatRelativeDay(oldDate);
      expect(result, '15/01/2026');
    });

    test('formatRelativeDay returns null for null', () {
      expect(AppTimeFormatter.formatRelativeDay(null), isNull);
    });
  });

  group('AppTimeFormatter quest labels', () {
    test('formatQuestDueTime formats correctly', () {
      final dt = DateTime(2026, 6, 2, 14, 30, 0);
      expect(AppTimeFormatter.formatQuestDueTime(dt), 'Hạn 14:30');
    });

    test('formatQuestDueTime returns null for null', () {
      expect(AppTimeFormatter.formatQuestDueTime(null), isNull);
    });

    test('formatSnoozedUntil formats correctly', () {
      final dt = DateTime(2026, 6, 2, 15, 0, 0);
      expect(AppTimeFormatter.formatSnoozedUntil(dt), 'Hoãn đến 15:00');
    });

    test('formatSnoozedUntil returns null for null', () {
      expect(AppTimeFormatter.formatSnoozedUntil(null), isNull);
    });

    test('formatCompletedAt formats correctly', () {
      final dt = DateTime(2026, 6, 2, 10, 0, 0);
      expect(AppTimeFormatter.formatCompletedAt(dt), 'Hoàn thành lúc 10:00');
    });

    test('formatCompletedAt returns null for null', () {
      expect(AppTimeFormatter.formatCompletedAt(null), isNull);
    });

    test('formatStartedAt formats correctly', () {
      final dt = DateTime(2026, 6, 2, 8, 0, 0);
      expect(AppTimeFormatter.formatStartedAt(dt), 'Bắt đầu lúc 08:00');
    });

    test('formatStartedAt returns null for null', () {
      expect(AppTimeFormatter.formatStartedAt(null), isNull);
    });
  });

  group('AppTimeFormatter quest active time priority', () {
    test('formatQuestActiveTime returns snoozedUntil when both present', () {
      final snoozed = DateTime(2026, 6, 2, 15, 0, 0);
      final due = DateTime(2026, 6, 2, 14, 0, 0);
      final result = AppTimeFormatter.formatQuestActiveTime(snoozed, due);
      expect(result, '15:00');
    });

    test('formatQuestActiveTime returns dueDate when snoozed is null', () {
      final due = DateTime(2026, 6, 2, 14, 0, 0);
      final result = AppTimeFormatter.formatQuestActiveTime(null, due);
      expect(result, '14:00');
    });

    test('formatQuestActiveTime returns null when both null', () {
      final result = AppTimeFormatter.formatQuestActiveTime(null, null);
      expect(result, isNull);
    });

    test('formatQuestActiveTime returns dueDate when snoozed null', () {
      final due = DateTime(2026, 6, 2, 9, 0, 0);
      final result = AppTimeFormatter.formatQuestActiveTime(null, due);
      expect(result, '09:00');
    });
  });

  group('No "--:--" fallback anywhere', () {
    test('formatLocalTime never returns dash pattern', () {
      final dt = DateTime(2026, 6, 2, 0, 0, 0);
      final result = AppTimeFormatter.formatLocalTime(dt);
      expect(result, isNotNull);
      expect(result, isNot(contains('--')));
    });

    test('null inputs return null not dash pattern', () {
      expect(AppTimeFormatter.formatLocalTime(null), isNull);
      expect(AppTimeFormatter.formatLocalDate(null), isNull);
      expect(AppTimeFormatter.formatLocalDateTime(null), isNull);
      expect(AppTimeFormatter.formatDateOnly(null), isNull);
      expect(AppTimeFormatter.formatQuestDueTime(null), isNull);
      expect(AppTimeFormatter.formatSnoozedUntil(null), isNull);
      expect(AppTimeFormatter.formatCompletedAt(null), isNull);
      expect(AppTimeFormatter.formatStartedAt(null), isNull);
      expect(AppTimeFormatter.formatRelativeDay(null), isNull);
      expect(AppTimeFormatter.formatQuestActiveTime(null, null), isNull);
    });
  });

  group('Local time conversion from UTC', () {
    test('UTC timestamp hour differs from local in display', () {
      final utcMidnight = DateTime.utc(2026, 6, 2, 0, 0, 0);
      final result = AppTimeFormatter.formatLocalTime(utcMidnight);
      expect(result, isNotNull);
      expect(result, isNotEmpty);

      final localHour = utcMidnight.toLocal().hour;
      final expectedTime =
          '${localHour.toString().padLeft(2, '0')}:00';
      expect(result, expectedTime);
    });

    test('UTC timestamp is converted to local before formatting', () {
      final utcTime = DateTime.utc(2026, 6, 2, 9, 30, 0);
      final result = AppTimeFormatter.formatLocalTime(utcTime);

      final local = utcTime.toLocal();
      final expected =
          '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
      expect(result, expected);
    });

    test('offset timestamp +07:00 parses and displays local hour', () {
      final dt = DateTime.parse('2026-06-02T13:14:56.881887+07:00');
      final result = AppTimeFormatter.formatLocalTime(dt);
      expect(result, isNotNull);
      expect(result, isNotEmpty);
    });
  });

  group('AppTimeFormatter todayLocalDateQuery', () {
    test('returns today local date in yyyy-MM-dd format', () {
      final result = AppTimeFormatter.todayLocalDateQuery();
      final now = DateTime.now();
      final expected = '${now.year}-'
          '${now.month.toString().padLeft(2, '0')}-'
          '${now.day.toString().padLeft(2, '0')}';
      expect(result, expected);
    });

    test('matches yyyy-MM-dd regex pattern', () {
      final result = AppTimeFormatter.todayLocalDateQuery();
      expect(result, matches(r'^\d{4}-\d{2}-\d{2}$'));
    });

    test('formatDateOnly uses local date components, not UTC', () {
      final utcDateTime = DateTime.utc(2026, 6, 3, 23, 0, 0);
      final result = AppTimeFormatter.formatDateOnly(utcDateTime);
      expect(result, '2026-06-03');
    });

    test('formatDateOnly returns null for null input', () {
      expect(AppTimeFormatter.formatDateOnly(null), isNull);
    });
  });
}
