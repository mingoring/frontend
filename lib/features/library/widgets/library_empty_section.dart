import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_mingo_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_logo_typography.dart';
import '../../../core/theme/app_text_styles.dart';
import '../constants/library_constants.dart';

class LibraryEmptySection extends StatelessWidget {
  const LibraryEmptySection({super.key});

  static const double _mingoWidth = 118.0;
  static const double _mingoToTitleSpacing = 30.0;
  static const double _titleToSubtitleSpacing = 12.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            MingoAssets.empty,
            width: _mingoWidth,
          ),
          const SizedBox(height: _mingoToTitleSpacing),
          Text(
            LibraryConstants.emptyTitle,
            style: AppLogoTypography.logoEb5.copyWith(
              color: AppColors.pink600,
            ),
          ),
          const SizedBox(height: _titleToSubtitleSpacing),
          Text(
            LibraryConstants.emptySubtitle,
            style: AppTextStyles.body8Sb14.copyWith(
              color: AppColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
}
