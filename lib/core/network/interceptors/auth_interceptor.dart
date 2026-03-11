import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/providers/auth_provider.dart';
import '../../storage/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  const AuthInterceptor(this._secureStorageService, this._ref);

  final SecureStorageService _secureStorageService;
  final Ref _ref;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorageService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // TODO: Refresh Token 갱신 로직 추가 시 여기서 갱신 시도 후 실패할 때만 signOut() 호출로 교체
      await _ref.read(authNotifierProvider.notifier).signOut();
    }
    handler.next(err);
  }
}
