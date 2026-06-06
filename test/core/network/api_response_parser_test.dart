import 'package:flutter_test/flutter_test.dart';
import 'package:solo_quest/core/network/api_response_parser.dart';

void main() {
  group('ApiResponseParser.extractObject', () {
    test('extracts from preferred key (user)', () {
      final raw = {
        'user': {'id': '123', 'name': 'Test'},
      };
      final result = ApiResponseParser.extractObject(
        raw,
        preferredKeys: ['user', 'data'],
      );
      expect(result['id'], '123');
      expect(result['name'], 'Test');
    });

    test('extracts from preferred key (item)', () {
      final raw = {
        'item': {'id': '456', 'title': 'Quest'},
        'message': 'Success',
      };
      final result = ApiResponseParser.extractObject(
        raw,
        preferredKeys: ['item', 'data'],
      );
      expect(result['id'], '456');
    });

    test('extracts from preferred key (data)', () {
      final raw = {
        'data': {'id': '789'},
      };
      final result = ApiResponseParser.extractObject(
        raw,
        preferredKeys: ['data'],
      );
      expect(result['id'], '789');
    });

    test('returns raw map when it already looks like the target', () {
      final raw = {
        'access_token': 'dev-token',
        'refresh_token': 'dev-refresh',
        'user': {'id': '1'},
      };
      final result = ApiResponseParser.extractObject(
        raw,
        preferredKeys: ['data', 'session'],
      );
      expect(result['access_token'], 'dev-token');
    });

    test('throws when preferred keys not found and required fields missing', () {
      final raw = {'status': 'ok', 'code': 200};
      expect(
        () => ApiResponseParser.extractObject(
          raw,
          preferredKeys: ['user', 'data'],
          requiredFields: ['id'],
          context: 'TestService.testMethod',
        ),
        throwsA(isA<FormatException>().having(
          (e) => e.message,
          'message',
          allOf(
            contains('[TestService.testMethod]'),
            contains('preferred keys'),
            contains('[user, data]'),
          ),
        )),
      );
    });

    test('throws when raw is not a Map', () {
      expect(
        () => ApiResponseParser.extractObject(
          'not a map',
          preferredKeys: ['data'],
          context: 'TestService.test',
        ),
        throwsA(isA<FormatException>()),
      );
    });

    test('validates required fields', () {
      final raw = {
        'user': {'name': 'Test'},
      };
      expect(
        () => ApiResponseParser.extractObject(
          raw,
          preferredKeys: ['user'],
          requiredFields: ['id'],
          context: 'TestService.test',
        ),
        throwsA(isA<FormatException>().having(
          (e) => e.message,
          'message',
          contains('Required field "id" missing'),
        )),
      );
    });
  });

  group('ApiResponseParser.extractList', () {
    test('extracts bare list', () {
      final raw = [
        {'id': '1'},
        {'id': '2'},
      ];
      final result = ApiResponseParser.extractList(
        raw,
        preferredKeys: ['items', 'data'],
      );
      expect(result.length, 2);
    });

    test('extracts from preferred key (items)', () {
      final raw = {
        'items': [
          {'id': '1'},
        ],
        'total': 1,
      };
      final result = ApiResponseParser.extractList(
        raw,
        preferredKeys: ['items', 'data'],
      );
      expect(result.length, 1);
    });

    test('extracts from preferred key (quests)', () {
      final raw = {
        'quests': [
          {'id': '1'},
          {'id': '2'},
        ],
      };
      final result = ApiResponseParser.extractList(
        raw,
        preferredKeys: ['items', 'quests', 'data'],
      );
      expect(result.length, 2);
    });

    test('throws when no list found', () {
      final raw = {'status': 'ok'};
      expect(
        () => ApiResponseParser.extractList(
          raw,
          preferredKeys: ['items', 'data'],
          context: 'TestService.getList',
        ),
        throwsA(isA<FormatException>().having(
          (e) => e.message,
          'message',
          allOf(
            contains('[TestService.getList]'),
            contains('preferred keys'),
          ),
        )),
      );
    });
  });
}
