// Auto-generated API settings file
// Path: lib/core/api_settings.dart

class ApiSettings {
  // Base URL for all API calls
  // Use: ApiSettings.baseUrl
  static const String _baseUrl = 'https://smartcamp.gazarecovery.com/api/v1/';
  static const String send_otp = '${_baseUrl}manager/send-otp';
  static const String verify_otp = '${_baseUrl}manager/verify-otp';
  static const String profile = '${_baseUrl}manager/profile';
  static const String home = '${_baseUrl}manager/dashboard/home';
  static const String create_tents = '${_baseUrl}manager/camps/19/tents';
  // Returns a full endpoint URL by joining the baseUrl with the provided path.
  // Example: ApiSettings.endpoint('
  //
  // otp/login') -> 'http://.../api/v1/auth/login'
  static String endpoint(String path) {
    if (path.isEmpty) return _baseUrl;
    // Remove leading slashes from path to avoid double slashes
    final normalized = path.startsWith('/') ? path.substring(1) : path;
    return '$_baseUrl$normalized';
  }
  static String get baseUrl => _baseUrl;
  // Private constructor to prevent instantiation
  ApiSettings._();
}
