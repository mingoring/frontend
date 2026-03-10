import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return const SecureStorageService(FlutterSecureStorage());
});

/// 민감 정보(토큰 등)를 암호화 저장소에 보관하는 서비스.
class SecureStorageService {
  const SecureStorageService(this._storage);

  static const String _accessTokenKey = 'access_token';

  final FlutterSecureStorage _storage;

  Future<void> saveAccessToken(String accessToken) =>
      _storage.write(key: _accessTokenKey, value: accessToken);

  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);

  Future<void> clearAccessToken() => _storage.delete(key: _accessTokenKey);
}
