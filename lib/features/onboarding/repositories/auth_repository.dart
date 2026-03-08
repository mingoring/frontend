import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/network/dio_client.dart';
import '../dto/signup_request_dto.dart';
import '../dto/signup_response_dto.dart';
import '../errors/signup_error_mapper.dart';
import '../models/terms_info_model.dart';
import '../models/signup_response_model.dart';

part 'auth_repository.g.dart';

// 회원가입 저장소 추상 인터페이스
abstract interface class AuthRepository {
  Future<SignupResponseModel> signup({
    required TermsInfoModel terms,
    required String nickname,
    required int level,
    required List<String> interests,
    String? referralCode,
  });
}

// 회원가입 저장소 구현체
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<SignupResponseModel> signup({
    required TermsInfoModel terms,
    required String nickname,
    required int level,
    required List<String> interests,
    String? referralCode,
  }) async {
    try {
      final request = SignupRequestDto(
        termsOfServiceAgreed: terms.termsOfService,
        privacyPolicyAgreed: terms.privacyPolicy,
        pushAgreed: terms.push,
        marketingAgreed: terms.marketing,
        nickname: nickname,
        level: level,
        interests: interests,
        referralCode: referralCode,
      );
      final response = await _dio.post(
        ApiConstants.signupPath,
        data: request.toJson(),
      );
      return SignupResponseDto.fromJson(
        response.data as Map<String, dynamic>,
      ).toModel();
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException();
      }

      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final code = data['code'] as String? ?? '';
        final message = data['message'] as String? ?? '서버 오류가 발생했습니다.';
        throw mapSignupErrorCode(code, message);
      }

      throw const UnknownException();
    } catch (e, st) {
      Error.throwWithStackTrace(
        UnknownException('예상치 못한 오류가 발생했습니다. (${e.runtimeType})'),
        st,
      );
    }
  }
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(ref.watch(dioClientProvider));
}
