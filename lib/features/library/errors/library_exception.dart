import '../../../core/errors/app_exception.dart';

/// 스크린에 메시지 보여주는 LibraryException 래퍼
sealed class LibraryException extends FeatureException {
  const LibraryException(super.message);
}

/// 영상 추가 정책 위반 - YouTube Shorts 미지원
final class ShortsNotSupportedException extends LibraryException {
  const ShortsNotSupportedException()
      : super('YouTube Shorts are not supported.');
}

/// 영상 추가 정책 위반 - 영상을 찾을 수 없음 / 삭제됨
final class VideoNotFoundException extends LibraryException {
  const VideoNotFoundException()
      : super('The video was not found or has been deleted.');
}

/// 영상 추가 정책 위반 - 비공개 / 접근 불가
final class VideoPrivateException extends LibraryException {
  const VideoPrivateException()
      : super('This video is private or unavailable.');
}

/// 영상 추가 정책 위반 - 지역 제한
final class RegionRestrictedException extends LibraryException {
  const RegionRestrictedException()
      : super('This video is not available in your region.');
}

/// 영상 추가 정책 위반 - 지원하지 않는 언어
final class LanguageNotSupportedException extends LibraryException {
  const LanguageNotSupportedException()
      : super('Only Korean YouTube videos are supported.');
}

/// 영상 추가 정책 위반 - 잘못된 URL 형식
final class InvalidUrlException extends LibraryException {
  const InvalidUrlException()
      : super('Invalid URL format.');
}

/// 영상 추가 정책 위반 - YouTube 링크 아님
final class NotYouTubeException extends LibraryException {
  const NotYouTubeException()
      : super('Only YouTube links are supported.');
}

/// 크레딧 부족
final class InsufficientCreditException extends LibraryException {
  const InsufficientCreditException()
      : super("You don't have enough credits to add a video.");
}

/// 이미 존재하는 레슨
final class LessonAlreadyExistsException extends LibraryException {
  const LessonAlreadyExistsException()
      : super('This video is already in your library.');
}
