import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_response_model.freezed.dart';

/// 회원가입 성공 응답 앱 내부 모델.
@freezed
class SignupResponseModel with _$SignupResponseModel {
  const factory SignupResponseModel({
    required int userId,
    required String accessToken,
    required String refreshToken,
    required String referralCodeStatus,
  }) = _SignupResponseModel;
}
