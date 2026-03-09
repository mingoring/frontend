import '../../../core/errors/app_exception.dart';
import '../../../core/errors/error_mapper.dart';

/// 백엔드 서버 에러 → [AppException] 변환
/// signup 전용 코드만 처리하고, 나머지는 [mapCommonError]에 위임한다.
AppException mapSignupError(int statusCode, Map<String, dynamic>? body) {
  final errorCode = body?['code'] as String?;

  // 회원가입 전용 처리
  if (statusCode >= 400 && statusCode < 500) {
    if (errorCode == 'CONSENT_REQUIRED') {
      return InvalidFormatException(fieldName: 'terms');
    }
    if (errorCode == 'INVALID_NICKNAME') {
      return InvalidFormatException(fieldName: 'nickname');
    }
    if (errorCode == 'INVALID_INTERESTS') {
      return InvalidFormatException(fieldName: 'interests');
    }
    if (errorCode == 'INVALID_LEVEL') {
      return InvalidFormatException(fieldName: 'level');
    }
  }

  // 공통 처리 위임
  return mapCommonError(statusCode, body);
}
