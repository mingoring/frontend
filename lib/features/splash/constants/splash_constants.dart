abstract final class SplashConstants {
  // Duration 애니메이션 지속 시간, 대기 시간, 화면 전환 시간
  static const animationDuration = Duration(milliseconds: 1400);
  static const holdDuration = Duration(milliseconds: 400);
  static const transitionDuration = Duration(milliseconds: 500);

  // 화면 높이 대비 로고 상단 이동 비율 (0.04 = 4%)
  static const logoVerticalOffsetRatio = 0.04;

  // 애니메이션 시작 시간, 종료 시간
  static const mingoStart = 0.0;
  static const mingoEnd = 0.35;
  static const ringStart = 0.20;
  static const ringEnd = 0.75;
  static const dotStart = 0.65;
  static const dotEnd = 1.0;

  // Logo text segments
  static const textMingo = 'mingo';
  static const textRing = 'ring';
  static const textDot = ' .';
}
