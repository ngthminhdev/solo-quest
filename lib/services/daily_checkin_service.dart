import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../core/api/dto/daily_checkin_dto.dart';
import '../core/api/services/daily_checkin_api_service.dart';
import '../core/api/requests/api_requests.dart';
import '../core/network/api_exception.dart';
import '../core/utils/app_time_formatter.dart';
import '../models/daily_checkin_model.dart';

class DailyCheckinService {
  final DailyCheckinApiService _apiService;

  DailyCheckinService({DailyCheckinApiService? apiService})
      : _apiService = apiService ?? DailyCheckinApiService();

  /// Convert DailyCheckinDto to DailyCheckinModel
  DailyCheckinModel _dtoToModel(DailyCheckinDto dto) {
    return DailyCheckinModel(
      id: dto.id,
      date: dto.date,
      mood: dto.mood,
      energyLevel: dto.energyLevel,
      availability: dto.availability,
      priority: dto.priority,
      createdAt: dto.createdAt,
    );
  }

  Future<DailyCheckinModel?> getTodayCheckin() async {
    try {
      final status = await _apiService.getToday();
      if (kDebugMode) {
        developer.log('[CHECKIN SERVICE] getTodayCheckin: has_checked_in=${status.hasCheckedIn}, itemPresent=${status.item != null}');
      }
      return status.item != null ? _dtoToModel(status.item!) : null;
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        // 404 means no check-in today, not an error
        if (kDebugMode) {
          developer.log('[CHECKIN SERVICE] No check-in found (404): ${e.message}');
        }
        return null;
      }
      // For other API errors, log and return null (don't crash the app)
      if (kDebugMode) {
        developer.log('[CHECKIN SERVICE] Failed to get today check-in: ${e.message}');
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        developer.log('[CHECKIN SERVICE] Failed to get today check-in: $e');
      }
      return null;
    }
  }

  Future<DailyCheckinModel> saveCheckin(DailyCheckinModel checkin) async {
    if (kDebugMode) {
      developer.log('[CHECKIN SERVICE] Saving check-in');
    }

    final localDate = AppTimeFormatter.todayLocalDateQuery();
    if (kDebugMode) {
      developer.log('[CHECKIN SERVICE] Local date: $localDate');
    }

    final request = SaveDailyCheckinRequest(
      date: localDate,
      mood: checkin.mood,
      energyLevel: checkin.energyLevel,
      availability: checkin.availability,
      priority: checkin.priority,
    );

    final dto = await _apiService.save(request);
    return _dtoToModel(dto);
  }

  Future<bool> hasCheckedInToday() async {
    try {
      final status = await _apiService.getToday();
      if (kDebugMode) {
        developer.log('[CHECKIN SERVICE] hasCheckedInToday: has_checked_in=${status.hasCheckedIn}, itemPresent=${status.item != null}');
      }
      return status.hasCheckedIn;
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        if (kDebugMode) {
          developer.log('[CHECKIN SERVICE] hasCheckedInToday: 404 not found, returning false');
        }
        return false;
      }
      if (kDebugMode) {
        developer.log('[CHECKIN SERVICE] Failed to check status: ${e.message}');
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        developer.log('[CHECKIN SERVICE] Failed to check status: $e');
      }
      return false;
    }
  }
}
