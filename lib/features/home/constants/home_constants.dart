abstract final class HomeConstants {
  static const String goToLessonSubtitle = "Today’s trending video";

  // TODO: Mock 데이터 (실제 API 연동 전)
  static const int mockBookmarkCount = 15;
  static const String mockVideoTitle =
      "BLACKPINK ROSÉ's Honest Puzzle Interview 🧩";
  static const String mockVideoTime = '15:34';
  static const String mockThumbnailUrl =
      'https://i.ytimg.com/vi/EFSHytNS3QM/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLDFkCtFZKtUQTaUdWAFpsz-FFmlag';

  // TODO: Mock 데이터 (실제 API 연동 전) - 학습 완료 날짜 목록
  static final List<DateTime> mockStudiedDates = [
    DateTime(2026, 3, 4),
    DateTime(2026, 3, 5),
    DateTime(2026, 3, 6),
    DateTime(2026, 3, 7),
    DateTime(2026, 3, 9),
  ];

  // TODO: Mock 데이터 (실제 API 연동 전) - 학습 텍스트
  static const String mockLearningTextKo = '오늘의 핵심 표현을 영상으로 배워보세요';
  static const String mockLearningTextEn =
      "Let's learn today's key expressions through video";
}
