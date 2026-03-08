import 'package:freezed_annotation/freezed_annotation.dart';

part 'referral_verify_response_dto.freezed.dart';
part 'referral_verify_response_dto.g.dart';

// 추천인 코드 검증 API 응답 DTO
// GET /api/v1/credits/rewards/referral/verify
// result == 'VALID' 일 때만 사용 가능한 코드
@freezed
class ReferralVerifyResponseDto with _$ReferralVerifyResponseDto {
  const factory ReferralVerifyResponseDto({
    required String result,
  }) = _ReferralVerifyResponseDto;

  factory ReferralVerifyResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ReferralVerifyResponseDtoFromJson(json);
}
