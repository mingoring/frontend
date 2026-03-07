import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../../../core/network/dio_client.dart';
import '../../../data/models/signup_request_model.dart';
import '../../../data/models/signup_response_model.dart';

part 'auth_remote_datasource.g.dart';

/// 인증 관련 원격 API 호출 추상 인터페이스.
abstract interface class AuthRemoteDataSource {
  /// POST /api/v1/auth/signup
  Future<SignupResponseModel> signup(SignupRequestModel request);
}

/// [AuthRemoteDataSource] 구현체.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<SignupResponseModel> signup(SignupRequestModel request) async {
    try {
      final response = await _dio.post(
        '/api/v1/auth/signup',
        data: request.toJson(),
      );
      return SignupResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException();
      }

      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        throw ServerException(
          code: data['code'] as String? ?? 'UNKNOWN',
          message: data['message'] as String? ?? '서버 오류가 발생했습니다.',
        );
      }

      throw const UnknownException();
    }
  }
}

@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return AuthRemoteDataSourceImpl(ref.watch(dioClientProvider));
}
