/// 약관 항목 데이터
class TermsItem {
  const TermsItem({
    required this.title,
    required this.isRequired,
    this.url,
  });

  final String title; // 제목
  final bool isRequired; // 필수 여부
  final String? url; // 링크 URL (null이면 View Full 버튼 없음)
}

/// 약관동의 화면 상수
abstract final class TermsAgreementScreenConstants {
  TermsAgreementScreenConstants._();

  // ── Spacing ───────────────────────────────────────
  static const double headerToTitleGap = 32.0;
  static const double titleToCardAreaGap = 32.0;
  static const double titleCardGap = 20.0;
  static const double cardListGap = 7.0;

  // ── URLs ──────────────────────────────────────────
  static const String termsOfServiceUrl =
      'https://mingoring.com/terms-of-service.html';
  static const String privacyPolicyUrl =
      'https://mingoring.com/privacy-policy.html';
  static const String marketingUrl =
      'https://mingoring.com/marketing-consent.html';

  // ── Copy ──────────────────────────────────────────
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

  // ── Term Agreement Indexes ────────────────────────
  static const int termsOfServiceIndex = 0;
  static const int privacyPolicyIndex = 1;
  static const int pushIndex = 2;
  static const int marketingIndex = 3;

  // ── Items ─────────────────────────────────────────
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
