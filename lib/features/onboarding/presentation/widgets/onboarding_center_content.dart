import 'package:flutter/material.dart';

import '../../../../core/widgets/indicators/mingoring_indicator.dart';
import '../constants/onboarding_constants.dart';
import 'onboarding_page_content.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: OnboardingConstants.imageBoxHeight,
          child: PageView.builder(
            controller: pageController,
            itemCount: pages.length,
            onPageChanged: onPageChanged,
            itemBuilder: (_, index) {
              final page = pages[index];
              return OnboardingPageImage(imagePath: page.imagePath);
            },
          ),
        ),
        const SizedBox(height: OnboardingConstants.spacingImageToIndicator),
        MingoringIndicator(
          itemCount: pages.length,
          currentIndex: currentIndex,
        ),
        const SizedBox(height: OnboardingConstants.spacingIndicatorToText),
        OnboardingPageTextContent(
          title: pages[currentIndex].title,
          description: pages[currentIndex].description,
        ),
      ],
    );
  }
}
