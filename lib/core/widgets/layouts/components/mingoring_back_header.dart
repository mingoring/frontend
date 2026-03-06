import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_icon_assets.dart';
import '../../../constants/app_typography.dart';
import 'mingoring_text_button_bottom_column.dart';

// 상단 헤더 타입
enum MingoringBackHeaderType {
  none, // [뒤로가기]
  title, // [뒤로가기] + [타이틀]
  titleWithSave, // [뒤로가기] + [타이틀] + [저장]
  titleWithEdit, // [뒤로가기] + [타이틀] + [수정]
}

class MingoringBackHeader extends StatelessWidget {
  // none 타입, title 타입 전용
  const MingoringBackHeader({
    super.key,
    required this.onBack,
    this.type = MingoringBackHeaderType.none,
    this.text,
    this.backgroundColor = Colors.transparent,
    this.horizontalPadding =
        MingoringTextButtonBottomColumn.defaultButtonHorizontalPadding,
  })  : onActionPressed = null,
        assert(
          type != MingoringBackHeaderType.titleWithSave &&
              type != MingoringBackHeaderType.titleWithEdit,
          '액션 헤더는 MingoringBackHeader.actionSave() 또는 '
          'MingoringBackHeader.actionEdit()를 사용하세요.',
        );

  // titleWithSave 타입 전용
  const MingoringBackHeader.actionSave({
    super.key,
    required this.onBack,
    required String this.text,
    required VoidCallback this.onActionPressed,
    this.backgroundColor = Colors.transparent,
    this.horizontalPadding =
        MingoringTextButtonBottomColumn.defaultButtonHorizontalPadding,
  }) : type = MingoringBackHeaderType.titleWithSave;

  // titleWithEdit 타입 전용
  const MingoringBackHeader.actionEdit({
    super.key,
    required this.onBack,
    required String this.text,
    required VoidCallback this.onActionPressed,
    this.backgroundColor = Colors.transparent,
    this.horizontalPadding =
        MingoringTextButtonBottomColumn.defaultButtonHorizontalPadding,
  }) : type = MingoringBackHeaderType.titleWithEdit;

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
                if (type == MingoringBackHeaderType.titleWithSave && text != null)
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
                if (type == MingoringBackHeaderType.titleWithEdit && text != null)
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

