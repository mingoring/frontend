import 'package:freezed_annotation/freezed_annotation.dart';

part 'consent_info.freezed.dart';

/// 약관 항목 하나의 동의 상태.
@freezed
class ConsentInfo with _$ConsentInfo {
  const factory ConsentInfo({
    required bool agreed,
  }) = _ConsentInfo;
}
