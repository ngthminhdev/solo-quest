import '../../utils/app_time_formatter.dart';
import '../../utils/date_time_parser.dart';
import '../../utils/enum_mapper.dart';
import '../../../models/enums/user_enums.dart';

/// Daily review DTO (simplified)
class DailyReviewDto {
  final String id;
  final DateTime date;
  final CheckinMood mood;
  final EnergyLevel energyLevel;
  final int satisfaction;
  final String? reflection;
  final CheckinPriority tomorrowPriority;
  final String? aiSummary;
  final DateTime createdAt;

  DailyReviewDto({
    required this.id,
    required this.date,
    required this.mood,
    required this.energyLevel,
    required this.satisfaction,
    this.reflection,
    required this.tomorrowPriority,
    this.aiSummary,
    required this.createdAt,
  });

  factory DailyReviewDto.fromJson(Map<String, dynamic> json) {
    // Parse date as LOCAL midnight — represents user's local day
    final dateStr = json['date'] as String?;
    DateTime date;
    if (dateStr != null && !dateStr.contains('T')) {
      date = DateTime.parse('${dateStr}T00:00:00');
    } else {
      date = parseUtcDateOnly(dateStr) ?? DateTime.now();
    }

    return DailyReviewDto(
      id: json['id'] as String,
      date: date,
      mood: parseCheckinMood(json['mood'] as String?),
      energyLevel: parseEnergyLevel(json['energy_level'] as String?),
      satisfaction: json['satisfaction'] as int? ?? 3,
      reflection: json['reflection'] as String?,
      tomorrowPriority: parseCheckinPriority(json['tomorrow_priority'] as String?),
      aiSummary: json['ai_summary'] as String?,
      createdAt: parseUtcDateTime(json['created_at'] as String?) ?? DateTime.now().toUtc(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': AppTimeFormatter.formatDateOnly(date),
      'mood': mood.name,
      'energy_level': energyLevel.name,
      'satisfaction': satisfaction,
      'reflection': reflection,
      'tomorrow_priority': tomorrowPriority.name,
      'created_at': formatUtcDateTime(createdAt),
    };
  }
}

/// Daily review status response
class DailyReviewStatusDto {
  final bool hasReviewed;
  final DailyReviewDto? item;
  final DateTime date;

  DailyReviewStatusDto({
    required this.hasReviewed,
    this.item,
    required this.date,
  });

  factory DailyReviewStatusDto.fromJson(Map<String, dynamic> json) {
    // Parse date as LOCAL midnight
    final dateStr = json['date'] as String?;
    DateTime date;
    if (dateStr != null && !dateStr.contains('T')) {
      date = DateTime.parse('${dateStr}T00:00:00');
    } else {
      date = parseUtcDateOnly(dateStr) ?? DateTime.now();
    }

    return DailyReviewStatusDto(
      hasReviewed: json['has_reviewed'] as bool? ?? false,
      item: json['item'] != null ? DailyReviewDto.fromJson(json['item'] as Map<String, dynamic>) : null,
      date: date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'has_reviewed': hasReviewed,
      'item': item?.toJson(),
      'date': AppTimeFormatter.formatDateOnly(date),
    };
  }
}

/// Daily review summary (kept for API compatibility)
class DailyReviewSummaryDto {
  final int completedQuestCount;
  final int skippedQuestCount;
  final int earnedExp;
  final List<String> topQuestTitles;

  DailyReviewSummaryDto({
    required this.completedQuestCount,
    required this.skippedQuestCount,
    required this.earnedExp,
    required this.topQuestTitles,
  });

  factory DailyReviewSummaryDto.fromJson(Map<String, dynamic> json) {
    return DailyReviewSummaryDto(
      completedQuestCount: json['completed_quest_count'] as int? ?? 0,
      skippedQuestCount: json['skipped_quest_count'] as int? ?? 0,
      earnedExp: json['earned_exp'] as int? ?? 0,
      topQuestTitles: (json['top_quest_titles'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'completed_quest_count': completedQuestCount,
      'skipped_quest_count': skippedQuestCount,
      'earned_exp': earnedExp,
      'top_quest_titles': topQuestTitles,
    };
  }
}
