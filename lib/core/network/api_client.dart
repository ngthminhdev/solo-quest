import '../../../config/app_config.dart';
import '../../../services/http_services.dart';
import '../network/api_exception.dart';

/// Base API client that wraps HttpService
/// Provides consistent error handling and base URL management
class ApiClient {
  final String baseUrl;

  ApiClient({String? baseUrl})
    : baseUrl = baseUrl ?? AppConfig.instance.apiHost;

  /// Execute GET request
  Future<T> get<T>(
    String path, {
    Map<String, String?>? queryParams,
    T Function(dynamic json)? fromJson,
    int timeout = 30,
  }) async {
    try {
      final service = HttpService().withHost(baseUrl).withPath(path).makeGet();

      if (queryParams != null) {
        service.withQueries(queryParams);
      }

      final response = await service.execute(timeout: timeout);

      if (response.code == null ||
          response.code! < 200 ||
          response.code! >= 300) {
        throw _parseError(response.code, response.message, response.data);
      }

      if (fromJson != null && response.data != null) {
        return fromJson(response.data);
      }

      return response.data as T;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        error: 'client_error',
        message: '${e.runtimeType}: $e',
      );
    }
  }

  /// Execute POST request
  Future<T> post<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String?>? queryParams,
    T Function(dynamic json)? fromJson,
    int timeout = 30,
  }) async {
    try {
      final service = HttpService().withHost(baseUrl).withPath(path).makePost();

      if (body != null) {
        service.withBody(body);
      }

      if (queryParams != null) {
        service.withQueries(queryParams);
      }

      final response = await service.execute(timeout: timeout);

      if (response.code == null ||
          response.code! < 200 ||
          response.code! >= 300) {
        throw _parseError(response.code, response.message, response.data);
      }

      if (fromJson != null && response.data != null) {
        return fromJson(response.data);
      }

      return response.data as T;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        error: 'client_error',
        message: '${e.runtimeType}: $e',
      );
    }
  }

  /// Execute PUT request
  Future<T> put<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String?>? queryParams,
    T Function(dynamic json)? fromJson,
    int timeout = 30,
  }) async {
    try {
      final service = HttpService().withHost(baseUrl).withPath(path).makePut();

      if (body != null) {
        service.withBody(body);
      }

      if (queryParams != null) {
        service.withQueries(queryParams);
      }

      final response = await service.execute(timeout: timeout);

      if (response.code == null ||
          response.code! < 200 ||
          response.code! >= 300) {
        throw _parseError(response.code, response.message, response.data);
      }

      if (fromJson != null && response.data != null) {
        return fromJson(response.data);
      }

      return response.data as T;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        error: 'client_error',
        message: '${e.runtimeType}: $e',
      );
    }
  }

  /// Execute PATCH request
  Future<T> patch<T>(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String?>? queryParams,
    T Function(dynamic json)? fromJson,
    int timeout = 30,
  }) async {
    try {
      final service = HttpService()
          .withHost(baseUrl)
          .withPath(path)
          .makePatch();

      if (body != null) {
        service.withBody(body);
      }

      if (queryParams != null) {
        service.withQueries(queryParams);
      }

      final response = await service.execute(timeout: timeout);

      if (response.code == null ||
          response.code! < 200 ||
          response.code! >= 300) {
        throw _parseError(response.code, response.message, response.data);
      }

      if (fromJson != null && response.data != null) {
        return fromJson(response.data);
      }

      return response.data as T;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        error: 'client_error',
        message: '${e.runtimeType}: $e',
      );
    }
  }

  /// Execute DELETE request
  Future<T> delete<T>(
    String path, {
    Map<String, String?>? queryParams,
    T Function(dynamic json)? fromJson,
    int timeout = 30,
  }) async {
    try {
      final service = HttpService()
          .withHost(baseUrl)
          .withPath(path)
          .makeDelete();

      if (queryParams != null) {
        service.withQueries(queryParams);
      }

      final response = await service.execute(timeout: timeout);

      if (response.code == null ||
          response.code! < 200 ||
          response.code! >= 300) {
        throw _parseError(response.code, response.message, response.data);
      }

      if (fromJson != null && response.data != null) {
        return fromJson(response.data);
      }

      return response.data as T;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        error: 'client_error',
        message: '${e.runtimeType}: $e',
      );
    }
  }

  /// Parse error from response
  ApiException _parseError(int? statusCode, String? message, dynamic data) {
    if (data is Map<String, dynamic>) {
      return ApiException.fromJson(data, statusCode: statusCode);
    }

    if (statusCode == 401) {
      return ApiException.unauthorized();
    }

    return ApiException(
      statusCode: statusCode,
      error: 'server_error',
      message: message ?? 'Unknown error',
    );
  }
}
