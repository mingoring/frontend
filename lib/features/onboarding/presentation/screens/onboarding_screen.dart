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

  static const _horizontalPadding = 32.0;

  // 이미지 영역의 고정 높이 (이미지 들어갈 정도의 크기)
  static const _imageBoxHeight = 320.0;

  // 요소들 간의 정확한 고정 간격
  static const _spacingImageToIndicator = 32.0;
  static const _spacingIndicatorToText = 18.0;
  static const _spacingTextToButton = 40.0;
  static const _indicatorDotSize = 6.0;
  static const _indicatorSpacing = 6.0;
  static const _indicatorSelectedScale = 1.0;

  static const _backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.pink200,
      AppColors.white,
    ],
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
          child: Column(
            children: [
              // 1. 최상단 여백 (하단 여백과 동일하게 늘어남)
              const Spacer(),

              // 2. 이미지 영역: 높이를 제한하여 불필요한 공백 제거
              SizedBox(
                height: _imageBoxHeight,
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

              // 3. 이미지와 인디케이터 사이의 고정 간격
              const SizedBox(height: _spacingImageToIndicator),

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
                title: _onboardingPages[_currentIndex].title,
                description: _onboardingPages[_currentIndex].description,
              ),
              const SizedBox(height: _spacingTextToButton),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: _horizontalPadding,
                ),
                child: MingoringTextButton(
                  onPressed: _onNextPressed,
                  size: MingoringTextButtonSize.big,
                  child: Text(isLastPage ? 'Start in 3 seconds' : 'Next'),
                ),
              ),

              // 4. 최하단 여백 (상단 여백과 동일하게 늘어나 전체를 중앙으로 맞춰줌)
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
