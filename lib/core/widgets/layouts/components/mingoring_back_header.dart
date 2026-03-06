import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_icon_assets.dart';
import '../../../constants/app_typography.dart';
import 'mingoring_text_button_bottom_column.dart';

// 상단 헤더 타입
enum MingoringBackHeaderType {
  none,
  title,
  actionSave,
  actionEdit,
}

// 좌측 뒤로가기와 타입별 텍스트/액션을 제공하는 상단 헤더
class MingoringBackHeader extends StatelessWidget {
  const MingoringBackHeader({
    super.key,
    required this.onBack,
    this.type = MingoringBackHeaderType.none,
    this.text,
    this.onActionPressed,
    this.backgroundColor = Colors.transparent,
    this.horizontalPadding =
        MingoringTextButtonBottomColumn.defaultButtonHorizontalPadding,
  });

  final VoidCallback onBack; // 뒤로가기 콜백
  final MingoringBackHeaderType type; // 헤더 타입
  final String? text; // 타이틀 또는 액션 텍스트
  final VoidCallback? onActionPressed; // 우측 액션 버튼 클릭 콜백
  final Color backgroundColor; // 배경색
  final double horizontalPadding; // 가로 여백

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
                if (type == MingoringBackHeaderType.title && text != null)
                  Text(
                    text!,
                    style: AppTypography.body7B14.copyWith(
                      color: AppColors.black,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (type == MingoringBackHeaderType.actionSave && text != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: onActionPressed,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, _iconSize),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        text!,
                        style: AppTypography.body7B14.copyWith(
                          color: AppColors.pink600,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                if (type == MingoringBackHeaderType.actionEdit && text != null)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: onActionPressed,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, _iconSize),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        text!,
                        style: AppTypography.body7B14.copyWith(
                          color: AppColors.gray700,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

