import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/app_session.dart';
import 'app_logger_service.dart';
import 'auth_token_storage.dart';

class Response<T> {
  final int? code;
  final String? message;
  final T? data;

  Response({this.code, this.message, this.data});

  factory Response.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return Response<T>(
      code: json['code'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }

  Response<R> cast<R>(R Function(dynamic json) fromJsonR) {
    return Response<R>(
      code: code,
      message: message,
      data: data != null ? fromJsonR(data) : null,
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

    return uri.replace(queryParameters: filteredQueries.isNotEmpty ? filteredQueries : null);
  }

  Future<Map<String, String>> _buildHeaders() async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final token = await AuthTokenStorage.getAccessToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<Response<dynamic>> execute({int timeout = 240}) async {
    final uri = _buildUri();
    final headers = await _buildHeaders();
    final stopwatch = Stopwatch()..start();

    try {
      http.Response response;

      switch (_method) {
        case 'GET':
          response = await _sharedClient.get(uri, headers: headers).timeout(Duration(seconds: timeout));
          break;
        case 'POST':
          response = await _sharedClient.post(uri, headers: headers, body: jsonEncode(_body)).timeout(Duration(seconds: timeout));
          break;
        case 'PUT':
          response = await _sharedClient.put(uri, headers: headers, body: jsonEncode(_body)).timeout(Duration(seconds: timeout));
          break;
        case 'DELETE':
          response = await _sharedClient.delete(uri, headers: headers).timeout(Duration(seconds: timeout));
          break;
        default:
          throw Exception('Unsupported HTTP method: $_method');
      }

      stopwatch.stop();
      log('$_method $uri [${response.statusCode}] ${stopwatch.elapsedMilliseconds}ms', name: 'HTTP');

      if (response.statusCode == 401 && !_skipUnauthorizedHandler) {
        await AppSession.handleUnauthorized();
        return Response(code: 401, message: 'Unauthorized');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return Response.fromJson(json, (data) => data);
    } on SocketException {
      stopwatch.stop();
      log('$_method $uri [SocketException] ${stopwatch.elapsedMilliseconds}ms', name: 'HTTP', level: 1000);
      return Response(code: -1, message: 'No internet connection');
    } on HttpException {
      stopwatch.stop();
      log('$_method $uri [HttpException] ${stopwatch.elapsedMilliseconds}ms', name: 'HTTP', level: 1000);
      return Response(code: -2, message: 'HTTP error');
    } on TimeoutException {
      stopwatch.stop();
      log('$_method $uri [Timeout] ${stopwatch.elapsedMilliseconds}ms', name: 'HTTP', level: 1000);
      return Response(code: -3, message: 'Request timeout');
    } catch (e) {
      stopwatch.stop();
      log('$_method $uri [Error] $e ${stopwatch.elapsedMilliseconds}ms', name: 'HTTP', level: 1000);
      return Response(code: -4, message: e.toString());
    }
  }

  Future<Response<T>> executeModel<T>(T Function(dynamic json) fromJsonT, {int timeout = 240}) async {
    final response = await execute(timeout: timeout);
    return response.cast(fromJsonT);
  }

  static Future<void> warmUp({required String apiHost, String path = 'health', int count = 3}) async {
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
