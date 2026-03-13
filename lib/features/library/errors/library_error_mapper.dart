import '../../../core/errors/app_exception.dart';
import '../../../core/errors/error_mapper.dart';
import 'library_exception.dart';

/// 백엔드 서버 에러 -> [AppException] 변환
/// library 전용 코드는 여기서 우선 처리하고, 나머지는 [mapCommonError]에 위임한다.
AppException mapLibraryError(int statusCode, Map<String, dynamic>? body) {
  final rawErrorCode = body?['code'];
  final errorCode = rawErrorCode is String ? rawErrorCode : null;

  if (statusCode == 400 && errorCode == 'INVALID_REQUEST') {
    return InvalidFormatException();
  }

  if (statusCode == 400 && errorCode == 'SHORTS_NOT_SUPPORTED') {
    return const ShortsNotSupportedException();
  }

  if (statusCode == 400 && errorCode == 'VIDEO_NOT_FOUND') {
    return const VideoNotFoundException();
  }

  if (statusCode == 400 && errorCode == 'VIDEO_PRIVATE') {
    return const VideoPrivateException();
  }

  if (statusCode == 400 && errorCode == 'REGION_RESTRICTED') {
    return const RegionRestrictedException();
  }

  if (statusCode == 400 && errorCode == 'LANGUAGE_NOT_SUPPORTED') {
    return const LanguageNotSupportedException();
  }

  if (statusCode == 400 && errorCode == 'INVALID_URL') {
    return const InvalidUrlException();
  }

  if (statusCode == 400 && errorCode == 'NOT_YOUTUBE') {
    return const NotYouTubeException();
  }

  if (statusCode == 402 && errorCode == 'INSUFFICIENT_CREDIT') {
    return const InsufficientCreditException();
  }

  if (statusCode == 409 && errorCode == 'LESSON_ALREADY_EXISTS') {
    return const LessonAlreadyExistsException();
  }

  return mapCommonError(statusCode, body);
}
