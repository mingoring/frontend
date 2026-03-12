import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_icon_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class MingoringTextFieldSearch extends StatefulWidget {
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

  @override
  State<MingoringTextFieldSearch> createState() =>
      _MingoringTextFieldSearchState();
}

class _MingoringTextFieldSearchState extends State<MingoringTextFieldSearch> {
  static const double _borderRadius = 20.0;
  static const double _horizontalPadding = 16.0;
  static const double _verticalPadding = 12.0;
  static const double _iconSize = 16.0;
  static const double _iconGap = 4.0;

  late final FocusNode _internalFocusNode;
  FocusNode get _focusNode => widget.focusNode ?? _internalFocusNode;

  @override
  void initState() {
    super.initState();
    _internalFocusNode = FocusNode();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(covariant MingoringTextFieldSearch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChanged);
      _focusNode.addListener(_handleFocusChanged);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    if (widget.focusNode == null) {
      _internalFocusNode.dispose();
    }
    super.dispose();
  }

  void _handleFocusChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focusNode.hasFocus;
    final borderColor = isFocused ? AppColors.pink600 : AppColors.gray400;
    final iconColor = isFocused ? AppColors.pink600 : AppColors.gray400;

    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      style: AppTextStyles.body3Md16.copyWith(
        color: AppColors.gray900,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: AppTextStyles.body3Md16.copyWith(
          color: AppColors.gray400,
        ),
        filled: true,
        fillColor: AppColors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          vertical: _verticalPadding,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(
            left: _horizontalPadding,
            right: _iconGap,
          ),
          child: SvgPicture.asset(
            AppIconAssets.search,
            width: _iconSize,
            height: _iconSize,
            colorFilter: ColorFilter.mode(
              iconColor,
              BlendMode.srcIn,
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: _horizontalPadding + _iconSize + _iconGap,
          minHeight: _iconSize,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
          borderSide: BorderSide(color: AppColors.gray400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
          borderSide: BorderSide(color: AppColors.pink600),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
          borderSide: BorderSide(color: AppColors.gray400),
        ),
      ),
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
    );
  }
}
