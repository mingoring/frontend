import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_keys.dart';

final localStorageServiceProvider =
    FutureProvider<LocalStorageService>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return LocalStorageService(prefs);
});

class LocalStorageService {
  const LocalStorageService(this._prefs);

  static const String _guestNickname = 'Guest';

  final SharedPreferences _prefs;

  Future<void> saveNickname(String nickname) async {
    await _prefs.setString(StorageKeys.nickname, nickname);
  }

  String? getNickname() => _prefs.getString(StorageKeys.nickname);

  Future<void> saveAccessToken(String accessToken) async {
    await _prefs.setString(StorageKeys.accessToken, accessToken);
  }

  String? getAccessToken() => _prefs.getString(StorageKeys.accessToken);

  /// 사용자 세션 데이터를 모두 정리한다.
  Future<void> clearSessionForLogout() async {
    await _prefs.remove(StorageKeys.accessToken);
    await _prefs.remove(StorageKeys.nickname);
    await _prefs.remove(StorageKeys.todayDate);
  }

  /// 게스트 모드로 진입한다. (사용할 닉네임 저장)
  Future<void> saveGuestSession() async {
    await saveNickname(_guestNickname);
  }

  Future<void> saveTodayDate(DateTime date) async {
    await _prefs.setString(StorageKeys.todayDate, date.toIso8601String());
  }

  DateTime getTodayDate() {
    final raw = _prefs.getString(StorageKeys.todayDate);
    if (raw == null) return DateTime.now();
    return DateTime.tryParse(raw) ?? DateTime.now();
  }
}
