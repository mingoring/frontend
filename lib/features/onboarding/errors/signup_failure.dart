import '../../../core/errors/app_exception.dart';

/// 회원가입에서 발생할 수 있는 UI 실패 분류
sealed class SignupFailure extends FeatureException {
  const SignupFailure(super.message);
}

// 필수 약관에 동의하지 않은 경우
final class ConsentRequiredFailure extends SignupFailure {
  const ConsentRequiredFailure()
      : super('You must agree to the required terms to continue.');
}

// 필수 필드 중 하나라도 누락된 경우
final class InvalidRequestFailure extends SignupFailure {
  const InvalidRequestFailure()
      : super('Some required information is missing.');
}

// 이름 정책 위반
final class InvalidNameFailure extends SignupFailure {
  const InvalidNameFailure()
      : super('Your name is invalid. Please enter only allowed characters.');
}
