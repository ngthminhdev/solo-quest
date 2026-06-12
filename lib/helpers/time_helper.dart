import 'package:flutter/material.dart';

import '../constants/app_color.dart';

/// Centralized time utilities for the entire app.
/// Eliminates duplicated _parseTime/_formatTime across modules.
class TimeHelper {
  TimeHelper._();

  // ─── Parse / Format ──────────────────────────────────────────────

  /// Parse "HH:mm" string to TimeOfDay.
  /// Returns null if format is invalid.
  static TimeOfDay? parseTimeOfDay(String? time) {
    if (time == null || time.isEmpty) return null;
    final parts = time.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  /// Format TimeOfDay to "HH:mm" string.
  static String formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  /// Format TimeOfDay to display string like "08:30" or "8:30 SA".
  static String formatTimeDisplay(TimeOfDay time) {
    return formatTimeOfDay(time);
  }

  /// Safe format: returns fallback if time is empty.
  static String formatOrFallback(String? time, {String fallback = ''}) {
    if (time == null || time.isEmpty) return fallback;
    return time;
  }

  // ─── Time Picker ─────────────────────────────────────────────────

  /// Show themed time picker consistent with app design.
  /// Returns formatted "HH:mm" string, or null if cancelled.
  static Future<String?> pickTime(
    BuildContext context, {
    String? currentTime,
  }) async {
    final initial = parseTimeOfDay(currentTime) ?? TimeOfDay.now();

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColor.cyan,
              onPrimary: AppColor.bgDeep,
              surface: AppColor.surface,
              onSurface: AppColor.fg,
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: AppColor.bgRaised,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      return formatTimeOfDay(picked);
    }
    return null;
  }

  // ─── Time Comparison ─────────────────────────────────────────────

  /// Compare two "HH:mm" strings. Returns negative if a < b, 0 if equal, positive if a > b.
  static int compareTime(String a, String b) {
    final timeA = parseTimeOfDay(a);
    final timeB = parseTimeOfDay(b);
    if (timeA == null || timeB == null) return 0;
    final minutesA = timeA.hour * 60 + timeA.minute;
    final minutesB = timeB.hour * 60 + timeB.minute;
    return minutesA.compareTo(minutesB);
  }

  /// Check if time is between start and end (inclusive).
  static bool isTimeBetween(String time, String start, String end) {
    return compareTime(time, start) >= 0 && compareTime(time, end) <= 0;
  }

  /// Get total minutes from midnight for a "HH:mm" string.
  static int? toMinutes(String? time) {
    final tod = parseTimeOfDay(time);
    if (tod == null) return null;
    return tod.hour * 60 + tod.minute;
  }

  // ─── Duration Helpers ────────────────────────────────────────────

  /// Format duration in minutes to human-readable string.
  static String formatDuration(int minutes) {
    if (minutes < 60) return '$minutes phút';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (m == 0) return '$h giờ';
    return '$h giờ $m phút';
  }

  /// Get time-of-day greeting.
  static String getGreeting() {
    final hour = TimeOfDay.now().hour;
    if (hour < 5) return 'Khuya rồi';
    if (hour < 12) return 'Chào buổi sáng';
    if (hour < 17) return 'Chào buổi chiều';
    if (hour < 21) return 'Chào buổi tối';
    return 'Khuya rồi';
  }

  // ─── Time Slot Definitions ───────────────────────────────────────

  /// Canonical time slots used across the app (onboarding, morning checkin, schedule).
  static const List<TimeSlot> allTimeSlots = [
    TimeSlot(id: 'early_morning', label: 'Sáng sớm', startHour: 5, endHour: 7),
    TimeSlot(id: 'morning', label: 'Buổi sáng', startHour: 7, endHour: 10),
    TimeSlot(id: 'late_morning', label: 'Trưa', startHour: 10, endHour: 12),
    TimeSlot(id: 'lunch', label: 'Giờ nghỉ trưa', startHour: 12, endHour: 13),
    TimeSlot(id: 'afternoon', label: 'Buổi chiều', startHour: 13, endHour: 17),
    TimeSlot(id: 'after_work', label: 'Sau giờ làm', startHour: 17, endHour: 19),
    TimeSlot(id: 'evening', label: 'Buổi tối', startHour: 19, endHour: 21),
    TimeSlot(id: 'night', label: 'Tối (20–23h)', startHour: 20, endHour: 23),
    TimeSlot(id: 'before_sleep', label: 'Trước khi ngủ', startHour: 22, endHour: 24),
  ];

  /// Get time slot labels for display.
  static List<String> get timeSlotLabels =>
      allTimeSlots.map((s) => s.label).toList();

  /// Find time slot by id.
  static TimeSlot? findSlotById(String id) {
    try {
      return allTimeSlots.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Find time slot by label.
  static TimeSlot? findSlotByLabel(String label) {
    try {
      return allTimeSlots.firstWhere((s) => s.label == label);
    } catch (_) {
      return null;
    }
  }
}

/// Represents a time slot with a label and hour range.
class TimeSlot {
  final String id;
  final String label;
  final int startHour;
  final int endHour;

  const TimeSlot({
    required this.id,
    required this.label,
    required this.startHour,
    required this.endHour,
  });

  String get displayRange => '${startHour.toString().padLeft(2, '0')}:00–${endHour.toString().padLeft(2, '0')}:00';

  @override
  String toString() => label;
}
