import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/signup_response_model.dart';

part 'signup_response_dto.freezed.dart';
part 'signup_response_dto.g.dart';

// 회원가입 API 응답 Body DTO
// POST /api/v1/auth/signup (성공 201)
@freezed
class SignupResponseDto with _$SignupResponseDto {
  const factory SignupResponseDto({
    required int userId,
    required String accessToken,
    required String refreshToken,
    required String referralCodeStatus,
  }) = _SignupResponseDto;

  factory SignupResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SignupResponseDtoFromJson(json);
}

extension SignupResponseDtoX on SignupResponseDto {
  SignupResponseModel toModel() => SignupResponseModel(
        userId: userId,
        accessToken: accessToken,
        refreshToken: refreshToken,
        referralCodeStatus: referralCodeStatus,
      );
}
