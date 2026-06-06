import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../core/api/dto/daily_review_dto.dart';
import '../core/api/services/daily_review_api_service.dart';
import '../core/api/requests/api_requests.dart';
import '../core/network/api_exception.dart';
import '../core/utils/app_time_formatter.dart';
import '../models/daily_review_model.dart';

class DailyReviewService {
  final DailyReviewApiService _apiService;

  DailyReviewService({DailyReviewApiService? apiService})
      : _apiService = apiService ?? DailyReviewApiService();

  /// Convert DailyReviewDto to DailyReviewModel
  DailyReviewModel _dtoToModel(DailyReviewDto dto) {
    return DailyReviewModel(
      id: dto.id,
      date: dto.date,
      mood: dto.mood,
      energyLevel: dto.energyLevel,
      satisfaction: dto.satisfaction,
      reflection: dto.reflection,
      tomorrowPriority: dto.tomorrowPriority,
      createdAt: dto.createdAt,
    );
  }

  Future<DailyReviewModel?> getTodayReview() async {
    try {
      final status = await _apiService.getToday();
      return status.item != null ? _dtoToModel(status.item!) : null;
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        if (kDebugMode) {
          developer.log('[REVIEW SERVICE] No review found (404): ${e.message}');
        }
        return null;
      }
      if (kDebugMode) {
        developer.log('[REVIEW SERVICE] Failed to get today review: ${e.message}');
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        developer.log('[REVIEW SERVICE] Failed to get today review: $e');
      }
      return null;
    }
  }

  Future<DailyReviewModel> saveReview(DailyReviewModel review) async {
    if (kDebugMode) {
      developer.log('[REVIEW SERVICE] Saving review');
    }

    final localDate = AppTimeFormatter.todayLocalDateQuery();
    if (kDebugMode) {
      developer.log('[REVIEW SERVICE] Local date: $localDate');
    }

    final request = SaveDailyReviewRequest(
      date: localDate,
      mood: review.mood.name,
      energyLevel: review.energyLevel.name,
      satisfaction: review.satisfaction,
      reflection: review.reflection,
      tomorrowPriority: review.tomorrowPriority.name,
    );

    final dto = await _apiService.save(request);
    return _dtoToModel(dto);
  }

  Future<bool> hasReviewedToday() async {
    try {
      final status = await _apiService.getToday();
      return status.hasReviewed;
    } on ApiException catch (e) {
      if (e.statusCode == 404) {
        return false;
      }
      if (kDebugMode) {
        developer.log('[REVIEW SERVICE] Failed to check status: ${e.message}');
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        developer.log('[REVIEW SERVICE] Failed to check status: $e');
      }
      return false;
    }
  }

  /// Get review summary for display
  Future<DailyReviewSummaryDto> getSummary({String? date}) async {
    return await _apiService.getSummary(date: date);
  }
}
