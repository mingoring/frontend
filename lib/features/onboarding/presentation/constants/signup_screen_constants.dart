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

  // ── Step 2: (TBD) ─────────────────────────────────

  // ── Step 3: (TBD) ─────────────────────────────────

  // ── Step 4: (TBD) ─────────────────────────────────
}
