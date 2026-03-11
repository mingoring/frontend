import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/storage_keys.dart';
import '../../../core/storage/app_storage.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../models/auth_state.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    Future.microtask(_init);
    return const AuthState.loading();
  }

  Future<void> _init() async {
    try {
      final secureStorage = ref.read(secureStorageServiceProvider);
      final token = await secureStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        state = AuthState.authenticated(accessToken: token);
        return;
      }

      final localStorage = await ref.read(localStorageServiceProvider.future);
      final hint = localStorage.getSessionHint();
      state = hint == StorageKeys.sessionHintGuest
          ? const AuthState.guest()
          : const AuthState.unauthenticated();
    } catch (_) {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> signIn(String accessToken, {String? refreshToken}) async {
    try {
      final secureStorage = ref.read(secureStorageServiceProvider);
      await secureStorage.saveAccessToken(accessToken);
      if (refreshToken != null) {
        await secureStorage.saveRefreshToken(refreshToken);
      }
      state = AuthState.authenticated(accessToken: accessToken);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> enterGuest() async {
    try {
      final localStorage = await ref.read(localStorageServiceProvider.future);
      await localStorage.saveGuestSession();
      state = const AuthState.guest();
    } catch (_) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      final appStorage = await ref.read(appStorageProvider.future);
      await appStorage.clearLoginData();

      state = const AuthState.unauthenticated();
    } catch (_) {
      rethrow;
    }
  }
}
