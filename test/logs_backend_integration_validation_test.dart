import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/core/network/api_response_parser.dart';
import 'package:solo_quest/core/api/dto/log_dto.dart';
import 'package:solo_quest/models/enums/log_enums.dart';
import 'package:solo_quest/models/log_entry_model.dart';
import 'package:solo_quest/modules/logs/logs_page_model.dart';
import 'package:solo_quest/modules/logs/widgets/log_timeline_item.dart';
import 'package:solo_quest/modules/logs/widgets/logs_filter_bar.dart';
import 'package:solo_quest/services/log_service.dart';
import 'package:solo_quest/generated/l10n/app_localizations.dart';

void main() {
  group('Logs backend integration validation', () {
    test('parses wrapped GET /api/logs response shape', () {
      final response = {
        'success': true,
        'data': {
          'items': [
            {
              'id': 'legacy-1',
              'type': 'questCompleted',
              'title': 'Quest completed',
              'description': 'Legacy camel case log',
              'created_at': '2026-06-04T08:00:00Z',
            },
            {
              'id': 'roadmap-1',
              'type': 'learning_roadmap_step_completed',
              'title': 'Step completed',
              'description': '',
              'created_at': '2026-06-04T09:00:00Z',
              'quest_id': null,
              'quest_type': null,
            },
            {
              'id': 'level-1',
              'type': 'level_up',
              'title': 'Level up',
              'description': '',
              'created_at': '2026-06-04T09:05:00Z',
            },
            {
              'id': 'system-1',
              'type': 'system',
              'title': 'System event',
              'description': '',
              'created_at': '2026-06-04T09:10:00Z',
            },
            {
              'id': 'future-1',
              'type': 'future_log_type',
              'title': 'Future event',
              'description': '',
              'created_at': '2026-06-04T09:15:00Z',
            },
          ],
          'limit': 20,
          'offset': 0,
        },
      };

      final payload = ApiResponseParser.extractObject(
        response,
        preferredKeys: ['data', 'item', 'result'],
      );
      final dto = LogListDto.fromJson(payload);

      expect(dto.logs.length, 5);
      expect(dto.total, 5);
      expect(dto.limit, 20);
      expect(dto.offset, 0);
      expect(dto.logs[0].type, LogEntryType.questCompleted);
      expect(dto.logs[1].type, LogEntryType.learningRoadmapStepCompleted);
      expect(dto.logs[1].questId, isNull);
      expect(dto.logs[1].questType, isNull);
      expect(dto.logs[2].type, LogEntryType.levelUp);
      expect(dto.logs[3].type, LogEntryType.system);
      expect(dto.logs[4].type, LogEntryType.unknown);
    });

    test('log type api values match backend filters', () {
      expect(
        LogEntryType.learningRoadmapCreated.apiValue,
        'learning_roadmap_created',
      );
      expect(
        LogEntryType.learningRoadmapStepCompleted.apiValue,
        'learning_roadmap_step_completed',
      );
      expect(
        LogEntryType.learningRoadmapCompleted.apiValue,
        'learning_roadmap_completed',
      );
      expect(LogEntryType.levelUp.apiValue, 'level_up');
    });

    test('page model sends backend-compatible type values', () async {
      final service = _CapturingLogService();
      final model = LogsPageModel(logService: service);

      model.selectType(LogEntryType.learningRoadmapStepCompleted);
      await Future<void>.delayed(Duration.zero);

      expect(service.lastType, 'learning_roadmap_step_completed');
      expect(service.lastDate, matches(RegExp(r'^\d{4}-\d{2}-\d{2}$')));
    });

    testWidgets('filter chip emits enum that serializes to backend value',
        (tester) async {
      LogEntryType? selected;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('vi'),
          home: Scaffold(
            body: LogsFilterBar(
              selectedDate: DateTime(2026, 6, 4),
              onDateChanged: (_) {},
              onTypeChanged: (type) => selected = type,
              onClearFilter: () {},
            ),
          ),
        ),
      );

      await tester.drag(find.byType(ListView), const Offset(-600, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bước lộ trình'));

      expect(selected, LogEntryType.learningRoadmapStepCompleted);
      expect(selected?.apiValue, 'learning_roadmap_step_completed');
    });

    testWidgets('timeline renders roadmap log with empty description',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LogTimelineItem(
              log: LogEntryModel(
                id: 'roadmap-1',
                type: LogEntryType.learningRoadmapCompleted,
                title: 'Hoàn thành lộ trình Flutter',
                description: '',
                createdAt: DateTime.utc(2026, 6, 4, 10),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Hoàn thành lộ trình'), findsOneWidget);
      expect(find.text('Hoàn thành lộ trình Flutter'), findsOneWidget);
    });

    testWidgets('timeline renders level up near quest completed logs',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                LogTimelineItem(
                  log: LogEntryModel(
                    id: 'level-1',
                    type: LogEntryType.levelUp,
                    title: 'Đạt cấp 5',
                    description: '',
                    createdAt: DateTime.utc(2026, 6, 4, 10, 2),
                  ),
                ),
                LogTimelineItem(
                  log: LogEntryModel(
                    id: 'quest-1',
                    type: LogEntryType.questCompleted,
                    title: 'Hoàn thành nhiệm vụ',
                    description: 'Nhận 50 EXP',
                    createdAt: DateTime.utc(2026, 6, 4, 10),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Tăng cấp'), findsOneWidget);
      expect(find.text('Đạt cấp 5'), findsOneWidget);
      expect(find.text('Hoàn thành'), findsOneWidget);
      expect(find.text('Hoàn thành nhiệm vụ'), findsOneWidget);
    });
  });
}

class _CapturingLogService implements LogService {
  String? lastType;
  String? lastDate;

  @override
  Future<List<LogEntryModel>> getLogs({
    int page = 1,
    int limit = 20,
    String? type,
    String? questType,
    String? date,
  }) async {
    lastType = type;
    lastDate = date;
    return const [];
  }

  @override
  Future<void> addLog(LogEntryModel log) async {}

  @override
  Future<List<LogEntryModel>> getLogsByDate(DateTime date) async => const [];

  @override
  Future<List<LogEntryModel>> getQuestLogs(String questId) async => const [];
}
