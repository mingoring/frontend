abstract final class StorageKeys {
  StorageKeys._();

  // SecureStorage
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';

  // SharedPreferences
  static const String nickname = 'nickname';
  static const String sessionHint = 'session_hint';

  // Session hint values
  static const String sessionHintGuest = 'guest';
}
