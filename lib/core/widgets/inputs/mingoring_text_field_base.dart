import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// [MingoringTextFieldTitle], [MingoringTextFieldContent] 전용 공통 텍스트 필드 베이스.
///
/// - 비포커스: 그림자
/// - 포커스: pink600 테두리
/// - 내부 TextField는 border none
class MingoringTextFieldBase extends StatefulWidget {
  const MingoringTextFieldBase({
    super.key,
    required this.controller,
    this.hintText = '',
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.minLines = 1,
    this.maxLines = 1,
    this.expands = false,
    this.textAlignVertical,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int minLines;
  final int maxLines;
  final bool expands;
  final TextAlignVertical? textAlignVertical;

  @override
  State<MingoringTextFieldBase> createState() =>
      _MingoringTextFieldBaseState();
}

class _MingoringTextFieldBaseState extends State<MingoringTextFieldBase> {
  static const double _borderRadius = 20.0;
  static const double _horizontalPadding = 16.0;
  static const double _verticalPadding = 12.0;

  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChanged);
    _isFocused = _focusNode.hasFocus;
  }

  @override
  void didUpdateWidget(covariant MingoringTextFieldBase oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      _focusNode.removeListener(_handleFocusChanged);
      if (oldWidget.focusNode == null) {
        _focusNode.dispose();
      }
      _focusNode = widget.focusNode ?? FocusNode();
      _focusNode.addListener(_handleFocusChanged);
      _isFocused = _focusNode.hasFocus;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChanged() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  BoxDecoration get _decoration {
    final borderRadius = BorderRadius.circular(_borderRadius);

    return BoxDecoration(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (widget.enabled) {
          FocusScope.of(context).requestFocus(_focusNode);
        }
      },
      child: Container(
        decoration: _decoration,
        padding: const EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _verticalPadding,
        ),
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          minLines: widget.expands ? null : widget.minLines,
          maxLines: widget.expands ? null : widget.maxLines,
          expands: widget.expands,
          textAlignVertical: widget.textAlignVertical,
          style: AppTextStyles.body3Md16.copyWith(
            color: AppColors.gray900,
          ),
          decoration: InputDecoration(
            isCollapsed: true,
            isDense: true,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: widget.hintText,
            hintStyle: AppTextStyles.body3Md16.copyWith(
              color: AppColors.gray400,
            ),
          ),
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
        ),
      ),
    );
  }
}
