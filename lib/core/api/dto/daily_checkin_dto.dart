import '../../../models/enums/user_enums.dart';
import '../../utils/app_time_formatter.dart';
import '../../utils/date_time_parser.dart';
import '../../utils/enum_mapper.dart';

/// Daily check-in DTO
class DailyCheckinDto {
  final String id;
  final DateTime date;

  // Simplified check-in fields
  final CheckinMood mood;
  final EnergyLevel energyLevel;
  final Availability availability;
  final CheckinPriority priority;

  // Legacy fields (for backward compat when parsing BE responses)
  final StressLevel stressLevel;
  final FocusLevel focusLevel;
  final SleepQuality sleepQuality;
  final DayIntensity dayIntensity;
  final String? mainFocusToday;
  final String? note;
  final List<String> availableTimeBlocks;

  final DateTime createdAt;

  DailyCheckinDto({
    required this.id,
    required this.date,
    this.mood = CheckinMood.normal,
    required this.energyLevel,
    this.availability = Availability.normal,
    this.priority = CheckinPriority.learning,
    // Legacy defaults
    this.stressLevel = StressLevel.medium,
    this.focusLevel = FocusLevel.medium,
    this.sleepQuality = SleepQuality.medium,
    this.dayIntensity = DayIntensity.normal,
    this.mainFocusToday,
    this.note,
    required this.availableTimeBlocks,
    required this.createdAt,
  });

  factory DailyCheckinDto.fromJson(Map<String, dynamic> json) {
    // Parse date as LOCAL midnight (not UTC) — the date represents user's local day
    final dateStr = json['date'] as String?;
    DateTime date;
    if (dateStr != null && !dateStr.contains('T')) {
      // Date-only string: parse as local midnight
      date = DateTime.parse('${dateStr}T00:00:00');
    } else {
      date = parseUtcDateOnly(dateStr) ?? DateTime.now();
    }

    return DailyCheckinDto(
      id: json['id'] as String,
      date: date,
      mood: parseCheckinMood(json['mood'] as String?),
      energyLevel: parseEnergyLevel(json['energy_level'] as String?),
      availability: parseAvailability(json['availability'] as String?),
      priority: parseCheckinPriority(json['priority'] as String?),
      // Legacy fields for backward compat
      stressLevel: parseStressLevel(json['stress_level'] as String?),
      focusLevel: parseFocusLevel(json['focus_level'] as String?),
      sleepQuality: parseSleepQuality(json['sleep_quality'] as String?),
      dayIntensity: parseDayIntensity(json['day_intensity'] as String?),
      mainFocusToday: json['main_focus_today'] as String?,
      note: json['note'] as String?,
      availableTimeBlocks: (json['available_time_blocks'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: parseUtcDateTime(json['created_at'] as String?) ?? DateTime.now().toUtc(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': AppTimeFormatter.formatDateOnly(date),
      'mood': mood.name,
      'energy_level': energyLevel.name,
      'availability': availability.name,
      'priority': priority.name,
      'created_at': formatUtcDateTime(createdAt),
    };
  }
}

/// Daily check-in status response
class DailyCheckinStatusDto {
  final bool hasCheckedIn;
  final DailyCheckinDto? item;
  final DateTime date;

  DailyCheckinStatusDto({
    required this.hasCheckedIn,
    this.item,
    required this.date,
  });

  factory DailyCheckinStatusDto.fromJson(Map<String, dynamic> json) {
    // Parse date as LOCAL midnight — represents user's local day
    final dateStr = json['date'] as String?;
    DateTime date;
    if (dateStr != null && !dateStr.contains('T')) {
      date = DateTime.parse('${dateStr}T00:00:00');
    } else {
      date = parseUtcDateOnly(dateStr) ?? DateTime.now();
    }

    return DailyCheckinStatusDto(
      hasCheckedIn: json['has_checked_in'] as bool? ?? false,
      item: json['item'] != null ? DailyCheckinDto.fromJson(json['item'] as Map<String, dynamic>) : null,
      date: date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'has_checked_in': hasCheckedIn,
      'item': item?.toJson(),
      'date': AppTimeFormatter.formatDateOnly(date),
    };
  }
}
