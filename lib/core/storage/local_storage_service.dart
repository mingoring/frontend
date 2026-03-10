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

  final SharedPreferences _prefs;

  Future<void> saveNickname(String nickname) async {
    await _prefs.setString(StorageKeys.nickname, nickname);
  }

  String? getNickname() => _prefs.getString(StorageKeys.nickname);

  Future<void> saveTodayDate(DateTime date) async {
    await _prefs.setString(StorageKeys.todayDate, date.toIso8601String());
  }

  DateTime getTodayDate() {
    final raw = _prefs.getString(StorageKeys.todayDate);
    if (raw == null) return DateTime.now();
    return DateTime.tryParse(raw) ?? DateTime.now();
  }
}
