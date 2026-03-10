import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localStorageServiceProvider =
    FutureProvider<LocalStorageService>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return LocalStorageService(prefs);
});

// LocalStorageService
// 앱 재실행 후에도 유지되어야 하는 값 저장소 (예: nickname, onboarding flag, 설정값)
class LocalStorageService {
  const LocalStorageService(this._prefs);

  static const String _keyNickname = 'nickname';
  static const String _guestNickname = 'Guest';

  final SharedPreferences _prefs;

  /// 닉네임을 저장한다.
  Future<void> saveNickname(String nickname) async {
    await _prefs.setString(_keyNickname, nickname);
  }

  /// 닉네임을 조회한다.
  String? getNickname() => _prefs.getString(_keyNickname);

  /// 게스트 모드로 진입한다.
  Future<void> saveGuestSession() async {
    // 사용할 닉네임 저장
    await saveNickname(_guestNickname);
  }

  /// 로컬 스토리지 데이터를 모두 정리한다.
  Future<void> clearSessionAll() async {
    await clearLoginData();
  }

  /// 로그인 사용자와 직접 관련된 데이터만 정리한다.
  Future<void> clearLoginData() async {
    await _prefs.remove(_keyNickname);
  }
}
