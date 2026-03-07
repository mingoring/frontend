import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_response.freezed.dart';

/// 회원가입 성공 응답 엔티티.
@freezed
class SignupResponse with _$SignupResponse {
  const factory SignupResponse({
    required int userId,
    required String accessToken,
    required String refreshToken,
    /// UTC 기준 약관 동의 처리 시각 (ISO 8601).
    required String agreedAt,
  }) = _SignupResponse;
}
