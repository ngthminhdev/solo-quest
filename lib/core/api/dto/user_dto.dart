import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

import '../../utils/date_time_parser.dart';

/// User profile from /api/users/me
class UserProfileDto {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final int level;
  final int currentLevelExp;
  final int nextLevelExp;
  final int totalExp;
  final int rewardPoints;
  final int streakDays;
  final int totalCompletedQuests;
  final List<String> mainGoals;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfileDto({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    required this.level,
    required this.currentLevelExp,
    required this.nextLevelExp,
    required this.totalExp,
    required this.rewardPoints,
    required this.streakDays,
    required this.totalCompletedQuests,
    required this.mainGoals,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfileDto.fromJson(Map<String, dynamic> json) {
    // Support both 'name' and 'display_name' from backend
    final name =
        json['name'] as String? ?? json['display_name'] as String? ?? '';
    // Email may not exist for dev accounts
    final email = json['email'] as String? ?? '';

    if (kDebugMode) {
      developer.log(
        '[USER DTO] Parsing profile: name=$name, email=$email, level=${json['level']}',
      );
    }

    return UserProfileDto(
      id: json['id'] as String,
      email: email,
      name: name,
      avatarUrl: json['avatar_url'] as String?,
      level: json['level'] as int? ?? 1,
      currentLevelExp: json['current_level_exp'] as int? ?? 0,
      nextLevelExp: json['next_level_exp'] as int? ?? 100,
      totalExp: json['total_exp'] as int? ?? 0,
      rewardPoints: json['reward_points'] as int? ?? 0,
      streakDays: json['streak_days'] as int? ?? 0,
      totalCompletedQuests: json['total_completed_quests'] as int? ?? 0,
      mainGoals: (json['main_goals'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt:
          parseUtcDateTime(json['created_at'] as String?) ??
          DateTime.now().toUtc(),
      updatedAt:
          parseUtcDateTime(json['updated_at'] as String?) ??
          DateTime.now().toUtc(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar_url': avatarUrl,
      'level': level,
      'current_level_exp': currentLevelExp,
      'next_level_exp': nextLevelExp,
      'total_exp': totalExp,
      'reward_points': rewardPoints,
      'streak_days': streakDays,
      'total_completed_quests': totalCompletedQuests,
      'main_goals': mainGoals,
      'created_at': formatUtcDateTime(createdAt),
      'updated_at': formatUtcDateTime(updatedAt),
    };
  }
}

/// Onboarding status from onboarding status/save endpoints.
class OnboardingStatusDto {
  final bool completed;
  final String? currentStep;
  final Map<String, dynamic>? data;

  OnboardingStatusDto({required this.completed, this.currentStep, this.data});

  factory OnboardingStatusDto.fromJson(Map<String, dynamic> json) {
    return OnboardingStatusDto(
      completed: json['has_completed_onboarding'] as bool? ?? false,
      currentStep: json['current_step'] as String?,
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'completed': completed, 'current_step': currentStep, 'data': data};
  }
}

/// Daily status from /api/users/daily-status
class DailyStatusDto {
  final bool hasCheckedIn;
  final bool hasReviewed;
  final int totalCount;
  final int completedCount;
  final int skippedCount;
  final int pendingCount;
  final int activeCount;
  final int snoozedCount;
  final double completionRate;
  final int earnedExpToday;
  final int streakDays;

  DailyStatusDto({
    required this.hasCheckedIn,
    required this.hasReviewed,
    required this.totalCount,
    required this.completedCount,
    required this.skippedCount,
    required this.pendingCount,
    required this.activeCount,
    required this.snoozedCount,
    required this.completionRate,
    required this.earnedExpToday,
    required this.streakDays,
  });

  // Legacy getters for backward compatibility
  int get todayCompletedQuests => completedCount;
  int get todayPlannedQuests => totalCount;
  int get todayEarnedExp => earnedExpToday;

  factory DailyStatusDto.fromJson(Map<String, dynamic> json) {
    return DailyStatusDto(
      hasCheckedIn:
          json['has_checked_in'] as bool? ??
          json['has_checked_in_today'] as bool? ??
          false,
      hasReviewed:
          json['has_reviewed'] as bool? ??
          json['has_reviewed_today'] as bool? ??
          false,
      totalCount: json['total_count'] as int? ?? 0,
      completedCount: json['completed_count'] as int? ?? 0,
      skippedCount: json['skipped_count'] as int? ?? 0,
      pendingCount: json['pending_count'] as int? ?? 0,
      activeCount: json['active_count'] as int? ?? 0,
      snoozedCount: json['snoozed_count'] as int? ?? 0,
      completionRate: (json['completion_rate'] as num?)?.toDouble() ?? 0.0,
      earnedExpToday: json['earned_exp_today'] as int? ?? 0,
      streakDays: json['streak_days'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'has_checked_in': hasCheckedIn,
      'has_reviewed': hasReviewed,
      'total_count': totalCount,
      'completed_count': completedCount,
      'skipped_count': skippedCount,
      'pending_count': pendingCount,
      'active_count': activeCount,
      'snoozed_count': snoozedCount,
      'completion_rate': completionRate,
      'earned_exp_today': earnedExpToday,
      'streak_days': streakDays,
    };
  }
}
