import '../../../core/errors/app_exception.dart';
import '../../../core/errors/error_mapper.dart';

/// 백엔드 서버 에러 -> [AppException] 변환
/// bookmark 전용 코드가 생기면 여기서 우선 처리하고, 나머지는 [mapCommonError]에 위임한다.
AppException mapBookmarkError(int statusCode, Map<String, dynamic>? body) {
  return mapCommonError(statusCode, body);
}
