import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/network/dio_client.dart';
import '../dto/referral_verify_response_dto.dart';

part 'referral_repository.g.dart';

// 추천인 저장소 추상 인터페이스
abstract interface class ReferralRepository {
  Future<bool> verifyReferralCode(String referralCode);
}

// 추천인 저장소 구현체
class ReferralRepositoryImpl implements ReferralRepository {
  const ReferralRepositoryImpl(this._dio);

  final Dio _dio;

  @override
  Future<bool> verifyReferralCode(String referralCode) async {
    try {
      final response = await _dio.get(
        ApiConstants.referralVerifyPath,
        queryParameters: {'referralCode': referralCode},
      );
      final dto = ReferralVerifyResponseDto.fromJson(
        response.data as Map<String, dynamic>,
      );
      return dto.result == 'VALID';
    } on AppException {
      rethrow;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException();
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
ReferralRepository referralRepository(Ref ref) {
  return ReferralRepositoryImpl(ref.watch(dioClientProvider));
}
