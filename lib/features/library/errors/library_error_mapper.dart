import '../../../core/errors/app_exception.dart';
import '../../../core/errors/error_mapper.dart';

/// 백엔드 서버 에러 -> [AppException] 변환
/// library 전용 코드가 생기면 여기서 우선 처리하고, 나머지는 [mapCommonError]에 위임한다.
AppException mapLibraryError(int statusCode, Map<String, dynamic>? body) {
  final errorCode = body?['code'] as String?;

  if (statusCode == 400 && errorCode == 'INVALID_REQUEST') {
    return InvalidFormatException();
  }
  if (statusCode == 404 && errorCode == 'LESSON_NOT_FOUND') {
    return const NotFoundException();
  }

  return mapCommonError(statusCode, body);
}
