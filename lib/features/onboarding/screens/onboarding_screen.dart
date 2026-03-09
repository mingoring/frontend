import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/onboarding_constants.dart';
import '../widgets/onboarding_center_content.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/buttons/mingoring_text_button.dart';
import '../../../core/widgets/layouts/gradient_background.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
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
    if (_currentIndex < onboardingPages.length - 1) {
      _pageController.animateToPage(
        _currentIndex + 1,
        duration: OnboardingConstants.pageAnimationDuration,
        curve: Curves.easeInOut,
      );
    } else {
      context.go(RouteNames.login);
    }
  }

  void _onPageViewChanged(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentIndex == onboardingPages.length - 1;

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: OnboardingCenterContent(
                    pages: onboardingPages,
                    currentIndex: _currentIndex,
                    pageController: _pageController,
                    onPageChanged: _onPageViewChanged,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.contentHorizontalSpacing,
                ),
                child: MingoringTextButton(
                  onPressed: _onNextPressed,
                  size: MingoringTextButtonSize.big,
                  child: Text(isLastPage ? 'Start' : 'Next'),
                ),
              ),
              const SizedBox(height: AppSpacing.actionBottomSpacing),
            ],
          ),
        ),
      ),
    );
  }
}
