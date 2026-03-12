/// YouTube 표준 URL 유효성 검사기
///
/// 지원 형식:
/// - https://www.youtube.com/watch?v=VIDEO_ID
/// - https://youtube.com/watch?v=VIDEO_ID
/// - https://youtu.be/VIDEO_ID
///
/// 미지원 형식 (isValid = false):
/// - YouTube Shorts (youtube.com/shorts/...)
/// - 그 외 비유튜브 URL
///
/// 사용 예시:
/// ```dart
/// YoutubeUrlValidator.isValid('https://youtu.be/dQw4w9WgXcQ'); // true
/// YoutubeUrlValidator.isValid('https://youtube.com/shorts/abc'); // false
/// YoutubeUrlValidator.isValid('https://naver.com');             // false
/// ```
abstract final class YoutubeUrlValidator {
  static bool isValid(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return false;

    final uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasScheme) return false;

    final host = uri.host.toLowerCase();

    // youtu.be/VIDEO_ID
    if (host == 'youtu.be') {
      return uri.pathSegments.isNotEmpty &&
          uri.pathSegments.first.isNotEmpty;
    }

    // youtube.com/watch?v=VIDEO_ID (www 포함, Shorts 제외)
    if (host == 'youtube.com' || host == 'www.youtube.com') {
      if (uri.pathSegments.contains('shorts')) return false;
      final videoId = uri.queryParameters['v'];
      return videoId != null && videoId.isNotEmpty;
    }

    return false;
  }
}
