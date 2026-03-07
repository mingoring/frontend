import '../entities/consent_info.dart';
import '../entities/signup_response.dart';

/// 인증 관련 데이터 접근 추상 인터페이스 (Domain 계층).
/// Data 계층에서 구현한다.
abstract interface class AuthRepository {
  Future<SignupResponse> signup({
    required ConsentInfo termsOfService,
    required ConsentInfo privacyPolicy,
    required ConsentInfo push,
    required ConsentInfo marketing,
    required String nickname,
    required int level,
    required List<String> interests,
  });
}
