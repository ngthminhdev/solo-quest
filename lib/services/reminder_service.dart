import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

import '../core/api/dto/reminder_setting_dto.dart';
import '../core/api/services/reminder_settings_api_service.dart';
import '../models/enums/reminder_enums.dart';
import '../models/reminder_setting_model.dart';

class ReminderService {
  final ReminderSettingsApiService _apiService;

  ReminderService({ReminderSettingsApiService? apiService})
      : _apiService = apiService ?? ReminderSettingsApiService();

  // ─── Local fallback data ──────────────────────────────────────────

  static final List<ReminderSettingModel> _fallbackSettings = [
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
      description: 'Nhắc bạn dành thời gian học vào buổi tối.',
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

  /// Tracks whether the last API call was unavailable so we can log once.
  bool _usingFallback = false;

  // ─── Public API ───────────────────────────────────────────────────

  Future<List<ReminderSettingModel>> getReminderSettings() async {
    try {
      final dtos = await _apiService.getReminderSettings();
      final models = dtos.map((d) => d.toModel()).toList();
      if (_usingFallback) {
        _usingFallback = false;
        if (kDebugMode) {
          developer.log('[ReminderSettings] Backend API available again, '
              'loaded ${models.length} settings from API.');
        }
      }
      if (kDebugMode) {
        developer.log('[ReminderSettings] API GET success — ${models.length} items');
      }
      return models;
    } catch (e) {
      if (ReminderSettingsApiService.isEndpointUnavailable(e)) {
        if (!_usingFallback) {
          _usingFallback = true;
          if (kDebugMode) {
            developer.log('[ReminderSettings] Backend API unavailable, '
                'using local fallback. ($e)');
          }
        }
        return List<ReminderSettingModel>.from(_fallbackSettings);
      }
      // Real server error — propagate to UI
      rethrow;
    }
  }

  Future<ReminderSettingModel> updateReminderSetting(
    ReminderSettingModel setting,
  ) async {
    try {
      final request = ReminderSettingDto.toUpdateJson(setting);
      final dto = await _apiService.updateReminderSetting(
        type: setting.type,
        request: request,
      );
      if (kDebugMode) {
        developer.log('[ReminderSettings] API PATCH success — ${setting.type.name}');
      }
      return dto.toModel();
    } catch (e) {
      if (ReminderSettingsApiService.isEndpointUnavailable(e)) {
        if (kDebugMode) {
          developer.log('[ReminderSettings] API PATCH unavailable, '
              'using local fallback for ${setting.type.name}');
        }
        return _updateFallback(setting);
      }
      rethrow;
    }
  }

  Future<ReminderSettingModel> toggleReminder(
    String settingId, {
    required bool enabled,
  }) async {
    // Find the type from fallback list (works for both API and fallback paths)
    final type = _resolveType(settingId);

    try {
      final status =
          enabled ? ReminderStatus.enabled : ReminderStatus.disabled;
      final dto = await _apiService.toggleReminder(
        type: type,
        status: status,
      );
      if (kDebugMode) {
        developer.log('[ReminderSettings] API toggle success — '
            '${type.name} -> ${status.toApiValue()}');
      }
      return dto.toModel();
    } catch (e) {
      if (ReminderSettingsApiService.isEndpointUnavailable(e)) {
        if (kDebugMode) {
          developer.log('[ReminderSettings] API toggle unavailable, '
              'using local fallback for ${type.name}');
        }
        return _toggleFallback(settingId, enabled: enabled);
      }
      rethrow;
    }
  }

  Future<void> scheduleQuestReminder({
    required String questId,
    required DateTime time,
  }) async {}

  Future<void> cancelQuestReminder(String questId) async {}

  Future<void> scheduleDailyReviewReminder() async {}

  // ─── Local fallback helpers ───────────────────────────────────────

  ReminderType _resolveType(String settingId) {
    // settingId matches type name in fallback data
    for (final s in _fallbackSettings) {
      if (s.id == settingId) return s.type;
    }
    // Try parsing the id as a type name
    return ReminderTypeApi.tryFromApiValue(settingId) ??
        ReminderType.values.firstWhere(
          (t) => t.name == settingId,
          orElse: () => ReminderType.custom,
        );
  }

  ReminderSettingModel _updateFallback(ReminderSettingModel setting) {
    final index =
        _fallbackSettings.indexWhere((item) => item.id == setting.id);
    if (index == -1) {
      throw Exception('Reminder setting not found: ${setting.id}');
    }
    _fallbackSettings[index] = setting;
    return setting;
  }

  ReminderSettingModel _toggleFallback(
    String settingId, {
    required bool enabled,
  }) {
    final index =
        _fallbackSettings.indexWhere((item) => item.id == settingId);
    if (index == -1) {
      throw Exception('Reminder setting not found: $settingId');
    }
    final updated = _fallbackSettings[index].copyWith(
      status: enabled ? ReminderStatus.enabled : ReminderStatus.disabled,
    );
    _fallbackSettings[index] = updated;
    return updated;
  }
}
