import '../models/enums/reminder_enums.dart';
import '../models/reminder_setting_model.dart';

class ReminderService {
  static final List<ReminderSettingModel> _settings = [
    const ReminderSettingModel(
      id: 'water',
      type: ReminderType.water,
      title: 'Uống nước',
      description: 'Nhắc uống nước nhỏ giọt thay vì mục tiêu lớn.',
      frequency: ReminderFrequency.interval,
      status: ReminderStatus.enabled,
      startTime: '08:00',
      endTime: '22:00',
      intervalMinutes: 90,
      maxPerDay: 8,
    ),
    const ReminderSettingModel(
      id: 'break-time',
      type: ReminderType.breakTime,
      title: 'Nghỉ mắt & nghỉ giải lao',
      description: 'Nhắc nghỉ sau thời gian tập trung.',
      frequency: ReminderFrequency.interval,
      status: ReminderStatus.enabled,
      startTime: '09:00',
      endTime: '18:00',
      intervalMinutes: 90,
    ),
    const ReminderSettingModel(
      id: 'movement',
      type: ReminderType.movement,
      title: 'Vận động',
      description: 'Nhắc đứng dậy vận động nhẹ sau khi ngồi lâu.',
      frequency: ReminderFrequency.randomInRange,
      status: ReminderStatus.enabled,
      startTime: '10:00',
      endTime: '20:00',
      maxPerDay: 3,
    ),
    const ReminderSettingModel(
      id: 'learning',
      type: ReminderType.learning,
      title: 'Học tập',
      description: 'Nhắc học theo khung giờ rảnh và năng lượng.',
      frequency: ReminderFrequency.fixed,
      status: ReminderStatus.enabled,
      startTime: '20:00',
    ),
    const ReminderSettingModel(
      id: 'sleep',
      type: ReminderType.sleep,
      title: 'Chuẩn bị ngủ',
      description: 'Nhắc wind-down trước giờ ngủ mục tiêu.',
      frequency: ReminderFrequency.fixed,
      status: ReminderStatus.enabled,
      startTime: '23:00',
    ),
    const ReminderSettingModel(
      id: 'daily-review',
      type: ReminderType.dailyReview,
      title: 'Daily Review',
      description: 'Nhắc tổng kết ngày và ghi nhận tiến độ.',
      frequency: ReminderFrequency.fixed,
      status: ReminderStatus.enabled,
      startTime: '21:30',
    ),
    const ReminderSettingModel(
      id: 'custom',
      type: ReminderType.custom,
      title: 'Custom reminder',
      description: 'Nhắc việc cá nhân theo khung giờ tự chọn.',
      frequency: ReminderFrequency.smart,
      status: ReminderStatus.disabled,
      startTime: '15:00',
      endTime: '19:00',
      maxPerDay: 2,
      smartEnabled: true,
    ),
  ];

  Future<List<ReminderSettingModel>> getReminderSettings() async {
    return List<ReminderSettingModel>.from(_settings);
  }

  Future<ReminderSettingModel> updateReminderSetting(
    ReminderSettingModel setting,
  ) async {
    final index = _settings.indexWhere((item) => item.id == setting.id);
    if (index == -1) {
      throw Exception('Reminder setting not found: ${setting.id}');
    }

    _settings[index] = setting;
    return setting;
  }

  Future<ReminderSettingModel> toggleReminder(
    String settingId, {
    required bool enabled,
  }) async {
    final index = _settings.indexWhere((item) => item.id == settingId);
    if (index == -1) {
      throw Exception('Reminder setting not found: $settingId');
    }

    final updated = _settings[index].copyWith(
      status: enabled ? ReminderStatus.enabled : ReminderStatus.disabled,
    );
    _settings[index] = updated;
    return updated;
  }

  Future<void> scheduleQuestReminder({
    required String questId,
    required DateTime time,
  }) async {}

  Future<void> cancelQuestReminder(String questId) async {}

  Future<void> scheduleDailyReviewReminder() async {}
}
