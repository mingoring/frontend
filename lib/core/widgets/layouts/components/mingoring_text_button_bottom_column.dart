import 'package:flutter/material.dart';

import 'space_sized_box.dart';
import '../../buttons/mingoring_text_button.dart';

/// MingoringTextButton + 하단 여백 Column
class MingoringTextButtonBottomColumn extends StatelessWidget {
  const MingoringTextButtonBottomColumn({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.horizontalPadding = defaultButtonHorizontalPadding,
    this.buttonSize = MingoringTextButtonSize.big,
  });

  final String buttonText;
  final VoidCallback? onPressed;
  final double horizontalPadding;
  final MingoringTextButtonSize buttonSize;

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
