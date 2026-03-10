import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/storage_keys.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return const SecureStorageService(FlutterSecureStorage());
});

/// 민감 정보(토큰 등)를 암호화 저장소에 보관하는 서비스.
class SecureStorageService {
  const SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  Future<void> saveAccessToken(String accessToken) =>
      _storage.write(key: StorageKeys.accessToken, value: accessToken);

  Future<String?> getAccessToken() =>
      _storage.read(key: StorageKeys.accessToken);

  Future<void> clearAccessToken() =>
      _storage.delete(key: StorageKeys.accessToken);

  Future<void> saveRefreshToken(String refreshToken) =>
      _storage.write(key: StorageKeys.refreshToken, value: refreshToken);

  Future<String?> getRefreshToken() =>
      _storage.read(key: StorageKeys.refreshToken);

  Future<void> clearTokens() async {
    await _storage.delete(key: StorageKeys.accessToken);
    await _storage.delete(key: StorageKeys.refreshToken);
  }
}
