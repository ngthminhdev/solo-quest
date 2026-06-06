// Utilities for parsing UTC timestamps from backend
//
// Backend returns UTC timestamps. Flutter should:
// - Parse timestamps as UTC
// - Keep DateTime as UTC in DTO/model
// - Only convert to local time in display/formatting layer

/// Parse UTC timestamp string to DateTime
/// Returns null if the string is null or invalid
///
/// Example: "2026-06-01T10:30:00Z" -> DateTime in UTC
DateTime? parseUtcDateTime(String? dateTimeString) {
  if (dateTimeString == null || dateTimeString.isEmpty) {
    return null;
  }

  try {
    return DateTime.parse(dateTimeString).toUtc();
  } catch (e) {
    return null;
  }
}

/// Parse date-only string to DateTime at UTC midnight
/// Returns null if the string is null or invalid
///
/// Example: "2026-06-01" -> DateTime(2026, 6, 1, 0, 0, 0) in UTC
DateTime? parseUtcDateOnly(String? dateString) {
  if (dateString == null || dateString.isEmpty) {
    return null;
  }

  try {
    // If already has time component, parse normally
    if (dateString.contains('T')) {
      return DateTime.parse(dateString).toUtc();
    }

    // Date-only: append T00:00:00Z for UTC midnight
    return DateTime.parse('${dateString}T00:00:00Z');
  } catch (e) {
    return null;
  }
}

/// Format DateTime to ISO8601 string for backend
/// Returns null if the DateTime is null
String? formatUtcDateTime(DateTime? dateTime) {
  if (dateTime == null) {
    return null;
  }

  return dateTime.toUtc().toIso8601String();
}

/// Format DateTime to date-only string (YYYY-MM-DD) for backend
/// Returns null if the DateTime is null
String? formatUtcDateOnly(DateTime? dateTime) {
  if (dateTime == null) {
    return null;
  }

  final utc = dateTime.toUtc();
  final year = utc.year.toString().padLeft(4, '0');
  final month = utc.month.toString().padLeft(2, '0');
  final day = utc.day.toString().padLeft(2, '0');

  return '$year-$month-$day';
}
