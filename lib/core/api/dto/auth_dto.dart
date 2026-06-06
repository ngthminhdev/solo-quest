import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

import '../../utils/date_time_parser.dart';

/// Auth session response from /api/auth/dev-login
class AuthSessionDto {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int? expiresIn;
  final AuthUserDto user;

  AuthSessionDto({
    required this.accessToken,
    required this.refreshToken,
    this.tokenType = 'Bearer',
    this.expiresIn,
    required this.user,
  });

  factory AuthSessionDto.fromJson(Map<String, dynamic> json) {
    // Support both snake_case (backend) and camelCase
    final accessToken =
        json['access_token'] as String? ?? json['accessToken'] as String?;
    final refreshToken =
        json['refresh_token'] as String? ?? json['refreshToken'] as String?;

    if (accessToken == null || refreshToken == null) {
      if (kDebugMode) {
        developer.log('[AUTH PARSE ERROR] AuthSessionDto.fromJson failed');
        developer.log(
          '  Required field missing: ${accessToken == null ? "access_token" : "refresh_token"}',
        );
        developer.log('  Available keys: ${json.keys.toList()}');
      }
      throw FormatException(
        'AuthSessionDto missing required field: ${accessToken == null ? "access_token" : "refresh_token"}. '
        'Available keys: ${json.keys.toList()}',
      );
    }

    final userJson = json['user'];
    if (userJson is! Map<String, dynamic>) {
      if (kDebugMode) {
        developer.log('[AUTH PARSE ERROR] AuthSessionDto.fromJson failed');
        developer.log('  "user" field is not a Map: ${userJson.runtimeType}');
        developer.log('  Available keys: ${json.keys.toList()}');
      }
      throw FormatException(
        'AuthSessionDto: "user" field missing or not a Map. Available keys: ${json.keys.toList()}',
      );
    }

    return AuthSessionDto(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType:
          json['token_type'] as String? ??
          json['tokenType'] as String? ??
          'Bearer',
      expiresIn: json['expires_in'] as int? ?? json['expiresIn'] as int?,
      user: AuthUserDto.fromJson(userJson),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
      'user': user.toJson(),
    };
  }
}

/// User info in auth session
/// Backend returns snake_case fields; supports camelCase as fallback
class AuthUserDto {
  final String id;
  final String displayName;
  final String? email;
  final String? avatarUrl;
  final String provider;
  final int? age;
  final String? gender;
  final double? heightCm;
  final double? weightKg;
  final String? mainActivity;
  final int level;
  final int currentLevelExp;
  final int nextLevelExp;
  final int totalExp;
  final int rewardPoints;
  final int streakDays;
  final int bestStreak;
  final int streakShields;
  final int totalCompletedQuests;
  final int totalSkippedQuests;
  final bool hasCompletedOnboarding;
  final DateTime createdAt;

  AuthUserDto({
    required this.id,
    required this.displayName,
    this.email,
    this.avatarUrl,
    this.provider = 'google',
    this.age,
    this.gender,
    this.heightCm,
    this.weightKg,
    this.mainActivity,
    this.level = 1,
    this.currentLevelExp = 0,
    this.nextLevelExp = 100,
    this.totalExp = 0,
    this.rewardPoints = 0,
    this.streakDays = 0,
    this.bestStreak = 0,
    this.streakShields = 0,
    this.totalCompletedQuests = 0,
    this.totalSkippedQuests = 0,
    this.hasCompletedOnboarding = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now().toUtc();

  factory AuthUserDto.fromJson(Map<String, dynamic> json) {
    // id is required
    final id = json['id'] as String?;
    if (id == null) {
      if (kDebugMode) {
        developer.log('[AUTH PARSE ERROR] AuthUserDto.fromJson failed');
        developer.log('  Required field missing: id');
        developer.log('  Available keys: ${json.keys.toList()}');
      }
      throw FormatException(
        'AuthUserDto missing required field: id. Available keys: ${json.keys.toList()}',
      );
    }

    // display_name or name — backend uses display_name
    final displayName =
        json['display_name'] as String? ??
        json['displayName'] as String? ??
        json['name'] as String? ??
        '';

    return AuthUserDto(
      id: id,
      displayName: displayName,
      email: json['email'] as String?,
      avatarUrl: json['avatar_url'] as String? ?? json['avatarUrl'] as String?,
      provider: json['provider'] as String? ?? 'google',
      age: json['age'] as int?,
      gender: json['gender'] as String?,
      heightCm: (json['height_cm'] ?? json['heightCm']) is num
          ? (json['height_cm'] ?? json['heightCm']).toDouble()
          : null,
      weightKg: (json['weight_kg'] ?? json['weightKg']) is num
          ? (json['weight_kg'] ?? json['weightKg']).toDouble()
          : null,
      mainActivity:
          json['main_activity'] as String? ?? json['mainActivity'] as String?,
      level: json['level'] as int? ?? 1,
      currentLevelExp:
          json['current_level_exp'] as int? ??
          json['currentLevelExp'] as int? ??
          0,
      nextLevelExp:
          json['next_level_exp'] as int? ?? json['nextLevelExp'] as int? ?? 100,
      totalExp: json['total_exp'] as int? ?? json['totalExp'] as int? ?? 0,
      rewardPoints:
          json['reward_points'] as int? ?? json['rewardPoints'] as int? ?? 0,
      streakDays:
          json['streak_days'] as int? ?? json['streakDays'] as int? ?? 0,
      bestStreak:
          json['best_streak'] as int? ?? json['bestStreak'] as int? ?? 0,
      streakShields:
          json['streak_shields'] as int? ?? json['streakShields'] as int? ?? 0,
      totalCompletedQuests:
          json['total_completed_quests'] as int? ??
          json['totalCompletedQuests'] as int? ??
          0,
      totalSkippedQuests:
          json['total_skipped_quests'] as int? ??
          json['totalSkippedQuests'] as int? ??
          0,
      hasCompletedOnboarding:
          json['has_completed_onboarding'] as bool? ?? false,
      createdAt: parseUtcDateTime(
        json['created_at'] as String? ?? json['createdAt'] as String?,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'display_name': displayName,
      'email': email,
      'avatar_url': avatarUrl,
      'provider': provider,
      'age': age,
      'gender': gender,
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'main_activity': mainActivity,
      'level': level,
      'current_level_exp': currentLevelExp,
      'next_level_exp': nextLevelExp,
      'total_exp': totalExp,
      'reward_points': rewardPoints,
      'streak_days': streakDays,
      'best_streak': bestStreak,
      'streak_shields': streakShields,
      'total_completed_quests': totalCompletedQuests,
      'total_skipped_quests': totalSkippedQuests,
      'has_completed_onboarding': hasCompletedOnboarding,
      'created_at': formatUtcDateTime(createdAt),
    };
  }
}
