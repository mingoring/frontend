/// 회원가입 화면 상수.
/// 단계별로 그룹화: Step1(Name) → Step2 → Step3 → Step4.
abstract final class SignupScreenConstants {
  SignupScreenConstants._();

  // ── Common ─────────────────────────────────────────
  static const String buttonTextContinue = 'Continue';
  static const double headerToStepperGap = 43.0;
  static const double stepperToContentGap = 26.0;

  // ── Step 1: Name ───────────────────────────────────
  static const String nameTitleText = 'What should\nMingo call you?';
  static const String nameSubtitleText =
      'Use up to 15 English letters or numbers.';
  static const String nameHintText = 'Enter your name';
  static const int nameMaxLength = 10;
  static final RegExp nameValidChars = RegExp(r'^[가-힣a-zA-Z0-9]+$');
  static final RegExp nameSpecialChars =
      RegExp(r'''[!@#$%^&*(),.?":{}|<>~`\-_=+\[\]\\/;']''');
  static const String nameErrorSpecialChars =
      'Special characters are not allowed.';
  static const String nameErrorInvalidInput =
      'Only Korean, English, and numbers are allowed.';
  static const double nameTitleToSubtitleGap = 10.0;
  static const double nameSubtitleToInputGap = 40.0;

  // ── Step 2: Level ──────────────────────────────────
  static const String levelTitleText = "What's your Korean level?";
  static const String levelSubtitleText =
      'Start learning with a course that fits your level.';
  static const double levelTitleToSubtitleGap = 10.0;
  static const double levelSubtitleToListGap = 13.0;
  static const double levelCardGap = 8.0;

  /// 레벨 선택지 목록. 각 항목은 {title, subtitle}.
  static const List<({String title, String subtitle})> levelOptions = [
    (
      title: 'Lv 1 · Beginner',
      subtitle:
          'I can read Hangul and use basic phrases. (TOPIK 1 / CEFR A1)',
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
  static const double interestTitleToSubtitleGap = 10.0;
  static const double interestSubtitleToListGap = 29.0;
  static const double interestChipSpacing = 10.0; // horizontal gap
  static const double interestChipRunSpacing = 6.0; // vertical gap

  /// 관심 분야 선택지 목록
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

  // ── Step 4: (TBD) ─────────────────────────────────
}
