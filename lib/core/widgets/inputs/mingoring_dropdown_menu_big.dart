import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_icon_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// 카테고리 선택 등 전체 너비를 차지하는 드롭다운 메뉴 컴포넌트.
///
/// 팝업은 필드 아래 Overlay로 렌더링되어 레이아웃에 영향을 주지 않습니다.
/// 팝업의 너비는 [_popupWidth]로 고정되며 우측 정렬됩니다.
///
/// Example:
/// ```dart
/// MingoringDropdownMenuBig(
///   options: ['Account Inquiry', 'Feature Suggestion', 'Bug Report'],
///   selectedValue: _selected,
///   onChanged: (value) => setState(() => _selected = value),
///   placeholder: 'Please choose a category',
/// )
/// ```
class MingoringDropdownMenuBig extends StatefulWidget {
  const MingoringDropdownMenuBig({
    super.key,
    required this.options,
    required this.onChanged,
    this.selectedValue,
    this.placeholder = 'Please choose a category',
  });

  /// 드롭다운 항목 목록
  final List<String> options;

  /// 현재 선택된 값. null이면 placeholder를 표시합니다.
  final String? selectedValue;

  /// 항목 선택 시 호출되는 콜백
  final ValueChanged<String> onChanged;

  /// 선택 전에 표시되는 힌트 텍스트
  final String placeholder;

  @override
  State<MingoringDropdownMenuBig> createState() =>
      _MingoringDropdownMenuBigState();
}

class _MingoringDropdownMenuBigState extends State<MingoringDropdownMenuBig> {
  // ── 치수 상수 ──────────────────────────────────────────────────────────────
  static const double _fieldHeight = 50.0;
  static const double _fieldHorizontalPadding = 26.0;
  static const double _fieldVerticalPadding = 11.0;
  static const double _fieldBorderRadius = 20.0;
  static const double _arrowIconWidth = 10.0;
  static const double _arrowIconHeight = 16.0;

  static const double _popupWidth = 159.0;
  static const double _popupBorderRadius = 20.0;
  static const double _popupShadowBlur = 5.0;
  static const double _popupHorizontalPadding = 7.0;
  static const double _popupVerticalPadding = 14.0;
  static const double _popupItemGap = 10.0;
  static const double _popupTopMargin = 8.0;

  final _layerLink = LayerLink();
  final _overlayController = OverlayPortalController();

  // 부모 상태 갱신 전에 즉각 UI에 반영하기 위한 내부 선택값
  String? _localSelectedValue;

  @override
  void initState() {
    super.initState();
    _localSelectedValue = widget.selectedValue;
  }

  @override
  void didUpdateWidget(MingoringDropdownMenuBig oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedValue != widget.selectedValue) {
      _localSelectedValue = widget.selectedValue;
    }
  }

  bool get _isOpen => _overlayController.isShowing;
  bool get _hasSelection => _localSelectedValue != null;

  void _toggle() {
    if (_isOpen) {
      _overlayController.hide();
    } else {
      _overlayController.show();
    }
    setState(() {});
  }

  void _select(String value) {
    // 로컬 상태를 먼저 확정하여 필드에 즉각 반영
    setState(() => _localSelectedValue = value);
    // overlay 닫기와 외부 콜백은 현재 build 사이클이 끝난 뒤 실행
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _overlayController.hide();
        widget.onChanged(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TapRegion(
        onTapOutside: (_) {
          if (_isOpen) {
            _overlayController.hide();
            setState(() {});
          }
        },
        child: OverlayPortal(
          controller: _overlayController,
          overlayChildBuilder: (_) => _buildPopupOverlay(),
          child: _buildField(),
        ),
      ),
    );
  }

  Widget _buildField() {
    return GestureDetector(
      onTap: _toggle,
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
              blurRadius: _popupShadowBlur,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _hasSelection ? _localSelectedValue! : widget.placeholder,
                style: AppTextStyles.body3Md16.copyWith(
                  color:
                      _hasSelection ? AppColors.gray900 : AppColors.gray400,
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

  Widget _buildPopupOverlay() {
    return CompositedTransformFollower(
      link: _layerLink,
      showWhenUnlinked: false,
      targetAnchor: Alignment.bottomRight,
      followerAnchor: Alignment.topRight,
      offset: const Offset(0, _popupTopMargin),
      child: Align(
        alignment: Alignment.topRight,
        child: _buildPopup(),
      ),
    );
  }

  Widget _buildPopup() {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: _popupWidth,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.options
              .map((option) => _buildPopupItem(option))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildPopupItem(String option) {
    final isSelected = option == _localSelectedValue;
    final isLast = option == widget.options.last;
    return GestureDetector(
      onTap: () => _select(option),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.only(bottom: isLast ? 0.0 : _popupItemGap),
        child: Text(
          option,
          style: AppTextStyles.body7B14.copyWith(
            color: isSelected ? AppColors.pink600 : AppColors.gray600,
          ),
        ),
      ),
    );
  }
}
