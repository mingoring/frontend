import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/signup_response.dart';

part 'signup_response_model.freezed.dart';
part 'signup_response_model.g.dart';

/// 회원가입 API 응답 Body DTO.
/// POST /api/v1/auth/signup → 201
@freezed
class SignupResponseModel with _$SignupResponseModel {
  const factory SignupResponseModel({
    required int userId,
    required String accessToken,
    required String refreshToken,
    required String agreedAt,
  }) = _SignupResponseModel;

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SignupResponseModelFromJson(json);
}

extension SignupResponseModelX on SignupResponseModel {
  SignupResponse toDomain() => SignupResponse(
        userId: userId,
        accessToken: accessToken,
        refreshToken: refreshToken,
        agreedAt: agreedAt,
      );
}
