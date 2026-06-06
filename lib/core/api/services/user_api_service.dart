import 'package:flutter/foundation.dart';

import '../../network/api_client.dart';
import '../../network/api_response_parser.dart';
import '../dto/user_dto.dart';

/// User API service
/// Handles user profile and status endpoints
class UserApiService {
  final ApiClient _client;

  UserApiService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Get current user profile - GET /api/users/me
  /// Backend returns {"user": {...}} or direct user fields
  Future<UserProfileDto> getMe() async {
    return await _client.get(
      'users/me',
      fromJson: (json) {
        debugPrint('[PROFILE API] Loading user profile');
        debugPrint(
          '[PROFILE API] raw keys: ${json is Map ? json.keys.toList() : json.runtimeType}',
        );

        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['user', 'data', 'profile', 'item'],
          context: 'UserApiService.getMe',
        );

        final dto = UserProfileDto.fromJson(map);
        debugPrint(
          '[PROFILE API] parsed user: ${dto.name}, level=${dto.level}',
        );
        return dto;
      },
    );
  }

  /// Get onboarding status - GET /api/onboarding
  Future<OnboardingStatusDto> getOnboardingStatus() async {
    return await _client.get(
      'onboarding',
      fromJson: (json) {
        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['item', 'data', 'status', 'onboarding'],
          context: 'UserApiService.getOnboardingStatus',
        );
        return OnboardingStatusDto.fromJson(map);
      },
    );
  }

  /// Get daily status - GET /api/users/me/daily-status
  Future<DailyStatusDto> getDailyStatus() async {
    return await _client.get(
      'users/me/daily-status',
      fromJson: (json) {
        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['item', 'data', 'status', 'daily_status'],
          context: 'UserApiService.getDailyStatus',
        );
        return DailyStatusDto.fromJson(map);
      },
    );
  }

  /// Save onboarding data - POST /api/onboarding
  Future<OnboardingStatusDto> saveOnboarding(Map<String, dynamic> data) async {
    return await _client.post(
      'onboarding',
      body: data,
      fromJson: (json) {
        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['item', 'data', 'status', 'onboarding'],
          context: 'UserApiService.saveOnboarding',
        );
        return OnboardingStatusDto.fromJson(map);
      },
    );
  }
}
