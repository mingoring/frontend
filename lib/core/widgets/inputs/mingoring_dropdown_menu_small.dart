import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_icon_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

// 드롭다운 항목 모델
class InputSelectionOption {
  const InputSelectionOption({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

class MingoringDropdownMenuSmall extends StatefulWidget {
  const MingoringDropdownMenuSmall({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
  });

  final List<InputSelectionOption> options;
  final String selectedValue;
  final ValueChanged<String> onChanged;

  @override
  State<MingoringDropdownMenuSmall> createState() =>
      _MingoringDropdownMenuSmallState();
}

class _MingoringDropdownMenuSmallState
    extends State<MingoringDropdownMenuSmall> {
  bool _isOpen = false;

  static const double _chipHeight = 36.0;
  static const double _chipHorizontalPadding = 12.0;
  static const double _chipVerticalPadding = 8.0;
  static const double _chipGap = 12.0;
  static const double _chipBorderRadius = 20.0;
  static const double _arrowIconSize = 10.0;
  static const double _popupItemHeight = 27.0;
  static const double _popupVerticalPadding = 9.0;
  static const double _popupHorizontalPadding = 7.0;
  static const double _popupItemGap = 9.0;
  static const double _popupBorderRadius = 20.0;
  static const double _popupTopOffset = 4.0;
  static const double _popupElevation = 5.0;

  InputSelectionOption get _selectedOption => widget.options.firstWhere(
        (o) => o.value == widget.selectedValue,
        orElse: () => widget.options.first,
      );

  void _toggleOpen() {
    setState(() => _isOpen = !_isOpen);
  }

  void _select(String value) {
    widget.onChanged(value);
    setState(() => _isOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildChip(),
        if (_isOpen) _buildPopup(),
      ],
    );
  }

  Widget _buildChip() {
    return GestureDetector(
      onTap: _toggleOpen,
      child: Container(
        height: _chipHeight,
        padding: const EdgeInsets.symmetric(
          horizontal: _chipHorizontalPadding,
          vertical: _chipVerticalPadding,
        ),
        decoration: BoxDecoration(
          color: AppColors.pink50,
          borderRadius: BorderRadius.circular(_chipBorderRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedOption.label,
              style: AppTextStyles.detail2Sb13.copyWith(
                color: AppColors.pink600,
                height: 1.1,
                letterSpacing: -0.034,
              ),
            ),
            const SizedBox(width: _chipGap),
            SvgPicture.asset(
              _isOpen
                  ? AppIconAssets.arrowUpMiniPink
                  : AppIconAssets.arrowDownMiniPink,
              width: _arrowIconSize,
              height: _arrowIconSize,
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
          children: widget.options
              .map((option) => _buildPopupItem(option))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildPopupItem(InputSelectionOption option) {
    final isSelected = option.value == widget.selectedValue;
    return GestureDetector(
      onTap: () => _select(option.value),
      child: Container(
        height: _popupItemHeight,
        width: double.infinity,
        margin: option != widget.options.last
            ? const EdgeInsets.only(bottom: _popupItemGap)
            : null,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.pink100 : Colors.transparent,
          borderRadius: BorderRadius.circular(_chipBorderRadius),
        ),
        alignment: Alignment.center,
        child: Text(
          option.label,
          style: AppTextStyles.detail2Sb13.copyWith(
            color: isSelected ? AppColors.pink600 : AppColors.gray600,
            height: 1.1,
            letterSpacing: -0.034,
          ),
        ),
      ),
    );
  }
}
