import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/base/app_load_state.dart';
import 'package:solo_quest/core/api/services/log_api_service.dart';
import 'package:solo_quest/core/api/services/progress_api_service.dart';
import 'package:solo_quest/core/api/services/quest_api_service.dart';
import 'package:solo_quest/core/network/api_client.dart';
import 'package:solo_quest/models/enums/quest_enums.dart';
import 'package:solo_quest/models/log_entry_model.dart';
import 'package:solo_quest/models/quest_model.dart';
import 'package:solo_quest/modules/quest_detail/quest_detail_page_model.dart';
import 'package:solo_quest/services/log_service.dart';
import 'package:solo_quest/services/progress_service.dart';
import 'package:solo_quest/services/quest_service.dart';

void main() {
  group('QuestDetailPageModel', () {
    test('clears previous quest while loading a different quest', () async {
      final questService = _FakeQuestService({
        'old': Future.value(_quest('old', 'Old quest')),
        'new': Completer<QuestModel?>().future,
      });
      final model = QuestDetailPageModel(
        questService: questService,
        logService: _FakeLogService(),
        progressService: _FakeProgressService(),
      );

      await model.loadQuest('old');
      expect(model.readState.loadState, AppLoadState.ready);
      expect(model.readState.quest?.id, 'old');

      unawaited(model.loadQuest('new'));

      expect(model.readState.loadState, AppLoadState.loading);
      expect(model.readState.quest, isNull);
      expect(model.readState.logs, isEmpty);
    });

    test('uses initial quest while refreshing latest data', () async {
      final refreshCompleter = Completer<QuestModel?>();
      final questService = _FakeQuestService({
        'quest_1': refreshCompleter.future,
      });
      final model = QuestDetailPageModel(
        questService: questService,
        logService: _FakeLogService(),
        progressService: _FakeProgressService(),
      );

      final load = model.loadQuest(
        'quest_1',
        initialQuest: _quest('quest_1', 'Cached quest'),
      );

      expect(model.readState.loadState, AppLoadState.loading);
      expect(model.readState.quest?.title, 'Cached quest');

      refreshCompleter.complete(_quest('quest_1', 'Latest quest'));
      await load;

      expect(model.readState.loadState, AppLoadState.ready);
      expect(model.readState.quest?.title, 'Latest quest');
    });

    test('ignores stale load result when a newer quest load wins', () async {
      final oldCompleter = Completer<QuestModel?>();
      final newCompleter = Completer<QuestModel?>();
      final questService = _FakeQuestService({
        'old': oldCompleter.future,
        'new': newCompleter.future,
      });
      final model = QuestDetailPageModel(
        questService: questService,
        logService: _FakeLogService(),
        progressService: _FakeProgressService(),
      );

      final oldLoad = model.loadQuest('old');
      final newLoad = model.loadQuest('new');

      newCompleter.complete(_quest('new', 'New quest'));
      await newLoad;

      expect(model.readState.loadState, AppLoadState.ready);
      expect(model.readState.quest?.id, 'new');

      oldCompleter.complete(_quest('old', 'Old quest'));
      await oldLoad;

      expect(model.readState.loadState, AppLoadState.ready);
      expect(model.readState.quest?.id, 'new');
    });
  });
}

QuestModel _quest(String id, String title) {
  return QuestModel(id: id, title: title, type: QuestType.custom);
}

class _FakeQuestService extends QuestService {
  _FakeQuestService(this.quests)
    : super(
        apiService: QuestApiService(client: ApiClient(baseUrl: 'http://test')),
      );

  final Map<String, Future<QuestModel?>> quests;

  @override
  Future<QuestModel?> getQuestById(String id) {
    return quests[id] ?? Future.value(null);
  }
}

class _FakeLogService extends LogService {
  _FakeLogService()
    : super(
        apiService: LogApiService(client: ApiClient(baseUrl: 'http://test')),
      );

  @override
  Future<List<LogEntryModel>> getQuestLogs(String questId) async {
    return const [];
  }
}

class _FakeProgressService extends ProgressService {
  _FakeProgressService()
    : super(
        apiService: ProgressApiService(
          client: ApiClient(baseUrl: 'http://test'),
        ),
      );
}
