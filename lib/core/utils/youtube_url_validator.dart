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
/// YoutubeUrlValidator.normalizeUrl(
///   'https://youtu.be/wlEIQVYyn3o?si=bNEN15ioCq9LxHLy&t=30',
/// ); // https://youtu.be/wlEIQVYyn3o 추출
///
/// YoutubeUrlValidator.normalizeUrl(
///   'https://www.youtube.com/watch?v=wlEIQVYyn3o&feature=shared&pp=ygUM7J207YOc7JuQ&t=30',
/// ); // https://www.youtube.com/watch?v=wlEIQVYyn3o 추출
/// 
/// YoutubeUrlValidator.isValid(
///   'https://youtu.be/wlEIQVYyn3o?si=bNEN15ioCq9LxHLy&t=30',
/// ); // true 반환
/// ```
abstract final class YoutubeUrlValidator {
  static const Set<String> _removableQueryParameters = {
    'si',
    't',
    'feature',
    'pp',
  };

  /// URL에서 YouTube 불필요한 쿼리 파라미터를 제거합니다.
  ///
  /// 제거 대상:
  /// - si
  /// - t
  /// - feature
  /// - pp
  ///
  /// 파싱이 불가능하면 원본 문자열을 그대로 반환합니다.
  static String normalizeUrl(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return trimmed;

    final uri = Uri.tryParse(trimmed);
    if (uri == null) return trimmed;

    final updatedQueryParameters = Map<String, String>.from(uri.queryParameters)
      ..removeWhere((key, _) => _removableQueryParameters.contains(key));

    final normalizedUri = uri.replace(
      queryParameters:
          updatedQueryParameters.isEmpty ? null : updatedQueryParameters,
    );

    return normalizedUri.toString();
  }

  static bool isValid(String url) {
    final normalized = normalizeUrl(url);
    if (normalized.isEmpty) return false;

    final uri = Uri.tryParse(normalized);
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
