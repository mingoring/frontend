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

  // Onboarding
  static const String onboardingFlag = 'onboarding_flag';

  // Bookmark
  static const String bookmarkSort = 'bookmark_sort';
}
