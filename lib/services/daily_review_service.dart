import '../models/daily_review_model.dart';

class DailyReviewService {
  static DailyReviewModel? _todayReview;

  Future<DailyReviewModel?> getTodayReview() async {
    if (_todayReview != null) {
      final now = DateTime.now();
      final reviewDate = _todayReview!.date;
      if (reviewDate.year == now.year &&
          reviewDate.month == now.month &&
          reviewDate.day == now.day) {
        return _todayReview;
      }
      _todayReview = null;
    }
    return null;
  }

  Future<DailyReviewModel> saveReview(DailyReviewModel review) async {
    _todayReview = review;
    return review;
  }

  Future<bool> hasReviewedToday() async {
    final review = await getTodayReview();
    return review != null;
  }
}
