import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_request_dto.freezed.dart';
part 'signup_request_dto.g.dart';

// 회원가입 API 요청 Body DTO
// POST /api/v1/auth/signup
@freezed
class SignupRequestDto with _$SignupRequestDto {
  const factory SignupRequestDto({
    required bool termsOfServiceAgreed,
    required bool privacyPolicyAgreed,
    required bool pushAgreed,
    required bool marketingAgreed,
    required String nickname,
    required int level,
    required List<String> interests,
    String? referralCode,
  }) = _SignupRequestDto;

  factory SignupRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SignupRequestDtoFromJson(json);
}
