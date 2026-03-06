import 'package:flutter/material.dart';

import 'space_sized_box.dart';
import '../../buttons/mingoring_text_button.dart';

// MingoringTextButton + 하단 자동 여백 Column 위젯
class MingoringTextButtonBottomColumn extends StatelessWidget {
  const MingoringTextButtonBottomColumn({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.horizontalPadding = defaultButtonHorizontalPadding,
    this.buttonSize = MingoringTextButtonSize.big,
  });

  final String buttonText; // 버튼 텍스트
  final VoidCallback? onPressed; // 버튼 클릭 콜백
  final double horizontalPadding; // 가로 여백
  final MingoringTextButtonSize buttonSize; // 버튼 사이즈

  static const defaultButtonHorizontalPadding = 32.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: MingoringTextButton(
            onPressed: onPressed,
            size: buttonSize,
            child: Text(buttonText),
          ),
        ),
        SpaceSizedBox.bottomSpace(context),
      ],
    );
  }
}
