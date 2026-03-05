import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';

enum MingoringBadgeSize {
  big,
  small,
}

enum MingoringBadgeColor {
  gray,
  lightPink,
  darkPink,
  pink,
}

/// 라벨 표시용 배지 위젯. [badgeColor]로 4가지 색상,
/// [size]로 big/small 사이즈를 선택한다.
class MingoringBadge extends StatelessWidget {
  const MingoringBadge({
    super.key,
    required this.label,
    this.size = MingoringBadgeSize.small,
    this.badgeColor = MingoringBadgeColor.gray,
    this.labelStyle,
    this.padding,
    this.side,
    this.shape,
    this.clipBehavior = Clip.none,
  });

  final Widget label;
  final MingoringBadgeSize size;
  final MingoringBadgeColor badgeColor;
  final TextStyle? labelStyle;
  final EdgeInsetsGeometry? padding;
  final BorderSide? side;
  final OutlinedBorder? shape;
  final Clip clipBehavior;

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
        MingoringBadgeSize.big => AppTypography.body8Sb14.copyWith(
            color: _foregroundColor,
            height: 1.2,
          ),
        MingoringBadgeSize.small => AppTypography.detail5Sb12.copyWith(
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
