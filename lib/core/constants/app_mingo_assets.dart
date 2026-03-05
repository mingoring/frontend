/// 피그마 정의: mingo 캐릭터 에셋 (플라밍고)
///
/// 구조: mingo_idle / {pose} / {eyes}
///   - pose: main(한 발 서기), wings(날개 펼침)
///   - eyes: main(기본), smile(미소), tired(피곤), sad(슬픔)
abstract final class MingoAssets {
  static const String _basePath = 'assets/images/mingo';

  // ──────────────────────────────────────────
  // Idle - Main Pose (한 발 서기)
  // ──────────────────────────────────────────

  static const String idleMainMain = '$_basePath/mingo_idle_main_main.png';
  static const String idleMainSmile = '$_basePath/mingo_idle_main_smile.png';
  static const String idleMainTired = '$_basePath/mingo_idle_main_tired.png';
  static const String idleMainSad = '$_basePath/mingo_idle_main_sad.png';

  // ──────────────────────────────────────────
  // Idle - Wings Pose (날개 펼침)
  // ──────────────────────────────────────────

  static const String idleWingsMain = '$_basePath/mingo_idle_wings_main.png';
  static const String idleWingsSmile = '$_basePath/mingo_idle_wings_smile.png';
  static const String idleWingsTired = '$_basePath/mingo_idle_wings_tired.png';
  static const String idleWingsSad = '$_basePath/mingo_idle_wings_sad.png';

  // ──────────────────────────────────────────
  // Grouped Access
  // ──────────────────────────────────────────

  static const List<String> idleMainAll = [
    idleMainMain,
    idleMainSmile,
    idleMainTired,
    idleMainSad,
  ];

  static const List<String> idleWingsAll = [
    idleWingsMain,
    idleWingsSmile,
    idleWingsTired,
    idleWingsSad,
  ];

  static const List<String> all = [
    ...idleMainAll,
    ...idleWingsAll,
  ];
}
