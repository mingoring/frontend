/// 앱 공통 에러 타입 계층
sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

// 네트워크 연결 오류 (타임아웃, 연결 끊김 등)
final class NetworkException extends AppException {
  const NetworkException([super.message = '네트워크 연결을 확인해주세요.']);
}

// 백엔드 서버가 반환한 에러
final class ServerException extends AppException {
  const ServerException({required this.code, required String message})
      : super(message);
  final String code;
}

// 분류되지 않은 예상치 못한 에러
final class UnknownException extends AppException {
  const UnknownException([super.message = '알 수 없는 오류가 발생했습니다.']);
}

// 특정 API 전용 에러의 추상 기반 (각 Feature 레이어에서 이 클래스를 상속해 구체 에러 타입을 정의한다.)
abstract class FeatureException extends AppException {
  const FeatureException(super.message);
}
