import 'package:flutter/material.dart';

import 'mingoring_text_field_base.dart';

/// 제목 입력용 단일행 텍스트 필드.
///
/// - 아이콘 없음
/// - 비포커스: 그림자 / 포커스: pink600 테두리
class MingoringTextFieldTitle extends StatelessWidget {
  const MingoringTextFieldTitle({
    super.key,
    required this.controller,
    this.hintText = 'Enter the title',
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return MingoringTextFieldBase(
      controller: controller,
      hintText: hintText,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      enabled: enabled,
    );
  }
}
