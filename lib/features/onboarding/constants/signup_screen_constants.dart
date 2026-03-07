/// 회원가입 화면 상수.
abstract final class SignupScreenConstants {
  SignupScreenConstants._();

  // ── Spacing ───────────────────────────────────────
  static const double headerToStepperGap = 43.0;
  static const double stepperToContentGap = 26.0;
  static const double titleToSubtitleGap = 10.0;
  static const double subtitleToInputGap = 40.0;
  static const double levelSubtitleToListGap = 13.0;
  static const double levelCardGap = 8.0;
  static const double interestSubtitleToListGap = 29.0;
  static const double interestChipSpacing = 10.0;
  static const double interestChipRunSpacing = 6.0;
  static const double referralOptionalToTitleGap = 26.0;

  // ── Common ────────────────────────────────────────
  static const String buttonTextContinue = 'Continue';
  static const String buttonTextFinish = 'Finish';

  // ── Step 1: Name ──────────────────────────────────
  static const String nameTitleText = 'What should\nMingo call you?';
  static const String nameSubtitleText =
      'Use up to 10 Korean or English letters.';
  static const String nameHintText = 'Enter your name';
  static const int nameMaxLength = 10;
  static final RegExp nameValidChars = RegExp(r'^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z]+$');
  static final RegExp nameSpecialChars =
      RegExp(r'''[!@#$%^&*(),.?":{}|<>~`\-_=+\[\]\\/;'0-9]''');
  static const String nameErrorSpecialChars =
      'Special characters and numbers are not allowed.';
  static const String nameErrorInvalidInput =
      'Only Korean and English letters are allowed.';

  // ── Step 2: Level ─────────────────────────────────
  static const String levelTitleText = "What's your Korean level?";
  static const String levelSubtitleText =
      'Start learning with a course that fits your level.';

  /// 레벨 선택지 UI 문구 목록
  static const List<({String title, String subtitle})> levelOptions = [
    (
      title: 'Lv 1 · Beginner',
      subtitle: 'I can read Hangul and use basic phrases. (TOPIK 1 / CEFR A1)',
    ),
    (
      title: 'Lv 2 · Elementary',
      subtitle:
          'I can handle simple everyday conversations. (TOPIK 2 / CEFR A2)',
    ),
    (
      title: 'Lv 3 · Intermediate',
      subtitle:
          'I can express my thoughts in full sentences. (TOPIK 3 / CEFR B1)',
    ),
    (
      title: 'Lv 4 · Upper-Intermediate',
      subtitle:
          'I can have natural conversations on most of the topics. (TOPIK 4 / CEFR B2)',
    ),
    (
      title: 'Lv 5 · Advanced',
      subtitle:
          'I can communicate confidently in professional or academic settings. (TOPIK 5–6 / CEFR C1)',
    ),
  ];

  // ── Step 3: Interest ──────────────────────────────
  static const String interestTitleText = 'What areas are you\ninterested in?';
  static const String interestSubtitleText =
      'We recommend content tailored to your chosen field.\n(Multiple selections allowed)';

  /// 관심 분야 선택지 UI 문구 목록
  static const List<String> interestOptions = [
    'K-pop',
    'K-Drama & Movies',
    'Daily Life',
    'Travel',
    'Business',
    'Beauty & Fashion',
    'K-Food',
    'Gaming',
    'Webtoon',
    'Trends & Slang',
  ];

  /// 관심 분야 API 코드 목록
  static const List<String> interestCodes = [
    'K_POP',
    'K_DRAMA_MOVIES',
    'DAILY_LIFE',
    'TRAVEL',
    'BUSINESS',
    'BEAUTY_FASHION',
    'K_FOOD',
    'GAMING',
    'WEBTOON',
    'TRENDS_SLANG',
  ];

  // ── Step 4: Referral ──────────────────────────────
  static const String referralOptionalText = '[Optional]';
  static const String referralTitleText =
      'Do you have a referral code?\nEnter it below';
  static const String referralSubtitleText =
      'Instant check. If valid, you\'ll get +40 minutes';
  static const String referralHintText = '8 characters';
  static const String referralSuccessText = 'code applied!';
  static const String referralErrorText = 'Invalid code!';
  static const int referralMaxLength = 8;

  // TODO: (임시) 테스트용 추천인 코드
  static const String tempValidReferralCode = 'AAAAAAAA';
}
