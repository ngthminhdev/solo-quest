import '../models/daily_checkin_model.dart';

class DailyCheckinService {
  static DailyCheckinModel? _todayCheckin;

  Future<DailyCheckinModel?> getTodayCheckin() async {
    if (_todayCheckin != null) {
      final now = DateTime.now();
      final checkinDate = _todayCheckin!.date;
      if (checkinDate.year == now.year &&
          checkinDate.month == now.month &&
          checkinDate.day == now.day) {
        return _todayCheckin;
      }
      _todayCheckin = null;
    }
    return null;
  }

  Future<DailyCheckinModel> saveCheckin(DailyCheckinModel checkin) async {
    _todayCheckin = checkin;
    return checkin;
  }

  Future<bool> hasCheckedInToday() async {
    final checkin = await getTodayCheckin();
    return checkin != null;
  }
}
