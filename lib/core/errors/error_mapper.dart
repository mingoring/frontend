import 'app_exception.dart';

/// 백엔드 서버 에러 → [AppException] 변환
/// 모든 feature의 repository에서 공통으로 사용한다
AppException mapCommonError(int statusCode, Map<String, dynamic>? body) {
  final errorCode = body?['code'] as String?;
  //final serverMessage = body?['message'] as String?;

  // 서버 에러 (5xx)
  if (statusCode >= 500) {
    return ServerException();
  }

  // 클라이언트 에러 (4xx)
  if (statusCode == 400 && errorCode == 'INVALID_FORMAT') {
    return InvalidFormatException();
  }
  if (statusCode == 401) {
    return UnauthorizedException();
  }
  if (statusCode == 403) {
    return ForbiddenException();
  }
  if (statusCode == 404) {
    return NotFoundException();
  }

  // 그 외 에러
  return UnknownException();
}
