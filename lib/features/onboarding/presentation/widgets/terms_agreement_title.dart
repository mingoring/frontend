import 'package:flutter/material.dart';

import '../../../../core/widgets/layouts/components/mingoring_text_button_bottom_column.dart';

/// 약관동의 화면의 제목 영역.
/// Continue 버튼과 동일한 좌우 여백을 사용하며, 제목은 좌측 정렬된다.
class TermsAgreementTitle extends StatelessWidget {
  const TermsAgreementTitle({
    super.key,
    required this.titleText,
    required this.titleStyle,
    this.horizontalPadding =
        MingoringTextButtonBottomColumn.defaultButtonHorizontalPadding,
  });

  final String titleText;
  final TextStyle titleStyle;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          titleText,
          style: titleStyle,
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}
