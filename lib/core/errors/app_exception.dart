/// 앱 공통 에러 타입 계층.
/// Data 계층에서 Dio/파싱 에러를 이 타입으로 매핑하고, ViewModel에서 처리한다.
sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// 네트워크 연결 오류 (타임아웃, 연결 끊김 등).
final class NetworkException extends AppException {
  const NetworkException([super.message = '네트워크 연결을 확인해주세요.']);
}

/// 서버가 반환한 비즈니스 에러 (4xx / 5xx).
final class ServerException extends AppException {
  const ServerException({required this.code, required String message})
      : super(message);
  final String code;
}

/// 분류되지 않은 예상치 못한 에러.
final class UnknownException extends AppException {
  const UnknownException([super.message = '알 수 없는 오류가 발생했습니다.']);
}
