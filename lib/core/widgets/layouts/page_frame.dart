import 'package:flutter/material.dart';

import 'mingoring_back_header.dart';
import '../../utils/app_spacing.dart';
import '../buttons/mingoring_text_button.dart';

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
    this.bottomType = PageFrameBottomType.none, // 하단 타입 (기본 none)
    this.bottomActionButton, // 하단 버튼 위젯 전달 (옵션)
  })  : assert(
          topType != PageFrameTopType.backHeader || topBackHeader != null,
          'topBackHeader is required when topType is backHeader',
        ),
        assert(
          bottomType != PageFrameBottomType.actionButton ||
              bottomActionButton != null,
          'bottomActionButton is required when bottomType is actionButton',
        );

  final PageFrameTopType topType;
  final MingoringBackHeader? topBackHeader;

  final Widget content;

  final PageFrameBottomType bottomType;
  final MingoringTextButton? bottomActionButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTop(context),
        Expanded(child: content),
        _buildBottom(context),
      ],
    );
  }

  Widget _buildTop(BuildContext context) {
    return switch (topType) {
      PageFrameTopType.none => const SizedBox.shrink(),
      PageFrameTopType.safeSpace => SizedBox(height: AppSpacing.topSafeInset(context)),
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
                horizontal: AppSpacing.buttonHorizontalPadding,
              ),
              child: bottomActionButton!,
            ),
            SizedBox(height: AppSpacing.bottomMargin(context)),
          ],
        ),
    };
  }
}
