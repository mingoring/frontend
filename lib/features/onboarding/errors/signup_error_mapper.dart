import '../../../core/errors/app_exception.dart';
import 'signup_failure.dart';

/// 서버 에러 코드 → [SignupFailure] 변환.
/// 매핑 대상이 없는 코드는 [ServerException]으로 폴백한다.
AppException mapSignupErrorCode(String code, String serverMessage) {
  return switch (code) {
    'CONSENT_REQUIRED' => const ConsentRequiredFailure(),
    'INVALID_REQUEST' => const InvalidRequestFailure(),
    'INVALID_NICKNAME' => const InvalidNameFailure(),
    'INVALID_LEVEL' => const InvalidLevelFailure(),
    'INVALID_INTERESTS' => const InvalidInterestsFailure(),
    _ => ServerException(serverMessage),
  };
}
