import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_typography.dart';

class MingoringVerifyButton extends StatelessWidget {
  const MingoringVerifyButton({
    super.key,
    required this.onPressed,
    this.onLongPress,
    this.onHover,
    this.onFocusChange,
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
  final ButtonStyle? style;
  final FocusNode? focusNode;
  final bool autofocus;
  final Clip? clipBehavior;
  final WidgetStatesController? statesController;
  final Widget child;

  static const _borderRadius = BorderRadius.all(Radius.circular(20));
  static const _height = 50.0;
  static const _horizontalPadding = 24.0;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = TextButton.styleFrom(
      foregroundColor: AppColors.pink600,
      disabledForegroundColor: AppColors.gray400,
      backgroundColor: AppColors.pink200,
      disabledBackgroundColor: AppColors.gray200,
      textStyle: AppTypography.body4B15.copyWith(height: 1.2),
      minimumSize: const Size(0, _height),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: const RoundedRectangleBorder(borderRadius: _borderRadius),
      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
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
