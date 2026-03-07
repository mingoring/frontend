import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

// 배지 사이즈
enum MingoringBadgeSize {
  big,
  small,
}

// 배지 색상
enum MingoringBadgeColor {
  gray,
  lightPink,
  darkPink,
  pink,
}

// 라벨 표시용 배지 위젯
class MingoringBadge extends StatelessWidget {
  const MingoringBadge({
    super.key,
    required this.label, // 표시할 라벨 위젯
    this.size = MingoringBadgeSize.small, // 배지 사이즈
    this.badgeColor = MingoringBadgeColor.gray, // 배지 색상
    this.labelStyle, // 라벨 텍스트 스타일
    this.padding, // 여백
    this.side, // 테두리 옵션
    this.shape, // 테두리 모양
    this.clipBehavior = Clip.none, // 클립 동작 방식
  });

  final Widget label; // 표시할 라벨 위젯
  final MingoringBadgeSize size; // 배지 사이즈
  final MingoringBadgeColor badgeColor; // 배지 색상
  final TextStyle? labelStyle; // 라벨 텍스트 스타일
  final EdgeInsetsGeometry? padding; // 여백
  final BorderSide? side; // 테두리 옵션
  final OutlinedBorder? shape; // 테두리 모양
  final Clip clipBehavior; // 클립 동작 방식

  static const _smallHeight = 21.0;
  static const _bigHeight = 26.0;
  static const _smallPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 3);
  static const _bigPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 4);
  static const _defaultShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(20)),
  );

  double get _defaultHeight => switch (size) {
        MingoringBadgeSize.big => _bigHeight,
        MingoringBadgeSize.small => _smallHeight,
      };

  EdgeInsets get _defaultPadding => switch (size) {
        MingoringBadgeSize.big => _bigPadding,
        MingoringBadgeSize.small => _smallPadding,
      };

  Color get _backgroundColor => switch (badgeColor) {
        MingoringBadgeColor.gray => AppColors.gray400,
        MingoringBadgeColor.lightPink => AppColors.pink200,
        MingoringBadgeColor.darkPink => AppColors.pink600,
        MingoringBadgeColor.pink => AppColors.pink300,
      };

  Color get _foregroundColor => switch (badgeColor) {
        MingoringBadgeColor.gray => AppColors.white,
        MingoringBadgeColor.lightPink => AppColors.pink600,
        MingoringBadgeColor.darkPink => AppColors.pink50,
        MingoringBadgeColor.pink => AppColors.pink50,
      };

  TextStyle get _defaultLabelStyle => switch (size) {
        MingoringBadgeSize.big => AppTextStyles.body8Sb14.copyWith(
            color: _foregroundColor,
            height: 1.2,
          ),
        MingoringBadgeSize.small => AppTextStyles.detail5Sb12.copyWith(
            color: _foregroundColor,
            height: 1.2,
          ),
      };

  @override
  Widget build(BuildContext context) {
    final effectiveShape = (shape ?? _defaultShape).copyWith(
      side: side ?? BorderSide.none,
    );

    return Container(
      height: _defaultHeight,
      padding: padding ?? _defaultPadding,
      clipBehavior: clipBehavior,
      decoration: ShapeDecoration(
        color: _backgroundColor,
        shape: effectiveShape,
      ),
      child: DefaultTextStyle.merge(
        style: labelStyle ?? _defaultLabelStyle,
        child: label,
      ),
    );
  }
}
