import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_icon_assets.dart';
import '../../../constants/app_typography.dart';
import 'mingoring_text_button_bottom_column.dart';

/// 좌측 뒤로가기 + (옵션) 중앙 타이틀 헤더.
/// SafeArea(top)를 포함하며, 기기별로 자연스럽게 배치된다.
class MingoringBackHeader extends StatelessWidget {
  const MingoringBackHeader({
    super.key,
    required this.onBack,
    this.title,
    this.backgroundColor = Colors.transparent,
    this.horizontalPadding =
        MingoringTextButtonBottomColumn.defaultButtonHorizontalPadding,
  });

  final VoidCallback onBack;
  final String? title;
  final Color backgroundColor;
  final double horizontalPadding;

  static const double _iconSize = 24.0;

  @override
  Widget build(BuildContext context) {
    final isTransparent = backgroundColor == Colors.transparent;

    return Material(
      type: isTransparent ? MaterialType.transparency : MaterialType.canvas,
      color: isTransparent ? null : backgroundColor,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: kToolbarHeight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Semantics(
                    button: true,
                    label: 'Back',
                    child: InkResponse(
                      onTap: onBack,
                      radius: _iconSize,
                      child: SvgPicture.asset(
                        AppIconAssets.arrowLeft,
                        width: _iconSize,
                        height: _iconSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                if (title != null)
                  Text(
                    title!,
                    style: AppTypography.body7B14.copyWith(
                      color: AppColors.black,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

