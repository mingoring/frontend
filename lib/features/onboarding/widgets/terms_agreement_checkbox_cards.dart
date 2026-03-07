import 'package:flutter/material.dart';

import '../../../core/utils/app_spacing.dart';

/// 약관동의 화면의 체크박스 카드 영역.
/// Continue 버튼과 동일한 좌우 여백을 사용한다.
class TermsAgreementCheckboxCards extends StatelessWidget {
  const TermsAgreementCheckboxCards({
    super.key,
    required this.children,
    this.horizontalPadding =
        AppSpacing.buttonHorizontalPadding,
  });

  final List<Widget> children;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
