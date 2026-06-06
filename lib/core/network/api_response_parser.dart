import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Reusable response payload extraction for backend API responses.
///
/// Backend endpoints return various JSON shapes:
/// - Direct: {"access_token": "...", "user": {...}}
/// - Wrapped: {"user": {...}}, {"item": {...}}, {"data": {...}}
/// - List: {"items": [...]}, {"quests": [...]}, {"logs": [...]}
/// - Bare list: [...]
///
/// This parser extracts the correct payload from any of these shapes
/// with clear error messages when parsing fails.
class ApiResponseParser {
  ApiResponseParser._();

  /// Extract a single object from a response.
  ///
  /// Tries preferredKeys in order, then checks if raw is already the object.
  /// [requiredFields] optionally validates the extracted map has these keys.
  ///
  /// Example:
  /// ```dart
  /// final json = extractObject(response, preferredKeys: ['user']);
  /// return UserProfileDto.fromJson(json);
  /// ```
  static Map<String, dynamic> extractObject(
    dynamic raw, {
    required List<String> preferredKeys,
    List<String>? requiredFields,
    String? context,
  }) {
    if (raw is! Map<String, dynamic>) {
      _throwParseError(
        context: context,
        reason: 'Response is not a Map (type: ${raw.runtimeType})',
        availableKeys: _tryGetKeys(raw),
      );
    }

    final map = raw;

    // Try preferred keys first
    for (final key in preferredKeys) {
      if (map.containsKey(key) && map[key] is Map<String, dynamic>) {
        final nested = map[key] as Map<String, dynamic>;
        if (requiredFields != null) {
          _validateFields(nested, requiredFields, context, map.keys.toList());
        }
        return nested;
      }
    }

    // Check if the map itself looks like the target (has at least one preferred key's typical fields)
    // This handles direct responses like {"access_token": "...", "user": {...}}
    if (requiredFields == null || requiredFields.every((f) => map.containsKey(f))) {
      return map;
    }

    // None of the preferred keys found and map doesn't look like the target
    _throwParseError(
      context: context,
      reason: 'None of preferred keys $preferredKeys found in response',
      availableKeys: map.keys.toList(),
    );
  }

  /// Extract a list from a response.
  ///
  /// Tries preferredKeys in order, then checks if raw is already a list.
  ///
  /// Example:
  /// ```dart
  /// final list = extractList(response, preferredKeys: ['items', 'quests']);
  /// return list.map((e) => QuestDto.fromJson(e)).toList();
  /// ```
  static List<dynamic> extractList(
    dynamic raw, {
    required List<String> preferredKeys,
    String? context,
  }) {
    // Raw is already a list
    if (raw is List) return raw;

    if (raw is Map<String, dynamic>) {
      // Try preferred keys
      for (final key in preferredKeys) {
        if (raw.containsKey(key) && raw[key] is List) {
          return raw[key] as List;
        }
      }

      _throwParseError(
        context: context,
        reason: 'None of preferred keys $preferredKeys found as List in response',
        availableKeys: raw.keys.toList(),
      );
    }

    _throwParseError(
      context: context,
      reason: 'Response is not a Map or List (type: ${raw.runtimeType})',
      availableKeys: _tryGetKeys(raw),
    );
  }

  /// Extract a single object from a list-wrapped or object-wrapped response.
  ///
  /// This handles cases where the backend might return:
  /// - {"item": {...}} or {"data": {...}} or {"user": {...}}
  /// - A direct object with the fields
  ///
  /// Unlike [extractObject], this does NOT require all preferredKeys —
  /// it returns the first match.
  static Map<String, dynamic> extractFirstObject(
    dynamic raw, {
    required List<String> preferredKeys,
    String? context,
  }) {
    return extractObject(
      raw,
      preferredKeys: preferredKeys,
      context: context,
    );
  }

  /// Validate that a map contains all required fields.
  static void _validateFields(
    Map<String, dynamic> map,
    List<String> requiredFields,
    String? context,
    List<String> availableKeys,
  ) {
    for (final field in requiredFields) {
      if (!map.containsKey(field)) {
        _throwParseError(
          context: context,
          reason: 'Required field "$field" missing from extracted object',
          availableKeys: map.keys.toList(),
        );
      }
    }
  }

  /// Throw a clear parse error with context.
  static Never _throwParseError({
    String? context,
    required String reason,
    List<String>? availableKeys,
  }) {
    final contextStr = context != null ? '[$context] ' : '';
    final keysStr = availableKeys != null ? ' Available keys: $availableKeys' : '';
    final message = '${contextStr}Response parse failed: $reason$keysStr';

    if (kDebugMode) {
      developer.log('[API PARSE ERROR] $message');
    }

    throw FormatException(message);
  }

  /// Try to get keys from a value (for error messages).
  static List<String>? _tryGetKeys(dynamic value) {
    if (value is Map) return value.keys.cast<String>().toList();
    return null;
  }
}
