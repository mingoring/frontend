import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_mingo_assets.dart';
import '../../../core/router/route_names.dart';
import '../constants/bookmark_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_logo_typography.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/buttons/mingoring_text_button.dart';
import '../../../core/widgets/layouts/mingoring_app_bar.dart';

class BookmarkEmptyScreen extends StatelessWidget {
  const BookmarkEmptyScreen({super.key});

  static const _mingoWidth = 118.0;
  static const _mingoHeight = 164.0;
  static const _mingoTopSpacing = 160.0;
  static const _mingoToTitleSpacing = 30.0;
  static const _titleToSubtitleSpacing = 12.0;
  static const _subtitleToButtonSpacing = 73.0;
  static const _buttonHorizontalPadding = 44.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pink50,
      appBar: MingoringAppBar(
        type: MingoringBackHeaderType.none,
        onBack: () => context.pop(),
        backgroundColor: AppColors.pink50,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: _mingoTopSpacing),
          Image.asset(
            MingoAssets.idleMainSad,
            width: _mingoWidth,
            height: _mingoHeight,
          ),
          const SizedBox(height: _mingoToTitleSpacing),
          Text(
            BookmarkConstants.emptyTitle,
            style: AppLogoTypography.logoEb5.copyWith(
              color: AppColors.pink600,
            ),
          ),
          const SizedBox(height: _titleToSubtitleSpacing),
          Text(
            BookmarkConstants.emptySubtitle,
            style: AppTextStyles.body5Sb15.copyWith(
              color: AppColors.gray600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: _subtitleToButtonSpacing),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: _buttonHorizontalPadding,
            ),
            child: MingoringTextButton(
              size: MingoringTextButtonSize.small,
              onPressed: () => context.go(RouteNames.library),
              child: const Text(BookmarkConstants.goLibraryButton),
            ),
          ),
        ],
      ),
    );
  }
}
