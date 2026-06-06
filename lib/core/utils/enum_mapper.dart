import '../../../models/enums/quest_enums.dart';
import '../../../models/enums/log_enums.dart';
import '../../../models/enums/user_enums.dart';

/// Safe enum parsing utilities with fallback values
/// Unknown enum values should not crash the app

/// Normalize enum value for comparison
/// Removes underscores, hyphens, and lowercases for flexible matching
/// Examples:
///   quest_completed → questcompleted
///   questCompleted → questcompleted
///   QUEST_COMPLETED → questcompleted
///   very-good → verygood
String _normalizeEnumValue(String value) {
  return value
      .trim()
      .replaceAll('-', '')
      .replaceAll('_', '')
      .toLowerCase();
}

/// Generic enum parser with normalization support
/// Handles camelCase, snake_case, kebab-case, and uppercase formats
T _parseEnum<T extends Enum>(
  String? raw,
  List<T> values,
  T fallback,
) {
  if (raw == null || raw.trim().isEmpty) return fallback;

  final normalizedRaw = _normalizeEnumValue(raw);

  for (final value in values) {
    if (_normalizeEnumValue(value.name) == normalizedRaw) {
      return value;
    }
  }

  return fallback;
}

/// Parse QuestStatus from backend string
QuestStatus parseQuestStatus(String? value, {QuestStatus fallback = QuestStatus.pending}) {
  return _parseEnum(value, QuestStatus.values, fallback);
}

/// Parse QuestType from backend string
QuestType parseQuestType(String? value, {QuestType fallback = QuestType.custom}) {
  return _parseEnum(value, QuestType.values, fallback);
}

/// Parse QuestDifficulty from backend string
QuestDifficulty parseQuestDifficulty(String? value, {QuestDifficulty fallback = QuestDifficulty.medium}) {
  return _parseEnum(value, QuestDifficulty.values, fallback);
}

/// Parse QuestSource from backend string
QuestSource parseQuestSource(String? value, {QuestSource fallback = QuestSource.manual}) {
  return _parseEnum(value, QuestSource.values, fallback);
}

/// Parse LogEntryType from backend string
LogEntryType parseLogEntryType(String? value, {LogEntryType fallback = LogEntryType.unknown}) {
  return _parseEnum(value, LogEntryType.values, fallback);
}

/// Parse LogMood from backend string
LogMood parseLogMood(String? value, {LogMood fallback = LogMood.neutral}) {
  return _parseEnum(value, LogMood.values, fallback);
}

/// Parse EnergyLevel from backend string
EnergyLevel parseEnergyLevel(String? value, {EnergyLevel fallback = EnergyLevel.medium}) {
  return _parseEnum(value, EnergyLevel.values, fallback);
}

/// Parse CheckinMood from backend string.
/// Supports both new snake_case values (very_bad, bad, normal, good, very_good)
/// and legacy Vietnamese labels for backward compatibility with existing data.
CheckinMood parseCheckinMood(String? value, {CheckinMood fallback = CheckinMood.normal}) {
  if (value == null || value.trim().isEmpty) return fallback;

  // Try standard enum parsing first (handles very_bad, veryBad, VERY_BAD, etc.)
  final normalizedRaw = _normalizeEnumValue(value);
  for (final v in CheckinMood.values) {
    if (_normalizeEnumValue(v.name) == normalizedRaw) {
      return v;
    }
  }

  // Legacy Vietnamese label mapping (old BE stored Vietnamese labels)
  switch (value.trim()) {
    case 'Rất tệ':
    case 'Rat te':
      return CheckinMood.veryBad;
    case 'Tệ':
    case 'Te':
      return CheckinMood.bad;
    case 'Bình thường':
    case 'Binh thuong':
      return CheckinMood.normal;
    case 'Tốt':
    case 'Tot':
      return CheckinMood.good;
    case 'Rất tốt':
    case 'Rat tot':
      return CheckinMood.veryGood;
    // Legacy enum names from old Mood enum
    case 'veryLow':
    case 'very_low':
      return CheckinMood.veryBad;
    case 'low':
      return CheckinMood.bad;
    case 'medium':
      return CheckinMood.normal;
    case 'high':
      return CheckinMood.good;
    case 'veryHigh':
    case 'very_high':
      return CheckinMood.veryGood;
  }

  return fallback;
}

/// Parse Availability from backend string
Availability parseAvailability(String? value, {Availability fallback = Availability.normal}) {
  return _parseEnum(value, Availability.values, fallback);
}

/// Parse CheckinPriority from backend string
CheckinPriority parseCheckinPriority(String? value, {CheckinPriority fallback = CheckinPriority.learning}) {
  return _parseEnum(value, CheckinPriority.values, fallback);
}

// ── Legacy parsers (kept for backward compatibility) ──

/// Parse StressLevel from backend string
StressLevel parseStressLevel(String? value, {StressLevel fallback = StressLevel.medium}) {
  return _parseEnum(value, StressLevel.values, fallback);
}

/// Parse FocusLevel from backend string
FocusLevel parseFocusLevel(String? value, {FocusLevel fallback = FocusLevel.medium}) {
  return _parseEnum(value, FocusLevel.values, fallback);
}

/// Parse DayIntensity from backend string
DayIntensity parseDayIntensity(String? value, {DayIntensity fallback = DayIntensity.normal}) {
  return _parseEnum(value, DayIntensity.values, fallback);
}

/// Parse SleepQuality from backend string
SleepQuality parseSleepQuality(String? value, {SleepQuality fallback = SleepQuality.medium}) {
  return _parseEnum(value, SleepQuality.values, fallback);
}

/// Parse Mood from backend string (legacy)
Mood parseMood(String? value, {Mood fallback = Mood.medium}) {
  return _parseEnum(value, Mood.values, fallback);
}
