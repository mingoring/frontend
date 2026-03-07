import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

// 텍스트 버튼 사이즈
enum MingoringTextButtonSize {
  big(height: 58.0),
  small(height: 50.0),
  popup(height: 50.0);

  const MingoringTextButtonSize({required this.height});

  final double height;

  TextStyle get _textStyle => switch (this) {
        big => AppTextStyles.head6B18.copyWith(height: 1.2),
        small || popup => AppTextStyles.body4B15.copyWith(height: 1.2),
      };
}

// 텍스트 버튼 (onPressed 가 null 이면 disabled 상태)
class MingoringTextButton extends StatelessWidget {
  const MingoringTextButton({
    super.key,
    required this.onPressed, // 클릭 콜백 (null 이면 disabled)
    this.onLongPress, // 길게 누르기 콜백
    this.onHover, // 호버 콜백
    this.onFocusChange, // 포커스 변경 콜백
    this.size = MingoringTextButtonSize.big, // 버튼 사이즈
    this.style, // 커스텀 버튼 스타일
    this.focusNode, // 포커스 노드
    this.autofocus = false, // 자동 포커스 여부
    this.clipBehavior, // 클립 동작 방식
    this.statesController, // 상태 컨트롤러
    required this.child, // 버튼 내용
  });

  final VoidCallback? onPressed; // 클릭 콜백
  final VoidCallback? onLongPress; // 길게 누르기 콜백
  final ValueChanged<bool>? onHover; // 호버 콜백
  final ValueChanged<bool>? onFocusChange; // 포커스 변경 콜백
  final MingoringTextButtonSize size; // 버튼 사이즈
  final ButtonStyle? style; // 커스텀 버튼 스타일
  final FocusNode? focusNode; // 포커스 노드
  final bool autofocus; // 자동 포커스 여부
  final Clip? clipBehavior; // 클립 동작 방식
  final WidgetStatesController? statesController; // 상태 컨트롤러
  final Widget child; // 버튼 내용

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
