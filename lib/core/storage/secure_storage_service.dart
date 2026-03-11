import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/storage_keys.dart';
import '../logging/app_logger.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return const SecureStorageService(FlutterSecureStorage());
});

/// 민감 정보(토큰 등)를 암호화 저장소에 보관하는 서비스.
class SecureStorageService {
  const SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  Future<void> saveAccessToken(String accessToken) async {
    try {
      await _storage.write(key: StorageKeys.accessToken, value: accessToken);
    } catch (e, st) {
      AppLogger.e('[SecureStorage] saveAccessToken 저장 실패 (key: ${StorageKeys.accessToken})', error: e, stackTrace: st);
    }
  }

  Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: StorageKeys.accessToken);
    } catch (e, st) {
      AppLogger.e('[SecureStorage] getAccessToken 조회 실패 (key: ${StorageKeys.accessToken})', error: e, stackTrace: st);
      return null;
    }
  }

  Future<void> clearAccessToken() async {
    try {
      await _storage.delete(key: StorageKeys.accessToken);
    } catch (e, st) {
      AppLogger.e('[SecureStorage] clearAccessToken 삭제 실패 (key: ${StorageKeys.accessToken})', error: e, stackTrace: st);
    }
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      await _storage.write(key: StorageKeys.refreshToken, value: refreshToken);
    } catch (e, st) {
      AppLogger.e('[SecureStorage] saveRefreshToken 저장 실패 (key: ${StorageKeys.refreshToken})', error: e, stackTrace: st);
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: StorageKeys.refreshToken);
    } catch (e, st) {
      AppLogger.e('[SecureStorage] getRefreshToken 조회 실패 (key: ${StorageKeys.refreshToken})', error: e, stackTrace: st);
      return null;
    }
  }

  Future<void> clearRefreshToken() async {
    try {
      await _storage.delete(key: StorageKeys.refreshToken);
    } catch (e, st) {
      AppLogger.e('[SecureStorage] clearRefreshToken 삭제 실패 (key: ${StorageKeys.refreshToken})', error: e, stackTrace: st);
    }
  }

  Future<void> clearTokens() async {
    try {
      await _storage.delete(key: StorageKeys.accessToken);
      await _storage.delete(key: StorageKeys.refreshToken);
    } catch (e, st) {
      AppLogger.e('[SecureStorage] clearTokens 삭제 실패', error: e, stackTrace: st);
    }
  }
}
