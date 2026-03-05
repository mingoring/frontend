import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/widgets/buttons/mingoring_text_button.dart';
import '../../../../core/widgets/indicators/mingoring_indicator.dart';
import 'login_screen.dart';
import '../widgets/onboarding_page_content.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  final String imagePath;
  final String title;
  final String description;
}

const _onboardingPages = <_OnboardingPageData>[
  _OnboardingPageData(
    imagePath: AppImages.onboarding1,
    title: 'Learn Korean for fun',
    description: 'with the videos you love,\nnot boring textbooks',
  ),
  _OnboardingPageData(
    imagePath: AppImages.onboarding2,
    title: 'No setup required',
    description: 'Just paste a YouTube link\nand start learning',
  ),
  _OnboardingPageData(
    imagePath: AppImages.onboarding3,
    title: 'Beyond translation',
    description: 'Understand the real nuance\nbehind words',
  ),
];

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _pageAnimationDuration = Duration(milliseconds: 300);
  static const _buttonHorizontalPadding = 32.0;
  static const _buttonBottomPaddingRatio = 0.11;
  static const _spacingImageToIndicatorRatio = 0.04;
  static const _spacingIndicatorToText = 18.0;
  static const _spacingTextToButtonRatio = 0.05;
  static const _indicatorDotSize = 6.0;
  static const _indicatorSpacing = 6.0;
  static const _indicatorSelectedScale = 1.0;

  static const _backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.pink200,
      AppColors.pink200,
      AppColors.white,
      AppColors.white,
    ],
    stops: [0.0, 0.217, 0.627, 1.0],
  );

  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    final pageCount = _onboardingPages.length;

    if (_currentIndex < pageCount - 1) {
      _pageController.animateToPage(
        _currentIndex + 1,
        duration: _pageAnimationDuration,
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _onPageViewChanged(int index) {
    if (_currentIndex == index) return;
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageCount = _onboardingPages.length;
    final isLastPage = _currentIndex == pageCount - 1;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: _backgroundGradient),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final buttonBottomPadding =
                  constraints.maxHeight * _buttonBottomPaddingRatio;
              final spacingImageToIndicator =
                  constraints.maxHeight * _spacingImageToIndicatorRatio;
              final spacingTextToButton =
                  constraints.maxHeight * _spacingTextToButtonRatio;
              final currentPage = _onboardingPages[_currentIndex];

              return Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: pageCount,
                      onPageChanged: _onPageViewChanged,
                      itemBuilder: (_, index) {
                        final page = _onboardingPages[index];
                        return OnboardingPageImage(
                          imagePath: page.imagePath,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: spacingImageToIndicator),
                  MingoringIndicator(
                    itemCount: pageCount,
                    currentIndex: _currentIndex,
                    dotSize: _indicatorDotSize,
                    spacing: _indicatorSpacing,
                    selectedScale: _indicatorSelectedScale,
                    activeColor: AppColors.pink600,
                    inactiveColor: AppColors.gray300,
                  ),
                  const SizedBox(height: _spacingIndicatorToText),
                  OnboardingPageTextContent(
                    title: currentPage.title,
                    description: currentPage.description,
                  ),
                  SizedBox(height: spacingTextToButton),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      _buttonHorizontalPadding,
                      0,
                      _buttonHorizontalPadding,
                      buttonBottomPadding,
                    ),
                    child: MingoringTextButton(
                      onPressed: _onNextPressed,
                      size: MingoringTextButtonSize.big,
                      child: Text(isLastPage ? 'Start in 3 seconds' : 'Next'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
