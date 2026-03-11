import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_icon_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class MingoringDropdownMenuBig extends StatefulWidget {
  const MingoringDropdownMenuBig({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.placeholder = 'Please choose a category',
  });

  final List<String> options;
  final String? selectedValue;
  final ValueChanged<String> onChanged;
  final String placeholder;

  @override
  State<MingoringDropdownMenuBig> createState() =>
      _MingoringDropdownMenuBigState();
}

class _MingoringDropdownMenuBigState
    extends State<MingoringDropdownMenuBig> {
  bool _isOpen = false;

  static const double _fieldHeight = 50.0;
  static const double _fieldHorizontalPadding = 26.0;
  static const double _fieldVerticalPadding = 11.0;
  static const double _fieldBorderRadius = 20.0;
  static const double _arrowIconWidth = 10.0;
  static const double _arrowIconHeight = 16.0;
  static const double _popupHorizontalPadding = 7.0;
  static const double _popupVerticalPadding = 14.0;
  static const double _popupItemGap = 10.0;
  static const double _popupBorderRadius = 20.0;
  static const double _popupElevation = 5.0;
  static const double _popupTopOffset = 0.0;

  void _toggleOpen() {
    setState(() => _isOpen = !_isOpen);
  }

  void _select(String value) {
    widget.onChanged(value);
    setState(() => _isOpen = false);
  }

  bool get _hasSelection => widget.selectedValue != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildField(),
        if (_isOpen) _buildPopup(),
      ],
    );
  }

  Widget _buildField() {
    return GestureDetector(
      onTap: _toggleOpen,
      child: Container(
        height: _fieldHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: _fieldHorizontalPadding,
          vertical: _fieldVerticalPadding,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(_fieldBorderRadius),
          boxShadow: const [
            BoxShadow(
              color: AppColors.gray300,
              blurRadius: _popupElevation,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _hasSelection ? widget.selectedValue! : widget.placeholder,
                style: AppTextStyles.body3Md16.copyWith(
                  color: _hasSelection ? AppColors.gray900 : AppColors.gray400,
                  height: 1.2,
                  letterSpacing: -0.051,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SvgPicture.asset(
              _isOpen ? AppIconAssets.arrowUp : AppIconAssets.arrowDown,
              width: _arrowIconWidth,
              height: _arrowIconHeight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopup() {
    return Container(
      margin: const EdgeInsets.only(top: _popupTopOffset),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(_popupBorderRadius),
        boxShadow: const [
          BoxShadow(
            color: AppColors.gray300,
            blurRadius: _popupElevation,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _popupHorizontalPadding,
          vertical: _popupVerticalPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.options
              .map((option) => _buildPopupItem(option))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildPopupItem(String option) {
    final isSelected = option == widget.selectedValue;
    final isLast = option == widget.options.last;

    return GestureDetector(
      onTap: () => _select(option),
      child: Padding(
        padding: EdgeInsets.only(bottom: isLast ? 0.0 : _popupItemGap),
        child: Text(
          option,
          style: AppTextStyles.body7B14.copyWith(
            color: isSelected ? AppColors.pink600 : AppColors.gray600,
            height: 1.2,
            letterSpacing: -0.039,
          ),
        ),
      ),
    );
  }
}
