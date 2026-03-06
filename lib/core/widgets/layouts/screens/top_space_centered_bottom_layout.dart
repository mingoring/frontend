import 'package:flutter/material.dart';

import '../components/mingoring_text_button_bottom_column.dart';
import '../components/mingoring_back_header.dart';
import '../components/space_sized_box.dart';

/// 상단 영역 타입.
/// - [safeSpace]: SafeArea inset만 확보.
/// - [backHeader]: back 버튼 헤더. [headerTitle] 넘기면 중앙 타이틀 표시.
enum TopSpaceCenteredBottomTopType {
  safeSpace,
  backHeader,
}

/// 상단(헤더) + 중앙(콘텐츠) + 하단(버튼) 3단 레이아웃.
class TopSpaceCenteredBottomLayout extends StatelessWidget {
  const TopSpaceCenteredBottomLayout({
    super.key,
    required this.content,
    required this.buttonText,
    required this.onPressed,
    this.topType = TopSpaceCenteredBottomTopType.safeSpace,
    this.onBack,
    this.headerTitle,
    this.contentVerticalAlignment = MainAxisAlignment.center,
    this.contentHorizontalAlignment = CrossAxisAlignment.center,
  });

  final Widget content;
  final String buttonText;
  final VoidCallback? onPressed;
  final TopSpaceCenteredBottomTopType topType;

  /// [topType]이 [backHeader]일 때 필수.
  final VoidCallback? onBack;
  final String? headerTitle;

  /// 콘텐츠 영역 수직 정렬. 기본: center.
  final MainAxisAlignment contentVerticalAlignment;

  /// 콘텐츠 영역 수평 정렬. 기본: center.
  final CrossAxisAlignment contentHorizontalAlignment;

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

        Expanded(
          child: Column(
            mainAxisAlignment: contentVerticalAlignment,
            crossAxisAlignment: contentHorizontalAlignment,
            children: [
              content,
            ],
          ),
        ),

        MingoringTextButtonBottomColumn(
          buttonText: buttonText,
          onPressed: onPressed,
        ),
      ],
    );
  }
}
