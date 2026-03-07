import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/consent_info.dart';

part 'consent_info_model.freezed.dart';
part 'consent_info_model.g.dart';

/// 약관 동의 항목 DTO (API 요청용).
@freezed
class ConsentInfoModel with _$ConsentInfoModel {
  const factory ConsentInfoModel({
    required bool agreed,
  }) = _ConsentInfoModel;

  factory ConsentInfoModel.fromJson(Map<String, dynamic> json) =>
      _$ConsentInfoModelFromJson(json);

  factory ConsentInfoModel.fromDomain(ConsentInfo entity) => ConsentInfoModel(
        agreed: entity.agreed,
      );
}
