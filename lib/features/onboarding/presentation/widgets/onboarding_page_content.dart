import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_logo_typography.dart';
import '../../../../core/constants/app_typography.dart';

class OnboardingPageImage extends StatelessWidget {
  const OnboardingPageImage({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  static const _horizontalPadding = 24.0;
  static const _imageHeightRatio = 0.38;
  static const _topPaddingRatio = 0.11;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: Column(
        children: [
          SizedBox(height: size.height * _topPaddingRatio),
          SizedBox(
            height: size.height * _imageHeightRatio,
            child: SvgPicture.asset(imagePath, fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}

class OnboardingPageTextContent extends StatelessWidget {
  const OnboardingPageTextContent({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  static const _horizontalPadding = 24.0;
  static const _spacingTitleToDescription = 14.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: AppLogoTypography.logoEb4.copyWith(color: AppColors.pink600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: _spacingTitleToDescription),
          Text(
            description,
            style: AppTypography.body2Sb16.copyWith(
              color: AppColors.gray600,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
