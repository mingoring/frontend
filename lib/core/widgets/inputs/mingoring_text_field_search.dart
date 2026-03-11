import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_icon_assets.dart';
import 'mingoring_text_field.dart';

/// 검색용 단일행 텍스트 필드.
///
/// - 좌측에 핑크 검색 아이콘 고정
/// - 비포커스: gray400 테두리 / 포커스: pink600 테두리
class MingoringTextFieldSearch extends StatelessWidget {
  const MingoringTextFieldSearch({
    super.key,
    required this.controller,
    this.hintText = 'Search',
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

  static const double _iconSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return MingoringTextField(
      controller: controller,
      hintText: hintText,
      borderStyle: MingoringTextFieldBorderStyle.outlined,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      enabled: enabled,
      leadingIcon: SvgPicture.asset(
        AppIconAssets.search,
        width: _iconSize,
        height: _iconSize,
      ),
    );
  }
}
