/// 약관동의 화면 전용 상수
abstract final class TermsAgreementScreenConstants {
  TermsAgreementScreenConstants._();

  // ─── Layout ─────────────────────────────────────────────────────────────

  static const double contentWidth = 330.0;
  static const double titleCardGap = 20.0;
  static const double cardListGap = 7.0;

  /// 화면 제목과 체크박스 카드 영역 사이의 세로 간격.
  static const double titleToCardAreaGap = 32.0;

  // ─── Copy ───────────────────────────────────────────────────────────────

  static const String titleText = 'Review and accept\nthe terms to continue...';
  static const String buttonTextContinue = 'Continue';

  static const String acceptAllTitle = 'Accept all';
  static const String acceptAllSubtitle =
      'Includes required and optional items';
  static const String termsOfServiceTitle = 'I agree to the Terms of Service';
  static const String privacyPolicyTitle = 'I agree to the Privacy Policy';
  static const String pushNotificationsTitle =
      'I agree to receive\npush notifications';
  static const String marketingTitle =
      'I agree to receive\nmarketing updates and promotions';
}
