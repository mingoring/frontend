import '../entities/consent_info.dart';
import '../entities/signup_response.dart';
import '../repositories/auth_repository.dart';

/// 회원가입 유스케이스.
/// Domain 계층에만 의존 — AuthRepository 인터페이스를 통해 데이터를 요청한다.
class SignupUseCase {
  const SignupUseCase(this._repository);

  final AuthRepository _repository;

  Future<SignupResponse> call({
    required ConsentInfo termsOfService,
    required ConsentInfo privacyPolicy,
    required ConsentInfo push,
    required ConsentInfo marketing,
    required String nickname,
    required int level,
    required List<String> interests,
  }) {
    return _repository.signup(
      termsOfService: termsOfService,
      privacyPolicy: privacyPolicy,
      push: push,
      marketing: marketing,
      nickname: nickname,
      level: level,
      interests: interests,
    );
  }
}
