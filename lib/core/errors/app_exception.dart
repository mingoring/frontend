/// 앱 공통 에러 타입 계층
sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

// 네트워크 연결 오류 (타임아웃, 연결 끊김 등)
final class NetworkException extends AppException {
  const NetworkException(
      [super.message = 'Check your internet connection and try again.']);
}

// 백엔드 서버가 반환한 에러
final class ServerException extends AppException {
  const ServerException(
      [super.message = 'A server error occurred. Please try again later.']);
}

// 분류되지 않은 예상치 못한 에러
final class UnknownException extends AppException {
  const UnknownException(
      [super.message = 'Something went wrong. Please try again.']);
}

// 특정 API 전용 에러의 추상 기반 (각 Feature 레이어에서 이 클래스를 상속해 구체 에러 타입을 정의한다.)
abstract class FeatureException extends AppException {
  const FeatureException(super.message);
}
