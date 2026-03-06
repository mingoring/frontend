import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';

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

abstract final class OnboardingConstants {
  static const pageAnimationDuration = Duration(milliseconds: 300);
  static const imageBoxHeight = 320.0;
  static const spacingImageToIndicator = 32.0;
  static const spacingIndicatorToText = 18.0;

  static const backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.pink200, AppColors.white],
  );
}
