import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../config/app_session.dart';
import '../core/network/api_pagination.dart';
import '../core/network/api_response_parser.dart';
import '../widgets/app_toast/app_toast_service.dart';
import 'auth_token_storage.dart';

class Response<T> {
  final int? code;
  final String? message;
  final T? data;
  final ApiPagination? pagination;

  Response({this.code, this.message, this.data, this.pagination});

  factory Response.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return Response<T>(
      code: json['code'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      pagination: json['pagination'] != null
          ? ApiPagination.fromJson(json['pagination'] as Map<String, dynamic>)
          : null,
    );
  }

  Response<R> cast<R>(R Function(dynamic json) fromJsonR) {
    return Response<R>(
      code: code,
      message: message,
      data: data != null ? fromJsonR(data) : null,
      pagination: pagination,
    );
  }
}

class HttpService {
  static http.Client _sharedClient = http.Client();

  String _host = '';
  String _method = 'GET';
  final Map<String, dynamic> _body = {};
  final Map<String, String?> _queries = {};
  final List<String?> _paths = ['api'];
  bool _skipUnauthorizedHandler = false;

  HttpService withHost(String apiHost) {
    _host = apiHost;
    return this;
  }

  HttpService withVersion(String version) {
    _paths.add(version);
    return this;
  }

  HttpService withPath(String? path) {
    _paths.add(path);
    return this;
  }

  HttpService makeGet() {
    _method = 'GET';
    return this;
  }

  HttpService makePost() {
    _method = 'POST';
    return this;
  }

  HttpService makePut() {
    _method = 'PUT';
    return this;
  }

  HttpService makePatch() {
    _method = 'PATCH';
    return this;
  }

  HttpService makeDelete() {
    _method = 'DELETE';
    return this;
  }

  HttpService withBody(Map<String, dynamic> data) {
    _body.addAll(data);
    return this;
  }

  HttpService withQueries(Map<String, String?> data) {
    _queries.addAll(data);
    return this;
  }

  HttpService skipUnauthorizedHandler() {
    _skipUnauthorizedHandler = true;
    return this;
  }

  Uri _buildUri() {
    final pathSegments = _paths.where((p) => p != null).cast<String>().toList();
    final path = pathSegments.join('/');
    final uri = Uri.parse('$_host/$path');

    final filteredQueries = Map<String, String>.from(
      _queries.map((key, value) => MapEntry(key, value ?? '')),
    );

    return uri.replace(
      queryParameters: filteredQueries.isNotEmpty ? filteredQueries : null,
    );
  }

  Future<Map<String, String>> _buildHeaders() async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final tokenStorage = AuthTokenStorage();
    final token = await tokenStorage.getAccessToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  /// Safely parse JSON body. Returns null if body is empty or not valid JSON.
  static dynamic _safeParseJson(String body) {
    if (body.isEmpty) return null;
    try {
      return jsonDecode(body);
    } on FormatException {
      return null;
    }
  }

  /// Mask Authorization token for logging: "Bearer abc123...xyz"
  static String _maskAuthHeader(String? authHeader) {
    if (authHeader == null || authHeader.isEmpty) return 'none';
    if (authHeader.startsWith('Bearer ')) {
      final token = authHeader.substring(7);
      if (token.length > 12) {
        return 'Bearer ${token.substring(0, 6)}...${token.substring(token.length - 4)}';
      }
      return 'Bearer ***';
    }
    return authHeader;
  }

  static String _normalizeKey(String key) {
    return key.toLowerCase().replaceAll('_', '').replaceAll('-', '');
  }

  static final Set<String> _sensitiveKeysNormalized = {
    'accesstoken',
    'refreshtoken',
    'idtoken',
    'token',
    'authorization',
    'password',
    'secret',
    'clientsecret',
    'apikey',
  };

  static dynamic _maskJson(dynamic json) {
    if (json is Map) {
      final Map<String, dynamic> result = {};
      json.forEach((key, value) {
        final normKey = _normalizeKey(key);
        if (_sensitiveKeysNormalized.contains(normKey)) {
          result[key] = '***masked***';
        } else {
          result[key] = _maskJson(value);
        }
      });
      return result;
    } else if (json is List) {
      return json.map((item) => _maskJson(item)).toList();
    }
    return json;
  }

  static String _maskRawText(String text) {
    final regex = RegExp(
      r'("?(?:access_token|refresh_token|id_token|token|accessToken|refreshToken|idToken|authorization|password|secret|client_secret|api_key)"?)(\s*[:=]\s*)(?:"([^"]*)"|([^\s&",\)]+))',
      caseSensitive: false,
    );
    
    return text.replaceAllMapped(regex, (match) {
      final key = match.group(1);
      final separator = match.group(2);
      final quotedValue = match.group(3);
      
      if (quotedValue != null) {
        return '$key$separator"***masked***"';
      } else {
        return '$key$separator***masked***';
      }
    });
  }

  static String sanitizeResponseBody(String body) {
    if (body.isEmpty) return body;
    try {
      final parsed = jsonDecode(body);
      final masked = _maskJson(parsed);
      return jsonEncode(masked);
    } catch (_) {
      return _maskRawText(body);
    }
  }

  Future<Response<dynamic>> execute({
    int timeout = 240,
    bool isRetry = false,
  }) async {
    final uri = _buildUri();
    final headers = await _buildHeaders();
    final body = Map<String, dynamic>.from(_body);
    final bodyJson = body.isNotEmpty ? jsonEncode(body) : '';
    final stopwatch = Stopwatch()..start();

    // --- Debug: Log request ---
    if (kDebugMode) {
      developer.log('[HTTP REQUEST] $_method $uri');
      developer.log(
        '[HTTP REQUEST] Headers: {Content-Type: ${headers['Content-Type']}, Authorization: ${_maskAuthHeader(headers['Authorization'])}}',
      );
      if (bodyJson.isNotEmpty) {
        final sanitizedRequest = sanitizeResponseBody(bodyJson);
        developer.log('[HTTP REQUEST] Body: $sanitizedRequest');
      }
    }

    try {
      http.Response response;

      switch (_method) {
        case 'GET':
          response = await _sharedClient
              .get(uri, headers: headers)
              .timeout(Duration(seconds: timeout));
          break;
        case 'POST':
          response = await _sharedClient
              .post(uri, headers: headers, body: bodyJson)
              .timeout(Duration(seconds: timeout));
          break;
        case 'PUT':
          response = await _sharedClient
              .put(uri, headers: headers, body: bodyJson)
              .timeout(Duration(seconds: timeout));
          break;
        case 'PATCH':
          response = await _sharedClient
              .patch(uri, headers: headers, body: bodyJson)
              .timeout(Duration(seconds: timeout));
          break;
        case 'DELETE':
          response = await _sharedClient
              .delete(uri, headers: headers)
              .timeout(Duration(seconds: timeout));
          break;
        default:
          throw Exception('Unsupported HTTP method: $_method');
      }

      stopwatch.stop();

      // --- Debug: Log response ---
      if (kDebugMode) {
        final respBody = response.body;
        final sanitizedBody = sanitizeResponseBody(respBody);
        final truncatedBody = sanitizedBody.length > 500
            ? '${sanitizedBody.substring(0, 500)}...[truncated]'
            : sanitizedBody;
        developer.log('[HTTP RESPONSE] $_method $uri');
        developer.log(
          '[HTTP RESPONSE] Status: ${response.statusCode} | Duration: ${stopwatch.elapsedMilliseconds}ms',
        );
        if (truncatedBody.isNotEmpty) {
          developer.log('[HTTP RESPONSE] Body: $truncatedBody');
        }
      }

      // Handle 401 with token refresh retry
      if (response.statusCode == 401 && !_skipUnauthorizedHandler && !isRetry) {
        final refreshed = await _tryRefreshToken();
        if (refreshed) {
          return execute(timeout: timeout, isRetry: true);
        }
        await AppSession.handleUnauthorized();
        return Response(code: 401, message: 'Unauthorized');
      }

      // Safely parse response body
      final parsed = _safeParseJson(response.body);

      // Non-2xx: build error from parsed JSON or raw body
      if (response.statusCode < 200 || response.statusCode >= 300) {
        String errorMessage;
        if (parsed is Map<String, dynamic>) {
          errorMessage =
              parsed['message'] as String? ??
              parsed['error'] as String? ??
              'Server error';

          // Auto-show error toast
          _showErrorToast(errorMessage, response.statusCode);

          return Response(
            code: response.statusCode,
            message: errorMessage,
            data: parsed,
          );
        }
        // Non-JSON error body (e.g. "404 page not found")
        final rawBody = response.body.isNotEmpty
            ? response.body
            : 'Empty response';
        errorMessage = 'HTTP ${response.statusCode}: $rawBody';

        // Auto-show error toast
        _showErrorToast(errorMessage, response.statusCode);

        return Response(
          code: response.statusCode,
          message: errorMessage,
          data: null,
        );
      }

      // 2xx success
      if (parsed == null) {
        // Empty body on success (e.g. POST /api/auth/logout returning 200 with no body)
        return Response(code: response.statusCode, message: 'OK', data: null);
      }

      if (parsed is Map<String, dynamic>) {
        // Check if this is a wrapped response: {"code": ..., "message": ..., "data": ...}
        // vs a direct response: {"access_token": "...", "user" {...}}
        if (parsed.containsKey('data') &&
            (parsed.containsKey('code') || parsed.containsKey('message'))) {
          return Response.fromJson(parsed, (data) => data);
        }
        // Direct response — use the entire map as data
        return Response(code: response.statusCode, message: 'OK', data: parsed);
      }

      // Non-JSON success body (unusual but handle safely)
      return Response(code: response.statusCode, message: 'OK', data: parsed);
    } on SocketException {
      stopwatch.stop();
      if (kDebugMode) {
        developer.log(
          '[HTTP ERROR] $_method $uri | SocketException | ${stopwatch.elapsedMilliseconds}ms',
        );
      }
      const errorMessage = 'Không có kết nối mạng';
      _showErrorToast(errorMessage, -1);
      return Response(code: -1, message: errorMessage);
    } on HttpException {
      stopwatch.stop();
      if (kDebugMode) {
        developer.log(
          '[HTTP ERROR] $_method $uri | HttpException | ${stopwatch.elapsedMilliseconds}ms',
        );
      }
      const errorMessage = 'Lỗi kết nối HTTP';
      _showErrorToast(errorMessage, -2);
      return Response(code: -2, message: errorMessage);
    } on TimeoutException {
      stopwatch.stop();
      if (kDebugMode) {
        developer.log(
          '[HTTP ERROR] $_method $uri | Timeout | ${stopwatch.elapsedMilliseconds}ms',
        );
      }
      const errorMessage = 'Yêu cầu hết thời gian chờ';
      _showErrorToast(errorMessage, -3);
      return Response(code: -3, message: errorMessage);
    } catch (e) {
      stopwatch.stop();
      if (kDebugMode) {
        developer.log(
          '[HTTP ERROR] $_method $uri | $e | ${stopwatch.elapsedMilliseconds}ms',
        );
      }
      final errorMessage = 'Lỗi: ${e.toString()}';
      _showErrorToast(errorMessage, -4);
      return Response(code: -4, message: errorMessage);
    }
  }

  /// Show error toast on main thread
  static void _showErrorToast(String message, int statusCode) {
    // Get navigator context to show toast
    final context = AppSession.navigatorKey.currentContext;
    if (context != null && context.mounted) {
      // Post to next frame to avoid showing toast during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          // User-friendly error messages
          String displayMessage = message;

          // Map common HTTP errors to Vietnamese
          if (statusCode == 400) {
            displayMessage = 'Yêu cầu không hợp lệ';
          } else if (statusCode == 404) {
            displayMessage = 'Không tìm thấy';
          } else if (statusCode == 500) {
            displayMessage = 'Lỗi máy chủ';
          } else if (statusCode >= 500) {
            displayMessage = 'Lỗi máy chủ';
          }

          // Show original message if it's more specific
          if (message.isNotEmpty && !message.startsWith('HTTP ')) {
            displayMessage = message;
          }

          AppToastService.error(context, displayMessage);

          // Also log for debugging
          if (kDebugMode) {
            developer.log('[AUTO TOAST] [$statusCode] $displayMessage');
          }
        }
      });
    }
  }

  /// Try to refresh the access token using the refresh token.
  /// Returns true if refresh succeeded and tokens were saved.
  static Future<bool> _tryRefreshToken() async {
    try {
      final tokenStorage = AuthTokenStorage();
      final refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken == null) return false;

      final refreshUri = Uri.parse('$_sharedHost/api/auth/refresh');
      if (kDebugMode) {
        developer.log('[HTTP REQUEST] POST $refreshUri (token refresh)');
      }

      final response = await _sharedClient
          .post(
            refreshUri,
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'refresh_token': refreshToken}),
          )
          .timeout(const Duration(seconds: 10));

      if (kDebugMode) {
        developer.log(
          '[HTTP RESPONSE] POST $refreshUri | Status: ${response.statusCode}',
        );
      }

      if (response.statusCode == 200) {
        final parsed = _safeParseJson(response.body);
        if (parsed is Map<String, dynamic>) {
          final sessionMap = _extractRefreshSessionMap(parsed);
          final newAccessToken =
              sessionMap['access_token'] as String? ??
              sessionMap['accessToken'] as String?;
          final newRefreshToken =
              sessionMap['refresh_token'] as String? ??
              sessionMap['refreshToken'] as String?;
          if (newAccessToken != null && newRefreshToken != null) {
            await tokenStorage.saveSessionTokens(
              accessToken: newAccessToken,
              refreshToken: newRefreshToken,
            );
            if (kDebugMode) {
              developer.log('[AUTH] Token refresh succeeded');
            }
            return true;
          }
        }
      }

      if (kDebugMode) {
        developer.log('[AUTH] Token refresh failed: ${response.statusCode}');
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        developer.log('[AUTH] Token refresh error: $e');
      }
      return false;
    }
  }

  static Map<String, dynamic> _extractRefreshSessionMap(
    Map<String, dynamic> parsed,
  ) {
    final map = ApiResponseParser.extractObject(
      parsed,
      preferredKeys: ['data', 'session', 'item'],
      context: 'HttpService._tryRefreshToken',
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

  static String _sharedHost = '';

  /// Set the shared host for token refresh calls.
  /// Called once during app initialization.
  static void setSharedHost(String host) {
    _sharedHost = host;
  }

  Future<Response<T>> executeModel<T>(
    T Function(dynamic json) fromJsonT, {
    int timeout = 240,
  }) async {
    final response = await execute(timeout: timeout);
    return response.cast(fromJsonT);
  }

  static Future<void> warmUp({
    required String apiHost,
    String path = 'health',
    int count = 3,
  }) async {
    for (var i = 0; i < count; i++) {
      try {
        await HttpService()
            .withHost(apiHost)
            .withPath(path)
            .makeGet()
            .skipUnauthorizedHandler()
            .execute(timeout: 5);
      } catch (_) {}
    }
  }

  static void resetClient() {
    _sharedClient.close();
    _sharedClient = http.Client();
  }
}
