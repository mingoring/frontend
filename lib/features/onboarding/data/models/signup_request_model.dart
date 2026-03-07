import 'package:freezed_annotation/freezed_annotation.dart';

import 'consent_info_model.dart';

part 'signup_request_model.freezed.dart';
part 'signup_request_model.g.dart';

/// 회원가입 API 요청 Body DTO.
/// POST /api/v1/auth/signup
@freezed
class SignupRequestModel with _$SignupRequestModel {
  const factory SignupRequestModel({
    required ConsentInfoModel termsOfService,
    required ConsentInfoModel privacyPolicy,
    required ConsentInfoModel push,
    required ConsentInfoModel marketing,
    required String nickname,
    required int level,
    required List<String> interests,
  }) = _SignupRequestModel;

  factory SignupRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SignupRequestModelFromJson(json);
}
