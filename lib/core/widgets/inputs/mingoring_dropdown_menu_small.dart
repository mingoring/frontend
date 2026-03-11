import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_icon_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// 드롭다운 항목 모델
class InputSelectionOption {
  const InputSelectionOption({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

/// 정렬 필터 등 소형 칩 스타일의 드롭다운 메뉴 컴포넌트.
///
/// 선택 상태는 호출부에서 [value]로 제어하는 controlled 컴포넌트입니다.
/// 항목 선택 시 [onChanged]가 호출되고, 호출부에서 [value]를 갱신해야 합니다.
/// 선택된 항목은 `pink100` 배경으로 강조 표시됩니다.
///
/// Example:
/// ```dart
/// MingoringDropdownMenuSmall(
///   options: const [
///     InputSelectionOption(label: 'Newest', value: 'NEWEST'),
///     InputSelectionOption(label: 'Oldest', value: 'OLDEST'),
///   ],
///   initialValue: 'NEWEST',
///   onChanged: (value) { /* API 재호출 등 */ },
/// )
/// ```
class MingoringDropdownMenuSmall extends StatefulWidget {
  const MingoringDropdownMenuSmall({
    super.key,
    required this.options,
    required this.onChanged,
    required this.value,
  }) : assert(options.isNotEmpty, 'options must not be empty');

  /// 드롭다운 항목 목록
  final List<InputSelectionOption> options;

  /// 현재 선택된 값. [options] 중 하나의 value 여야 합니다.
  final String value;

  /// 항목 선택 시 호출되는 콜백
  final ValueChanged<String> onChanged;

  @override
  State<MingoringDropdownMenuSmall> createState() =>
      _MingoringDropdownMenuSmallState();
}

class _MingoringDropdownMenuSmallState
    extends State<MingoringDropdownMenuSmall> {
  // ── 치수 상수 ──────────────────────────────────────────────────────────────
  static const double _chipHeight = 36.0;
  static const double _chipHorizontalPadding = 12.0;
  static const double _chipVerticalPadding = 8.0;
  static const double _chipGap = 12.0;
  static const double _chipBorderRadius = 20.0;
  static const double _arrowIconSize = 10.0;

  static const double _popupBorderRadius = 20.0;
  static const double _popupShadowBlur = 5.0;
  static const double _popupHorizontalPadding = 7.0;
  static const double _popupVerticalPadding = 9.0;
  static const double _popupItemHeight = 27.0;
  static const double _popupItemWidth = 63.0;
  static const double _popupItemBorderRadius = 20.0;
  static const double _popupItemGap = 9.0;
  static const double _popupTopMargin = 4.0;

  final _layerLink = LayerLink();
  final _overlayController = OverlayPortalController();

  String _localSelectedValue = '';

  @override
  void initState() {
    super.initState();
    _localSelectedValue = widget.value;
  }

  @override
  void didUpdateWidget(MingoringDropdownMenuSmall oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _localSelectedValue = widget.value;
    }
  }

  bool get _isOpen => _overlayController.isShowing;

  InputSelectionOption get _selectedOption => widget.options.firstWhere(
        (o) => o.value == _localSelectedValue,
        orElse: () => widget.options.first,
      );

  void _toggle() {
    setState(() {
      if (_isOpen) {
        _overlayController.hide();
      } else {
        _overlayController.show();
      }
    });
  }

  void _select(String value) {
    setState(() {
      _localSelectedValue = value;
      _overlayController.hide();
    });
    widget.onChanged(value);
  }

  void _closeIfOpen() {
    if (_isOpen) {
      setState(() => _overlayController.hide());
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: OverlayPortal(
        controller: _overlayController,
        overlayChildBuilder: (_) => _buildPopupOverlay(),
        child: _buildChip(),
      ),
    );
  }

  Widget _buildChip() {
    return GestureDetector(
      onTap: _toggle,
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

  Widget _buildPopupOverlay() {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: _closeIfOpen,
            behavior: HitTestBehavior.translucent,
          ),
        ),
        CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(0, _popupTopMargin),
          child: Align(
            alignment: Alignment.topLeft,
            child: _buildPopup(),
          ),
        ),
      ],
    );
  }

  Widget _buildPopup() {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(_popupBorderRadius),
          boxShadow: const [
            BoxShadow(
              color: AppColors.gray300,
              blurRadius: _popupShadowBlur,
            ),
          ],
        ),
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
    final isSelected = option.value == _localSelectedValue;
    final isLast = option == widget.options.last;
    return GestureDetector(
      onTap: () => _select(option.value),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: _popupItemHeight,
        width: _popupItemWidth,
        margin: isLast ? null : const EdgeInsets.only(bottom: _popupItemGap),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.pink100 : Colors.transparent,
          borderRadius: BorderRadius.circular(_popupItemBorderRadius),
        ),
        alignment: Alignment.center,
        child: Text(
          option.label,
          style: AppTextStyles.detail2Sb13.copyWith(
            color: isSelected ? AppColors.pink600 : AppColors.gray600,
          ),
        ),
      ),
    );
  }
}
