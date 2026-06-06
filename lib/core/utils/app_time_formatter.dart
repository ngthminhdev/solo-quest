import 'date_time_parser.dart';

/// Shared helper for all user-facing time/date display.
///
/// - Parses backend timestamps safely via [parseUtcDateTime]/[parseUtcDateOnly].
/// - Converts to local device time before display.
/// - Returns null for null inputs so widgets can hide time areas.
///
/// Usage: never format DateTime directly in widgets — always route through this class.
class AppTimeFormatter {
  AppTimeFormatter._();

  // ─── Parsing ─────────────────────────────────────────────────────

  /// Parse a backend ISO8601 timestamp string to UTC DateTime.
  static DateTime? parseBackendDateTime(String? str) =>
      parseUtcDateTime(str);

  /// Parse a backend date-only string (YYYY-MM-DD) to UTC DateTime.
  static DateTime? parseBackendDateOnly(String? str) =>
      parseUtcDateOnly(str);

  // ─── Conversion ──────────────────────────────────────────────────

  /// Convert to local device time for display.
  static DateTime? toLocalDisplay(DateTime? dt) => dt?.toLocal();

  /// Convert to UTC for storage.
  static DateTime? toUtcStorage(DateTime? dt) => dt?.toUtc();

  // ─── Core formatting ─────────────────────────────────────────────

  static String _pad(int n) => n.toString().padLeft(2, '0');

  /// Format as "HH:mm" in local time.
  /// Returns null for null input.
  static String? formatLocalTime(DateTime? dt) {
    final local = toLocalDisplay(dt);
    if (local == null) return null;
    return '${_pad(local.hour)}:${_pad(local.minute)}';
  }

  /// Format as "dd/MM/yyyy" in local time.
  /// Returns null for null input.
  static String? formatLocalDate(DateTime? dt) {
    final local = toLocalDisplay(dt);
    if (local == null) return null;
    return '${_pad(local.day)}/${_pad(local.month)}/${local.year}';
  }

  /// Format as "dd/MM/yyyy HH:mm" in local time.
  /// Returns null for null input.
  static String? formatLocalDateTime(DateTime? dt) {
    final local = toLocalDisplay(dt);
    if (local == null) return null;
    return '${_pad(local.day)}/${_pad(local.month)}/${local.year} ${_pad(local.hour)}:${_pad(local.minute)}';
  }

  /// Format as "dd/MM" in local time (no year).
  static String? formatLocalDayMonth(DateTime? dt) {
    final local = toLocalDisplay(dt);
    if (local == null) return null;
    return '${_pad(local.day)}/${_pad(local.month)}';
  }

  /// Format as "yyyy-MM-dd" (date-only, no timezone shift).
  /// Safe for date-only concepts like check-in date.
  static String? formatDateOnly(DateTime? dt) {
    if (dt == null) return null;
    return '${dt.year}-${_pad(dt.month)}-${_pad(dt.day)}';
  }

  /// Returns today's local date as "yyyy-MM-dd" for API query params.
  /// Uses [DateTime.now()] computed at call time — never caches.
  static String todayLocalDateQuery() {
    final now = DateTime.now();
    return '${now.year}-${_pad(now.month)}-${_pad(now.day)}';
  }

  // ─── Relative day ────────────────────────────────────────────────

  /// Returns "Hôm nay", "Hôm qua", or "dd/MM".
  /// Compares in local date.
  static String? formatRelativeDay(DateTime? dt) {
    final local = toLocalDisplay(dt);
    if (local == null) return null;
    final now = DateTime.now();
    if (local.year == now.year && local.month == now.month && local.day == now.day) {
      return 'Hôm nay';
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (local.year == yesterday.year && local.month == yesterday.month && local.day == yesterday.day) {
      return 'Hôm qua';
    }
    return formatLocalDate(local);
  }

  // ─── Quest display labels ────────────────────────────────────────

  /// "Hạn HH:mm" or null
  static String? formatQuestDueTime(DateTime? dt) {
    final time = formatLocalTime(dt);
    if (time == null) return null;
    return 'Hạn $time';
  }

  /// "Nhắc HH:mm" or null
  static String? formatReminderTime(DateTime? dt) {
    final time = formatLocalTime(dt);
    if (time == null) return null;
    return 'Nhắc $time';
  }

  /// "Hoãn đến HH:mm" or null
  static String? formatSnoozedUntil(DateTime? dt) {
    final time = formatLocalTime(dt);
    if (time == null) return null;
    return 'Hoãn đến $time';
  }

  /// "Hoàn thành lúc HH:mm" or null
  static String? formatCompletedAt(DateTime? dt) {
    final time = formatLocalTime(dt);
    if (time == null) return null;
    return 'Hoàn thành lúc $time';
  }

  /// "Bắt đầu lúc HH:mm" or null
  static String? formatStartedAt(DateTime? dt) {
    final time = formatLocalTime(dt);
    if (time == null) return null;
    return 'Bắt đầu lúc $time';
  }

  /// Returns "HH:mm" from snoozedUntil > reminderTime, or null.
  /// Widgets hide time display when null.
  static String? formatQuestActiveTime(DateTime? snoozedUntil, DateTime? reminderTime) {
    return formatLocalTime(snoozedUntil) ?? formatLocalTime(reminderTime);
  }
}
