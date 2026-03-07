import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_logo_typography.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/indicators/mingoring_progress_stepper.dart';
import '../constants/onboarding_constants.dart';

class OnboardingCenterContent extends StatelessWidget {
  const OnboardingCenterContent({
    super.key,
    required this.pages,
    required this.currentIndex,
    required this.pageController,
    required this.onPageChanged,
  });

  final List<OnboardingPageData> pages;
  final int currentIndex;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;

  static const _horizontalPadding = 24.0;
  static const _spacingTitleToDescription = 14.0;

  @override
  Widget build(BuildContext context) {
    final page = pages[currentIndex];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: OnboardingConstants.imageBoxHeight,
          child: PageView.builder(
            controller: pageController,
            itemCount: pages.length,
            onPageChanged: onPageChanged,
            itemBuilder: (_, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SvgPicture.asset(
                  pages[index].imagePath,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: OnboardingConstants.spacingImageToIndicator),
        MingoringProgressStepper.small(currentIndex: currentIndex),
        const SizedBox(height: OnboardingConstants.spacingIndicatorToText),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                page.title,
                style: AppLogoTypography.logoEb4.copyWith(color: AppColors.pink600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: _spacingTitleToDescription),
              Text(
                page.description,
                style: AppTextStyles.body2Sb16.copyWith(
                  color: AppColors.gray600,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
