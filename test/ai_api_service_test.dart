import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/core/api/services/ai_api_service.dart';
import 'package:solo_quest/core/network/api_client.dart';

/// Minimal fake ApiClient that returns canned data through the supplied
/// fromJson parser (mirrors how the real ApiClient hands `response.data` to
/// fromJson after unwrapping the envelope).
class FakeApiClient extends Fake implements ApiClient {
  dynamic getData;
  dynamic postData;
  String? lastPostPath;
  Map<String, dynamic>? lastPostBody;
  Map<String, String?>? lastGetQuery;

  @override
  Future<T> post<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String?>? queryParams,
    T Function(dynamic json)? fromJson,
    int timeout = 30,
  }) async {
    lastPostPath = path;
    lastPostBody = body;
    if (fromJson != null) return fromJson(postData);
    return postData as T;
  }

  @override
  Future<T> get<T>(
    String path, {
    Map<String, String?>? queryParams,
    T Function(dynamic json)? fromJson,
    int timeout = 30,
  }) async {
    lastGetQuery = queryParams;
    if (fromJson != null) return fromJson(getData);
    return getData as T;
  }
}

void main() {
  late FakeApiClient client;
  late AiApiService service;

  setUp(() {
    client = FakeApiClient();
    service = AiApiService(client: client);
  });

  group('generateTodayQuests outcome detection', () {
    test('202 generating payload → outcome.isGenerating', () async {
      client.postData = {
        'date': '2026-06-09',
        'status': 'generating',
        'job_id': 'job-123',
        'estimated_seconds': 15,
      };

      final outcome = await service.generateTodayQuests();

      expect(outcome, isNotNull);
      expect(outcome!.isGenerating, isTrue);
      expect(outcome.job!.jobId, 'job-123');
      expect(outcome.job!.estimatedSeconds, 15);
      expect(outcome.result, isNull);
    });

    test('200 quests payload → outcome.result', () async {
      client.postData = {
        'date': '2026-06-09',
        'inserted': true,
        'generated_count': 1,
        'quests': [
          {
            'id': 'q1',
            'title': 'Quest 1',
            'type': 'learning',
            'status': 'pending',
            'difficulty': 'easy',
            'source': 'configBased',
            'exp': 10,
            'estimated_minutes': 20,
          },
        ],
      };

      final outcome = await service.generateTodayQuests();

      expect(outcome, isNotNull);
      expect(outcome!.isGenerating, isFalse);
      expect(outcome.result, isNotNull);
      expect(outcome.result!.quests.length, 1);
      expect(outcome.result!.quests.first.id, 'q1');
    });

    test('sends prefer_ai / force / replace_pending_only in body', () async {
      client.postData = {
        'date': '2026-06-09',
        'status': 'generating',
        'job_id': 'j',
        'estimated_seconds': 15,
      };

      await service.generateTodayQuests(
        preferAI: true,
        force: true,
        replacePendingOnly: true,
        date: '2026-06-09',
      );

      expect(client.lastPostBody?['prefer_ai'], isTrue);
      expect(client.lastPostBody?['force'], isTrue);
      expect(client.lastPostBody?['replace_pending_only'], isTrue);
      expect(client.lastPostBody?['date'], '2026-06-09');
    });
  });

  group('getTodayGenerationStatus parsing', () {
    test('parses completed status with quest_count and source', () async {
      client.getData = {
        'date': '2026-06-09',
        'status': 'completed',
        'job_id': 'job-9',
        'quest_count': 5,
        'source': 'ai',
        'fallback_used': false,
        'error_message': null,
      };

      final status = await service.getTodayGenerationStatus(date: '2026-06-09');

      expect(status, isNotNull);
      expect(status!.isCompleted, isTrue);
      expect(status.questCount, 5);
      expect(status.source, 'ai');
      expect(client.lastGetQuery?['date'], '2026-06-09');
    });

    test('parses failed status with error_message and fallback_used', () async {
      client.getData = {
        'date': '2026-06-09',
        'status': 'failed',
        'job_id': 'job-10',
        'quest_count': 0,
        'source': null,
        'fallback_used': true,
        'error_message': 'provider error',
      };

      final status = await service.getTodayGenerationStatus();

      expect(status!.isFailed, isTrue);
      expect(status.fallbackUsed, isTrue);
      expect(status.errorMessage, 'provider error');
    });

    test('parses not_started status', () async {
      client.getData = {'date': '2026-06-09', 'status': 'not_started'};
      final status = await service.getTodayGenerationStatus();
      expect(status!.isNotStarted, isTrue);
    });

    test('parses stale status', () async {
      client.getData = {'date': '2026-06-09', 'status': 'stale', 'job_id': 'j'};
      final status = await service.getTodayGenerationStatus();
      expect(status!.isStale, isTrue);
    });
  });
}
