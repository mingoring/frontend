import 'package:flutter/material.dart';

import '../components/mingoring_text_button_bottom_column.dart';
import '../components/space_sized_box.dart';

/// 상단 SpaceSizedBox + 가운데 정렬 콘텐츠 + 하단 MingoringTextButtonBottomColumn
class TopSpaceCenteredBottomLayout extends StatelessWidget {
  const TopSpaceCenteredBottomLayout({
    super.key,
    required this.content,
    required this.buttonText,
    required this.onPressed,
  });

  final Widget content;
  final String buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SpaceSizedBox.topSafeSpace(context),

        /// Container(height: 2, color: Colors.red),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              content,
            ],
          ),
        ),

        /// Container(height: 2, color: Colors.red),
        MingoringTextButtonBottomColumn(
          buttonText: buttonText,
          onPressed: onPressed,
        ),

        /// Container(height: 2, color: Colors.red),
      ],
    );
  }
}
