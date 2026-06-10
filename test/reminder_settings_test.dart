import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/core/api/dto/reminder_setting_dto.dart';
import 'package:solo_quest/core/api/services/reminder_settings_api_service.dart';
import 'package:solo_quest/models/enums/reminder_enums.dart';
import 'package:solo_quest/models/log_entry_model.dart';
import 'package:solo_quest/models/reminder_setting_model.dart';
import 'package:solo_quest/modules/reminder_settings/reminder_settings_page_model.dart';
import 'package:solo_quest/services/log_service.dart';
import 'package:solo_quest/services/reminder_service.dart';

class FakeReminderSettingsApiService implements ReminderSettingsApiService {
  ReminderType? toggledType;
  ReminderStatus? toggledStatus;

  @override
  Future<List<ReminderSettingDto>> getReminderSettings() async => [];

  @override
  Future<ReminderSettingDto> updateReminderSetting({
    required ReminderType type,
    required Map<String, dynamic> request,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ReminderSettingDto> toggleReminder({
    required ReminderType type,
    required ReminderStatus status,
  }) async {
    toggledType = type;
    toggledStatus = status;
    return ReminderSettingDto(
      id: 'backend-break-time-id',
      type: type,
      title: 'Break',
      description: 'Take a break',
      frequency: ReminderFrequency.interval,
      status: status,
      intervalMinutes: 90,
    );
  }
}

class FakeReminderService extends Fake implements ReminderService {
  final List<ReminderSettingModel> initialSettings;
  final Map<ReminderType, ReminderSettingModel> toggleResponses;
  ReminderType? toggledType;
  bool? toggledEnabled;

  FakeReminderService({
    required this.initialSettings,
    this.toggleResponses = const {},
  });

  @override
  Future<List<ReminderSettingModel>> getReminderSettings() async {
    return initialSettings;
  }

  @override
  Future<ReminderSettingModel> toggleReminder(
    ReminderType type, {
    required bool enabled,
  }) async {
    toggledType = type;
    toggledEnabled = enabled;
    final response = toggleResponses[type];
    if (response != null) {
      return response.copyWith(
        status: enabled ? ReminderStatus.enabled : ReminderStatus.disabled,
      );
    }
    return ReminderSettingModel(
      id: 'backend-break-time-id',
      type: type,
      title: 'Break',
      description: 'Take a break',
      frequency: ReminderFrequency.interval,
      status: enabled ? ReminderStatus.enabled : ReminderStatus.disabled,
      intervalMinutes: 90,
    );
  }
}

class FakeLogService extends Fake implements LogService {
  @override
  Future<void> addLog(LogEntryModel log) async {}
}

void main() {
  group('ReminderService', () {
    test('toggleReminder sends backend type instead of backend id', () async {
      final api = FakeReminderSettingsApiService();
      final service = ReminderService(apiService: api);

      final updated = await service.toggleReminder(
        ReminderType.breakTime,
        enabled: false,
      );

      expect(api.toggledType, ReminderType.breakTime);
      expect(api.toggledStatus, ReminderStatus.disabled);
      expect(updated.type, ReminderType.breakTime);
      expect(updated.status, ReminderStatus.disabled);
    });
  });

  group('ReminderSettingsPageModel', () {
    test('toggleReminder replaces local item from PATCH response', () async {
      final reminderService = FakeReminderService(
        initialSettings: const [
          ReminderSettingModel(
            id: 'backend-break-time-id',
            type: ReminderType.breakTime,
            title: 'Break',
            description: 'Take a break',
            frequency: ReminderFrequency.interval,
            status: ReminderStatus.enabled,
            intervalMinutes: 90,
          ),
        ],
      );
      final model = ReminderSettingsPageModel(
        reminderService: reminderService,
        logService: FakeLogService(),
      );

      await model.loadSettings();
      final success = await model.toggleReminder(
        type: ReminderType.breakTime,
        enabled: false,
      );

      expect(success, true);
      expect(reminderService.toggledType, ReminderType.breakTime);
      expect(reminderService.toggledEnabled, false);
      expect(model.readState.settings.single.status, ReminderStatus.disabled);
      expect(model.readState.isLockedPage, false);
    });

    test('toggleReminder keeps fixed type priority order', () async {
      const breakTime = ReminderSettingModel(
        id: 'backend-break-time-id',
        type: ReminderType.breakTime,
        title: 'Break',
        description: 'Take a break',
        frequency: ReminderFrequency.interval,
        status: ReminderStatus.enabled,
        intervalMinutes: 90,
      );
      const custom = ReminderSettingModel(
        id: 'backend-custom-id',
        type: ReminderType.custom,
        title: 'Custom',
        description: 'Custom reminder',
        frequency: ReminderFrequency.fixed,
        status: ReminderStatus.enabled,
      );
      final reminderService = FakeReminderService(
        initialSettings: const [custom, breakTime],
        toggleResponses: const {ReminderType.breakTime: breakTime},
      );
      final model = ReminderSettingsPageModel(
        reminderService: reminderService,
        logService: FakeLogService(),
      );

      await model.loadSettings();
      expect(model.readState.settings.map((setting) => setting.type), [
        ReminderType.breakTime,
        ReminderType.custom,
      ]);

      final success = await model.toggleReminder(
        type: ReminderType.breakTime,
        enabled: false,
      );

      expect(success, true);
      expect(model.readState.settings.map((setting) => setting.type), [
        ReminderType.breakTime,
        ReminderType.custom,
      ]);
      expect(model.readState.settings.first.status, ReminderStatus.disabled);
    });
  });
}
