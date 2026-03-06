import 'package:flutter/material.dart';

import '../components/mingoring_back_header.dart';
import '../components/space_sized_box.dart';
import '../../buttons/mingoring_text_button.dart';

// 상단 영역 타입
enum PageFrameTopType {
  none,
  safeSpace,
  backHeader,
}

// 하단 영역 타입
enum PageFrameBottomType {
  none,
  actionButton,
}

// 페이지 프레임 위젯: 상단(옵션) + 중앙 콘텐츠 + 하단(옵션) 3단 레이아웃 (여백/레이아웃만 책임)
class PageFrame extends StatelessWidget {
  const PageFrame({
    super.key,
    this.topType = PageFrameTopType.safeSpace, // 상단 타입 (기본 safeSpace)
    this.topBackHeader, // 상단 헤더 위젯 전달 (옵션)
    required this.content, // 중앙 콘텐츠 위젯 전달 (필수)
    this.contentVerticalAlignment =
        MainAxisAlignment.center, // 중앙 콘텐츠 세로 정렬 타입 (기본 center)
    this.contentHorizontalAlignment =
        CrossAxisAlignment.center, // 중앙 콘텐츠 가로 정렬 타입 (기본 center)
    this.bottomType = PageFrameBottomType.none, // 하단 타입 (기본 none)
    this.bottomActionButton, // 하단 버튼 위젯 전달 (옵션)
  });

  final PageFrameTopType topType;
  final MingoringBackHeader? topBackHeader;

  final Widget content;
  final MainAxisAlignment contentVerticalAlignment;
  final CrossAxisAlignment contentHorizontalAlignment;

  final PageFrameBottomType bottomType;
  final MingoringTextButton? bottomActionButton;

  static const double _bottomHorizontalPadding = 32.0;

  @override
  Widget build(BuildContext context) {
    if (topType == PageFrameTopType.backHeader && topBackHeader == null) {
      throw ArgumentError(
        'topBackHeader is required when topType is backHeader',
      );
    }
    if (bottomType == PageFrameBottomType.actionButton &&
        bottomActionButton == null) {
      throw ArgumentError(
        'bottomActionButton is required when bottomType is actionButton',
      );
    }

    return Column(
      children: [
        _buildTop(context),
        Expanded(
          child: Column(
            mainAxisAlignment: contentVerticalAlignment,
            crossAxisAlignment: contentHorizontalAlignment,
            children: [content],
          ),
        ),
        _buildBottom(context),
      ],
    );
  }

  Widget _buildTop(BuildContext context) {
    return switch (topType) {
      PageFrameTopType.none => const SizedBox.shrink(),
      PageFrameTopType.safeSpace => SpaceSizedBox.topSafeSpace(context),
      PageFrameTopType.backHeader => topBackHeader!,
    };
  }

  Widget _buildBottom(BuildContext context) {
    return switch (bottomType) {
      PageFrameBottomType.none => const SizedBox.shrink(),
      PageFrameBottomType.actionButton => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: _bottomHorizontalPadding,
              ),
              child: bottomActionButton!,
            ),
            SpaceSizedBox.bottomSpace(context),
          ],
        ),
    };
  }
}
