import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_keys.dart';
import '../logging/app_logger.dart';

final localStorageServiceProvider =
    FutureProvider<LocalStorageService>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return LocalStorageService(prefs);
});

// LocalStorageService
// 앱 재실행 후에도 유지되어야 하는 값 저장소 (예: nickname, onboarding flag, 설정값)
class LocalStorageService {
  const LocalStorageService(this._prefs);

  static const String _guestNickname = 'Guest';

  final SharedPreferences _prefs;

  /// 닉네임을 저장한다.
  Future<void> saveNickname(String nickname) async {
    final saved = await _prefs.setString(StorageKeys.nickname, nickname);
    if (!saved) AppLogger.w('[LocalStorage] saveNickname 저장 실패 (key: ${StorageKeys.nickname})');
  }

  /// 닉네임을 조회한다.
  String? getNickname() => _prefs.getString(StorageKeys.nickname);

  /// 세션 힌트를 저장한다.
  Future<void> saveSessionHint(String hint) async {
    final saved = await _prefs.setString(StorageKeys.sessionHint, hint);
    if (!saved) AppLogger.w('[LocalStorage] saveSessionHint 저장 실패 (key: ${StorageKeys.sessionHint})');
  }

  /// 세션 힌트를 조회한다.
  String? getSessionHint() => _prefs.getString(StorageKeys.sessionHint);

  /// 세션 힌트를 삭제한다.
  Future<void> clearSessionHint() async {
    await _prefs.remove(StorageKeys.sessionHint);
  }

  /// 게스트 모드로 진입한다.
  Future<void> saveGuestSession() async {
    await saveNickname(_guestNickname);
    await saveSessionHint(StorageKeys.sessionHintGuest);
  }

  /// 온보딩 완료 여부를 저장한다.
  Future<void> saveOnboardingFlag() async {
    final saved = await _prefs.setBool(StorageKeys.onboardingFlag, true);
    if (!saved) AppLogger.w('[LocalStorage] saveOnboardingFlag 저장 실패 (key: ${StorageKeys.onboardingFlag})');
  }

  /// 온보딩 완료 여부를 조회한다.
  bool isOnboardingFlagSet() => _prefs.getBool(StorageKeys.onboardingFlag) ?? false;

  /// 북마크 정렬 기준을 저장한다.
  Future<void> saveBookmarkSort(String apiValue) async {
    final saved = await _prefs.setString(StorageKeys.bookmarkSort, apiValue);
    if (!saved) AppLogger.w('[LocalStorage] saveBookmarkSort 저장 실패 (key: ${StorageKeys.bookmarkSort})');
  }

  /// 북마크 정렬 기준을 조회한다. 저장값이 없으면 null을 반환한다.
  String? getBookmarkSort() => _prefs.getString(StorageKeys.bookmarkSort);

  /// 로컬 스토리지 데이터를 모두 정리한다.
  Future<void> clearSessionAll() async {
    await clearLoginData();
  }

  /// 로그인 사용자와 직접 관련된 데이터만 정리한다.
  Future<void> clearLoginData() async {
    await _prefs.remove(StorageKeys.nickname);
    await clearSessionHint();
  }
}
