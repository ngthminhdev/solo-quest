import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

import '../../network/api_client.dart';
import '../../network/api_response_parser.dart';
import '../dto/auth_dto.dart';

/// Auth API service
/// Handles authentication endpoints
class AuthApiService {
  final ApiClient _client;

  AuthApiService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Google login - POST /api/auth/google
  /// Request: {"id_token": "..."}
  Future<AuthSessionDto> googleLogin({required String idToken}) async {
    try {
      return await _client.post(
        'auth/google',
        body: {'id_token': idToken},
        fromJson: (json) => AuthSessionDto.fromJson(
          _extractAuthSessionMap(json, context: 'AuthApiService.googleLogin'),
        ),
      );
    } catch (e, st) {
      if (kDebugMode) {
        developer.log('[AUTH API] googleLogin() failed: $e');
        developer.log('[AUTH API] StackTrace:\n$st');
      }
      rethrow;
    }
  }

  /// Dev login - POST /api/auth/dev-login
  /// Backend returns direct JSON: {"access_token": "...", "refresh_token": "...", "user": {...}}
  Future<AuthSessionDto> devLogin() async {
    try {
      return await _client.post(
        'auth/dev-login',
        fromJson: (json) {
          final map = _extractAuthSessionMap(
            json,
            context: 'AuthApiService.devLogin',
          );

          if (kDebugMode) {
            developer.log('[AUTH API] devLogin extracted keys: ${map.keys.toList()}');
            developer.log(
              '[AUTH API] has access_token: ${map.containsKey('access_token')}',
            );
          }

          return AuthSessionDto.fromJson(map);
        },
      );
    } catch (e, st) {
      if (kDebugMode) {
        developer.log('[AUTH API] devLogin() failed: $e');
        developer.log('[AUTH API] Error type: ${e.runtimeType}');
        developer.log('[AUTH API] StackTrace:\n$st');
      }
      rethrow;
    }
  }

  /// Current authenticated user - GET /api/auth/me
  Future<AuthUserDto> getMe() async {
    return await _client.get(
      'auth/me',
      fromJson: (json) {
        final map = ApiResponseParser.extractObject(
          json,
          preferredKeys: ['user', 'data', 'profile', 'item'],
          context: 'AuthApiService.getMe',
        );
        return AuthUserDto.fromJson(map);
      },
    );
  }

  /// Refresh token - POST /api/auth/refresh
  Future<AuthSessionDto> refreshToken(String refreshToken) async {
    try {
      return await _client.post(
        'auth/refresh',
        body: {'refresh_token': refreshToken},
        fromJson: (json) => AuthSessionDto.fromJson(
          _extractAuthSessionMap(json, context: 'AuthApiService.refreshToken'),
        ),
      );
    } catch (e, st) {
      if (kDebugMode) {
        developer.log('[AUTH API] refreshToken() failed: $e');
        developer.log('[AUTH API] StackTrace:\n$st');
      }
      rethrow;
    }
  }

  /// Logout - POST /api/auth/logout
  Future<void> logout() async {
    await _client.post('auth/logout');
  }

  static Map<String, dynamic> _extractAuthSessionMap(
    dynamic json, {
    required String context,
  }) {
    final map = ApiResponseParser.extractObject(
      json,
      preferredKeys: ['data', 'session', 'item'],
      context: context,
    );

    if (map.containsKey('access_token') || map.containsKey('accessToken')) {
      return map;
    }

    final nestedSession = map['session'];
    if (nestedSession is Map<String, dynamic>) {
      return nestedSession;
    }

    return map;
  }
}
