import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_icon_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// 라이브러리 Edit 모드 하단 액션 바
///
/// Edit 버튼 활성화 시 하단에 표시되는 Delete / Change Status 두 버튼을 포함합니다.
/// 각 버튼은 독립적으로 활성화/비활성화할 수 있습니다.
///
/// - 활성화(enabled): pink600 배경, pink50 아이콘·텍스트
/// - 비활성화(disabled): pink500 배경, pink400 아이콘·텍스트
///
/// Example:
/// ```dart
/// LibraryEditActionBar(
///   isTrashEnabled: selectedItems.isNotEmpty,
///   isChangeEnabled: selectedItems.isNotEmpty,
///   onTrashTap: () { /* 삭제 로직 */ },
///   onChangeTap: () { /* 상태 변경 로직 */ },
/// )
/// ```
class LibraryEditActionBar extends StatelessWidget {
  const LibraryEditActionBar({
    super.key,
    required this.isTrashEnabled,
    required this.isChangeEnabled,
    this.onTrashTap,
    this.onChangeTap,
  });

  static const String _deleteLabel = 'Delete';
  static const String _changeStatusLabel = 'Change Status';

  static const BorderRadius _leftButtonBorderRadius = BorderRadius.only(
    topLeft: Radius.circular(_ActionTabButton._topRadius),
  );

  static const BorderRadius _rightButtonBorderRadius = BorderRadius.only(
    topRight: Radius.circular(_ActionTabButton._topRadius),
  );

  /// Trash 버튼 활성화 여부 (선택된 항목이 있을 때 true)
  final bool isTrashEnabled;

  /// Status change 버튼 활성화 여부 (선택된 항목이 있을 때 true)
  final bool isChangeEnabled;

  final VoidCallback? onTrashTap;
  final VoidCallback? onChangeTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildDeleteButton()),
        Expanded(child: _buildChangeStatusButton()),
      ],
    );
  }

  Widget _buildDeleteButton() {
    return _ActionTabButton(
      label: _deleteLabel,
      enabledIconAsset: AppIconAssets.trashEnable,
      disabledIconAsset: AppIconAssets.trashDisable,
      isEnabled: isTrashEnabled,
      borderRadius: _leftButtonBorderRadius,
      onTap: isTrashEnabled ? onTrashTap : null,
    );
  }

  Widget _buildChangeStatusButton() {
    return _ActionTabButton(
      label: _changeStatusLabel,
      enabledIconAsset: AppIconAssets.changeEnable,
      disabledIconAsset: AppIconAssets.changeDisable,
      isEnabled: isChangeEnabled,
      borderRadius: _rightButtonBorderRadius,
      onTap: isChangeEnabled ? onChangeTap : null,
    );
  }
}

class _ActionTabButton extends StatelessWidget {
  const _ActionTabButton({
    required this.label,
    required this.enabledIconAsset,
    required this.disabledIconAsset,
    required this.isEnabled,
    required this.borderRadius,
    this.onTap,
  });

  static const double _topRadius = 20.0;
  static const double _paddingTop = 20.0;
  static const double _paddingBottom = 35.0;
  static const double _iconSize = 20.0;
  static const double _iconLabelGap = 5.0;

  static const Color _enabledBackgroundColor = AppColors.pink600;
  static const Color _disabledBackgroundColor = AppColors.pink500;
  static const Color _enabledContentColor = AppColors.pink50;
  static const Color _disabledContentColor = AppColors.pink400;

  final String label;
  final String enabledIconAsset;
  final String disabledIconAsset;
  final bool isEnabled;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;

  String get _iconAsset => isEnabled ? enabledIconAsset : disabledIconAsset;

  Color get _backgroundColor =>
      isEnabled ? _enabledBackgroundColor : _disabledBackgroundColor;

  Color get _contentColor =>
      isEnabled ? _enabledContentColor : _disabledContentColor;

  TextStyle get _labelTextStyle =>
      AppTextStyles.detail7Md10.copyWith(color: _contentColor);

  EdgeInsets get _padding => const EdgeInsets.only(
        top: _paddingTop,
        bottom: _paddingBottom,
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: _padding,
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: borderRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              _iconAsset,
              width: _iconSize,
              height: _iconSize,
            ),
            const SizedBox(height: _iconLabelGap),
            Text(
              label,
              style: _labelTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
