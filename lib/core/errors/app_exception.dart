/// 앱 공통 에러 타입 정의
sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

// 네트워크 연결 오류 (타임아웃, 연결 끊김 등)
final class NetworkException extends AppException {
  const NetworkException(
      [super.message = 'There is a problem with the internet connection.']);
}

// 백엔드 서버 에러
final class ServerException extends AppException {
  const ServerException(
      [super.message = 'A server error occurred. Please try again later.']);
}

// 분류되지 않은 예상치 못한 에러
final class UnknownException extends AppException {
  const UnknownException(
      [super.message = 'Something went wrong. Please try again later.']);
}

// 특정 Feature 전용 에러 (필요시 특정 Feature 레이어에서 이 클래스를 상속해 구체 에러 타입을 정의해 사용)
abstract class FeatureException extends AppException {
  const FeatureException(super.message);
}

// 400 - 입력 검증 실패
final class InvalidFormatException extends AppException {
  InvalidFormatException({String? fieldName, String? message})
      : super(_buildMessage(fieldName: fieldName, message: message));

  static String _buildMessage({String? fieldName, String? message}) {
    // 1. message가 있으면, message 사용
    if (message != null) return message;

    // 2. message가 없고 fieldName이 있으면, 템플릿 문구 사용
    if (fieldName != null) return 'Please check the $fieldName.';

    // 3. 둘 다 없으면, 기본 문구 사용
    return 'Please check your inputs.';
  }
}

// 401 - 인증 실패
final class UnauthorizedException extends AppException {
  const UnauthorizedException(
      [super.message =
          "We couldn't verify your identity. Please sign in again."]);
}

// 403 - 권한 없음
final class ForbiddenException extends AppException {
  const ForbiddenException(
      [super.message = "You don't have permission to access this."]);
}

// 404 - 리소스 없음
final class NotFoundException extends AppException {
  const NotFoundException(
      [super.message = "We couldn't find what you were looking for."]);
}
