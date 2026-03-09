import '../../../core/constants/app_images.dart';

class OnboardingPageData {
  const OnboardingPageData({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  final String imagePath;
  final String title;
  final String description;
}

const onboardingPages = <OnboardingPageData>[
  OnboardingPageData(
    imagePath: AppImages.onboarding1,
    title: 'Learn Korean for fun',
    description: 'with the videos you love,\nnot boring textbooks',
  ),
  OnboardingPageData(
    imagePath: AppImages.onboarding2,
    title: 'No setup required',
    description: 'Just paste a YouTube link\nand start learning',
  ),
  OnboardingPageData(
    imagePath: AppImages.onboarding3,
    title: 'Beyond translation',
    description: 'Understand the real nuance\nbehind words',
  ),
];

/// 온보딩 화면 상수.
abstract final class OnboardingConstants {
  // ── Spacing ───────────────────────────────────────
  static const double imageBoxHeight = 320.0;
  static const double spacingImageToIndicator = 32.0;
  static const double spacingIndicatorToText = 18.0;

  // ── Animation ─────────────────────────────────────
  static const pageAnimationDuration = Duration(milliseconds: 300);
}
