import '../../network/api_client.dart';
import '../../network/api_response_parser.dart';
import '../dto/daily_review_dto.dart';
import '../requests/api_requests.dart';

/// Daily review API service
/// Handles evening review endpoints
class DailyReviewApiService {
  final ApiClient _client;

  DailyReviewApiService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Get today's review status - GET /api/reviews/today
  /// Backend may return new envelope: {"code": 200, "message": "OK", "data": {"has_reviewed": true, "item": {...}, "date": "..."}}
  /// Or old unwrapped: {"has_reviewed": true, "item": {...}, "date": "..."}
  Future<DailyReviewStatusDto> getToday() async {
    return await _client.get(
      'reviews/today',
      fromJson: (json) {
        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['data'],
          context: 'DailyReviewApiService.getToday',
        );
        return DailyReviewStatusDto.fromJson(map);
      },
    );
  }

  /// Get review by date - GET /api/reviews/{date}
  /// Same response shape as getToday.
  Future<DailyReviewStatusDto> getByDate(String date) async {
    return await _client.get(
      'reviews/$date',
      fromJson: (json) {
        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['data'],
          context: 'DailyReviewApiService.getByDate',
        );
        return DailyReviewStatusDto.fromJson(map);
      },
    );
  }

  /// Get review summary - GET /api/reviews/summary
  Future<DailyReviewSummaryDto> getSummary({String? date}) async {
    final queryParams = date != null ? {'date': date} : null;

    return await _client.get(
      'reviews/summary',
      queryParams: queryParams,
      fromJson: (json) {
        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['item', 'data', 'summary'],
          context: 'DailyReviewApiService.getSummary',
        );
        return DailyReviewSummaryDto.fromJson(map);
      },
    );
  }

  /// Save daily review - POST /api/reviews
  Future<DailyReviewDto> save(SaveDailyReviewRequest request) async {
    return await _client.post(
      'reviews',
      body: request.toJson(),
      fromJson: (json) {
        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['item', 'data', 'review'],
          context: 'DailyReviewApiService.save',
        );
        return DailyReviewDto.fromJson(map);
      },
    );
  }
}
