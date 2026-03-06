import 'package:flutter/material.dart';

import '../components/mingoring_text_button_bottom_column.dart';
import '../components/mingoring_back_header.dart';
import '../components/space_sized_box.dart';

/// `TopSpaceCenteredBottomLayout`의 상단 영역 타입.
///
/// - `safeSpace`: 상단 SafeArea(inset)만 확보
/// - `backHeader`: MingoringBackHeader (`onBack`은 필수, `headerTitle`을 넘기면 중앙 타이틀이 표시되고, null이면 좌측 back만 표시됩니다.)

enum TopSpaceCenteredBottomTopType {
  safeSpace,
  backHeader,
}

/// 상단 SpaceSizedBox + 가운데 정렬 콘텐츠 + 하단 MingoringTextButtonBottomColumn
class TopSpaceCenteredBottomLayout extends StatelessWidget {
  const TopSpaceCenteredBottomLayout({
    super.key,
    required this.content,
    required this.buttonText,
    required this.onPressed,
    this.topType = TopSpaceCenteredBottomTopType.safeSpace,
    this.onBack,
    this.headerTitle,
  });

  final Widget content;
  final String buttonText;
  final VoidCallback? onPressed;
  final TopSpaceCenteredBottomTopType topType;
  final VoidCallback? onBack;
  final String? headerTitle;

  @override
  Widget build(BuildContext context) {
    assert(
      topType != TopSpaceCenteredBottomTopType.backHeader || onBack != null,
      'topType이 backHeader이면 onBack이 필요합니다.',
    );

    return Column(
      children: [
        switch (topType) {
          TopSpaceCenteredBottomTopType.safeSpace =>
            SpaceSizedBox.topSafeSpace(context),
          TopSpaceCenteredBottomTopType.backHeader =>
            MingoringBackHeader(
              onBack: onBack!,
              type: headerTitle == null
                  ? MingoringBackHeaderType.none
                  : MingoringBackHeaderType.title,
              text: headerTitle,
            ),
        },

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
