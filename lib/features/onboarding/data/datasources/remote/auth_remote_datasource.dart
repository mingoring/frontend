import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/signup_request_model.dart';
import '../../../data/models/signup_response_model.dart';

part 'auth_remote_datasource.g.dart';

/// 인증 관련 원격 API 호출 추상 인터페이스.
abstract interface class AuthRemoteDataSource {
  /// POST /api/v1/auth/signup
  Future<SignupResponseModel> signup(SignupRequestModel request);
}

/// [AuthRemoteDataSource] 구현체.
// TODO(server): Dio 클라이언트 주입 후 아래 signup()을 실제 API 호출로 교체.
//   - POST /api/v1/auth/signup
//   - request.toJson()을 body로 전송
//   - 201 응답 → SignupResponseModel.fromJson(response.data)
//   - 400/500 응답 → ServerException / NetworkException 으로 매핑
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl();

  @override
  Future<SignupResponseModel> signup(SignupRequestModel request) async {
    // TODO(server): 아래 mock 반환을 제거하고 Dio 호출로 교체.
    return const SignupResponseModel(
      userId: 0,
      accessToken: '',
      refreshToken: '',
      agreedAt: '',
    );
  }
}

@riverpod
AuthRemoteDataSource authRemoteDataSource(Ref ref) {
  return const AuthRemoteDataSourceImpl();
}
