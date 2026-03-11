import 'package:flutter/material.dart';

import 'mingoring_text_field.dart';

/// 본문(내용) 입력용 멀티라인 텍스트 필드.
///
/// - 높이 200px 고정, 텍스트 상단 정렬
/// - 비포커스: 그림자 / 포커스: pink600 테두리
class MingoringTextFieldContent extends StatelessWidget {
  const MingoringTextFieldContent({
    super.key,
    required this.controller,
    this.hintText = 'Please describe your inquiry in detail.',
    this.onChanged,
    this.focusNode,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final bool enabled;

  static const double _height = 200.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: MingoringTextField(
        controller: controller,
        hintText: hintText,
        borderStyle: MingoringTextFieldBorderStyle.shadow,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        expands: true,
        verticalAlignment: CrossAxisAlignment.start,
        onChanged: onChanged,
        focusNode: focusNode,
        enabled: enabled,
      ),
    );
  }
}
