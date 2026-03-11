import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// 공통 텍스트 필드 베이스 위젯.
///
/// [MingoringSearchTextField], [MingoringTitleTextField],
/// [MingoringContentTextField]의 공통 구조를 담당합니다.
class MingoringTextField extends StatefulWidget {
  const MingoringTextField({
    super.key,
    required this.controller,
    this.hintText = '',
    this.leadingIcon,
    this.minLines = 1,
    this.maxLines = 1,
    this.expands = false,
    this.verticalAlignment = CrossAxisAlignment.center,
    this.borderStyle = MingoringTextFieldBorderStyle.shadow,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String hintText;

  /// 좌측 아이콘 위젯 (없으면 null)
  final Widget? leadingIcon;

  final int minLines;
  final int maxLines;

  /// true이면 부모 높이를 채웁니다 (multiline 확장 시 사용).
  final bool expands;

  /// 내용물 수직 정렬 (단일행: center, 멀티라인: start)
  final CrossAxisAlignment verticalAlignment;

  /// 테두리 스타일 — shadow(그림자+포커스 테두리) / outlined(항상 테두리)
  final MingoringTextFieldBorderStyle borderStyle;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool enabled;

  @override
  State<MingoringTextField> createState() => _MingoringTextFieldState();
}

enum MingoringTextFieldBorderStyle {
  /// 기본 그림자 + 포커스 시 핑크 테두리
  shadow,

  /// 항상 테두리 표시 (비포커스: gray400, 포커스: pink600)
  outlined,
}

class _MingoringTextFieldState extends State<MingoringTextField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  static const double _borderRadius = 20.0;
  static const double _horizontalPadding = 16.0;
  static const double _verticalPadding = 12.0;
  static const double _iconSize = 16.0;
  static const double _iconGap = 16.0;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant MingoringTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      _focusNode.removeListener(_onFocusChanged);
      if (oldWidget.focusNode == null) _focusNode.dispose();
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_onFocusChanged);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  BoxDecoration get _decoration {
    final borderRadius = BorderRadius.circular(_borderRadius);

    return switch (widget.borderStyle) {
      MingoringTextFieldBorderStyle.shadow => BoxDecoration(
          color: AppColors.white,
          borderRadius: borderRadius,
          border: _isFocused
              ? Border.all(color: AppColors.pink600)
              : Border.all(color: Colors.transparent),
          boxShadow: _isFocused
              ? null
              : [
                  BoxShadow(
                    color: AppColors.gray300,
                    blurRadius: 5,
                  ),
                ],
        ),
      MingoringTextFieldBorderStyle.outlined => BoxDecoration(
          color: AppColors.white,
          borderRadius: borderRadius,
          border: Border.all(
            color: _isFocused ? AppColors.pink600 : AppColors.gray400,
          ),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (widget.enabled) FocusScope.of(context).requestFocus(_focusNode);
      },
      child: Container(
        decoration: _decoration,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: _horizontalPadding,
            vertical: _verticalPadding,
          ),
          child: Row(
            crossAxisAlignment: widget.verticalAlignment,
            children: [
              if (widget.leadingIcon != null) ...[
                SizedBox(
                  width: _iconSize,
                  height: _iconSize,
                  child: widget.leadingIcon,
                ),
                const SizedBox(width: _iconGap),
              ],
              Expanded(child: _buildTextField()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      minLines: widget.expands ? null : widget.minLines,
      maxLines: widget.expands ? null : widget.maxLines,
      expands: widget.expands,
      textAlignVertical: widget.expands ? TextAlignVertical.top : null,
      style: AppTextStyles.body3Md16.copyWith(color: AppColors.gray900),
      decoration: InputDecoration(
        isCollapsed: true,
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        hintText: widget.hintText,
        hintStyle: AppTextStyles.body3Md16.copyWith(
          color: AppColors.gray400,
        ),
        isDense: true,
      ),
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
    );
  }
}
