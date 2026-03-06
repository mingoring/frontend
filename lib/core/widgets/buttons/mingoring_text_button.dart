import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';

enum MingoringTextButtonSize {
  big(height: 58.0),
  small(height: 50.0),
  popup(height: 50.0);

  const MingoringTextButtonSize({required this.height});

  final double height;

  TextStyle get _textStyle => switch (this) {
        big => AppTypography.head6B18.copyWith(height: 1.2),
        small || popup => AppTypography.body4B15.copyWith(height: 1.2),
      };
}

/// [onPressed]가 null이면 disabled 상태로 렌더링된다.
class MingoringTextButton extends StatelessWidget {
  const MingoringTextButton({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
    this.size = MingoringTextButtonSize.big,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.clipBehavior,
    this.statesController,
    required this.child,
  });

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final MingoringTextButtonSize size;
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip? clipBehavior;
  final WidgetStatesController? statesController;
  final Widget child;

  static const _borderRadius = BorderRadius.all(Radius.circular(20));

  @override
  Widget build(BuildContext context) {
    final defaultStyle = TextButton.styleFrom(
      foregroundColor: AppColors.white,
      disabledForegroundColor: AppColors.white,
      backgroundColor: AppColors.pink600,
      disabledBackgroundColor: AppColors.gray400,
      textStyle: size._textStyle,
      minimumSize: Size(double.infinity, size.height),
      shape: const RoundedRectangleBorder(borderRadius: _borderRadius),
      padding: EdgeInsets.zero,
    );

    return TextButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior ?? Clip.none,
      statesController: statesController,
      style: defaultStyle.merge(style),
      child: child,
    );
  }
}
