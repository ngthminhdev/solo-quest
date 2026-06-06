import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../base/app_load_state.dart';
import '../../base/base_page_model.dart';
import '../../base/base_page_state.dart';
import '../../models/enums/log_enums.dart';
import '../../models/enums/reminder_enums.dart';
import '../../models/log_entry_model.dart';
import '../../models/reminder_setting_model.dart';
import '../../services/log_service.dart';
import '../../services/reminder_service.dart';
import '../../services/service_providers.dart';

class ReminderSettingsPageState extends BasePageState {
  final AppLoadState loadState;
  final List<ReminderSettingModel> settings;
  final ReminderType? selectedType;
  final String? errorMessage;

  ReminderSettingsPageState({
    this.loadState = AppLoadState.idle,
    this.settings = const [],
    this.selectedType,
    this.errorMessage,
    super.isLockedPage,
  });

  @override
  ReminderSettingsPageState updateState({
    AppLoadState? loadState,
    List<ReminderSettingModel>? settings,
    ReminderType? selectedType,
    bool clearSelectedType = false,
    String? errorMessage,
    bool? isLockedPage,
  }) {
    return ReminderSettingsPageState(
      loadState: loadState ?? this.loadState,
      settings: settings ?? this.settings,
      selectedType: clearSelectedType
          ? null
          : selectedType ?? this.selectedType,
      errorMessage: errorMessage ?? this.errorMessage,
      isLockedPage: isLockedPage ?? this.isLockedPage,
    );
  }

  List<ReminderSettingModel> get filteredSettings {
    if (selectedType == null) return settings;
    return settings.where((item) => item.type == selectedType).toList();
  }

  int get totalSettings => settings.length;

  int get enabledCount =>
      settings.where((item) => item.status == ReminderStatus.enabled).length;

  int get disabledCount =>
      settings.where((item) => item.status == ReminderStatus.disabled).length;

  bool get hasSettings => settings.isNotEmpty;
}

class ReminderSettingsPageModel
    extends BasePageModel<ReminderSettingsPageState> {
  ReminderSettingsPageModel({
    required this.reminderService,
    required this.logService,
  }) : super(ReminderSettingsPageState());

  final ReminderService reminderService;
  final LogService logService;

  Future<void> loadSettings() async {
    try {
      state = state.updateState(loadState: AppLoadState.loading);

      final settings = await reminderService.getReminderSettings();

      state = state.updateState(
        loadState: AppLoadState.ready,
        settings: _sortSettings(settings),
        errorMessage: null,
      );
    } catch (e) {
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refreshSettings() async {
    try {
      final settings = await reminderService.getReminderSettings();

      state = state.updateState(
        loadState: AppLoadState.ready,
        settings: _sortSettings(settings),
        errorMessage: null,
      );
    } catch (e) {
      state = state.updateState(
        loadState: AppLoadState.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> toggleReminder({
    required String settingId,
    required bool enabled,
  }) async {
    try {
      state = state.updateState(isLockedPage: true);

      final updated = await reminderService.toggleReminder(
        settingId,
        enabled: enabled,
      );

      await logService.addLog(
        LogEntryModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: LogEntryType.ruleUpdated,
          title: enabled ? 'reminderSettingsLogToggleOn' : 'reminderSettingsLogToggleOff',
          description: updated.title,
          createdAt: DateTime.now(),
        ),
      );

      await loadSettings();
      state = state.updateState(isLockedPage: false);
      return true;
    } catch (e) {
      state = state.updateState(
        isLockedPage: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<bool> updateSetting(ReminderSettingModel setting) async {
    try {
      state = state.updateState(isLockedPage: true);

      final updated = await reminderService.updateReminderSetting(setting);

      await logService.addLog(
        LogEntryModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: LogEntryType.ruleUpdated,
          title: 'reminderSettingsLogUpdate',
          description: updated.title,
          createdAt: DateTime.now(),
        ),
      );

      await loadSettings();
      state = state.updateState(isLockedPage: false);
      return true;
    } catch (e) {
      state = state.updateState(
        isLockedPage: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  void selectType(ReminderType? type) {
    state = state.updateState(selectedType: type);
  }

  void clearTypeFilter() {
    state = state.updateState(clearSelectedType: true);
  }

  List<ReminderSettingModel> _sortSettings(
    List<ReminderSettingModel> settings,
  ) {
    final sorted = List<ReminderSettingModel>.from(settings);
    sorted.sort((a, b) {
      if (a.isEnabled != b.isEnabled) {
        return a.isEnabled ? -1 : 1;
      }
      return a.type.index.compareTo(b.type.index);
    });
    return sorted;
  }
}

final reminderSettingsPageProvider =
    StateNotifierProvider<ReminderSettingsPageModel, ReminderSettingsPageState>(
      (ref) {
        return ReminderSettingsPageModel(
          reminderService: ref.read(reminderServiceProvider),
          logService: ref.read(logServiceProvider),
        );
      },
    );
