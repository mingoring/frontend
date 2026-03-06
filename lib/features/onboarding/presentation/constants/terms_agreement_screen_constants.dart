/// 약관 항목 데이터 (제목, 필수 여부, 링크 URL)
class TermsItem {
  const TermsItem({
    required this.title,
    required this.isRequired,
    this.url,
  });

  final String title;
  final bool isRequired;
  final String? url; // null이면 View Full 버튼 없음
}

/// 약관동의 화면 전용 상수
abstract final class TermsAgreementScreenConstants {
  TermsAgreementScreenConstants._();

  // ─── Layout ─────────────────────────────────────────────────────────────

  static const double contentWidth = 330.0;
  static const double titleCardGap = 20.0;
  static const double cardListGap = 7.0;

  /// 헤더와 화면 제목 사이의 세로 간격.
  static const double headerToTitleGap = 32.0;

  /// 화면 제목과 체크박스 카드 영역 사이의 세로 간격.
  static const double titleToCardAreaGap = 32.0;

  // ─── URLs ───────────────────────────────────────────────────────────────

  static const String termsOfServiceUrl =
      'https://mingoring.com/terms-of-service.html';
  static const String privacyPolicyUrl =
      'https://mingoring.com/privacy-policy.html';
  static const String marketingUrl =
      'https://mingoring.com/marketing-consent.html';

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

  // ─── Items ──────────────────────────────────────────────────────────────

  static const List<TermsItem> items = [
    TermsItem(
      title: termsOfServiceTitle,
      isRequired: true,
      url: termsOfServiceUrl,
    ),
    TermsItem(
      title: privacyPolicyTitle,
      isRequired: true,
      url: privacyPolicyUrl,
    ),
    TermsItem(
      title: pushNotificationsTitle,
      isRequired: false,
    ),
    TermsItem(
      title: marketingTitle,
      isRequired: false,
      url: marketingUrl,
    ),
  ];
}
