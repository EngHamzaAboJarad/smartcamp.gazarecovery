import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:smartcamp_gazarecovery/core/api_settings.dart';

/// A lightweight singleton Dio wrapper configured for the project.
/// Usage:
///   final res = await HttpClient.instance.get('auth/login', queryParameters: {...});
class HttpClient {
  HttpClient._();

  // Simple in-memory auth token. You can persist this in secure storage and restore on app start.
  static String? _authToken;

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiSettings.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 20),
      responseType: ResponseType.json,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  // Setup interceptors separately so they can reference the _authToken variable.
  static void _configureInterceptors() {
    // Insert auth injector first so it's applied before logging.
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_authToken != null && _authToken!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer ${_authToken!}';
          }
          return handler.next(options);
        },
        onError: (err, handler) {
          // You can add global error handling / refresh token logic here
          return handler.next(err);
        },
      ),
    );

    // Pretty logger - useful during development
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    );
  }

  // Lazily configure interceptors the first time the client is used.
  static bool _interceptorsConfigured = false;

  /// Expose the underlying Dio instance; configure interceptors once on first access.
  static Dio get instance {
    if (!_interceptorsConfigured) {
      _configureInterceptors();
      _interceptorsConfigured = true;
    }
    return _dio;
  }

  /// Set auth token used by the Authorization header for requests.
  static void setAuthToken(String? token) {
    _authToken = token;
  }

  /// Clear stored auth token.
  static void clearAuthToken() {
    _authToken = null;
  }

  // Convenience methods that wrap Dio and unify error handling.
  static Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await instance.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      // Re-throw; caller can catch DioException and inspect e.response/status
      throw e;
    }
  }

  static Future<Response<T>> post<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await instance.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw e;
    }
  }

  static Future<Response<T>> put<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await instance.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw e;
    }
  }

  static Future<Response<T>> delete<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      return await instance.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw e;
    }
  }
}
