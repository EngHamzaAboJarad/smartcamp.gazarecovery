import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smartcamp_gazarecovery/core/http_client.dart';

/// DioHelper centralizes Dio initialization and token persistence.
/// It delegates actual Dio configuration to `HttpClient` and persists the
/// auth token using `flutter_secure_storage` so it can be restored at startup.
class DioHelper {
  DioHelper._();

  static const String _kAuthTokenKey = 'auth_token';
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Initialize the Dio client helper. This reads a stored auth token (if any)
  /// and sets it to the `HttpClient`. It also forces the HttpClient.instance
  /// to be created so interceptors are applied.
  static Future<void> init() async {
    try {
      final savedToken = await _storage.read(key: _kAuthTokenKey);
      if (savedToken != null && savedToken.isNotEmpty) {
        HttpClient.setAuthToken(savedToken);
      }
      // Force creation/configuration of Dio instance (interceptors etc.).
      // Accessing instance will configure interceptors lazily in HttpClient.
      // ignore: unused_local_variable
      final _ = HttpClient.instance;
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('DioHelper.init failed: $e');
      }
    }
  }

  /// Save token both in-memory (HttpClient) and persistent secure storage.
  static Future<void> saveToken(String token) async {
    HttpClient.setAuthToken(token);
    try {
      await _storage.write(key: _kAuthTokenKey, value: token);
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('DioHelper.saveToken failed: $e');
      }
    }
  }

  /// Clear token from memory and secure storage.
  static Future<void> clearToken() async {
    HttpClient.clearAuthToken();
    try {
      await _storage.delete(key: _kAuthTokenKey);
    } catch (e) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('DioHelper.clearToken failed: $e');
      }
    }
  }

  /// Expose the Dio instance from HttpClient.
  static get dio => HttpClient.instance;
}

