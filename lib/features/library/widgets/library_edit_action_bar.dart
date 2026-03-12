import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_icon_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// 라이브러리 Edit 모드 하단 액션 바
///
/// Edit 버튼 활성화 시 하단에 표시되는 Trash / Status change 두 버튼을 포함합니다.
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
        Expanded(
          child: _TabButton(
            label: 'Trash',
            iconAsset: isTrashEnabled
                ? AppIconAssets.trashEnable
                : AppIconAssets.trashDisable,
            isEnabled: isTrashEnabled,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(_TabButton._topRadius),
            ),
            onTap: isTrashEnabled ? onTrashTap : null,
          ),
        ),
        Expanded(
          child: _TabButton(
            label: 'Status change',
            iconAsset: isChangeEnabled
                ? AppIconAssets.changeEnable
                : AppIconAssets.changeDisable,
            isEnabled: isChangeEnabled,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(_TabButton._topRadius),
            ),
            onTap: isChangeEnabled ? onChangeTap : null,
          ),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.iconAsset,
    required this.isEnabled,
    required this.borderRadius,
    this.onTap,
  });

  final String label;
  final String iconAsset;
  final bool isEnabled;
  final BorderRadius borderRadius;
  final VoidCallback? onTap;

  static const double _topRadius = 20.0;
  static const double _paddingTop = 14.0;
  static const double _paddingBottom = 35.0;
  static const double _iconSize = 20.0;
  static const double _iconLabelGap = 5.0;

  Color get _backgroundColor =>
      isEnabled ? AppColors.pink600 : AppColors.pink500;

  Color get _contentColor => isEnabled ? AppColors.pink50 : AppColors.pink400;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(
          top: _paddingTop,
          bottom: _paddingBottom,
        ),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: borderRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconAsset,
              width: _iconSize,
              height: _iconSize,
            ),
            const SizedBox(height: _iconLabelGap),
            Text(
              label,
              style: AppTextStyles.detail7Md10.copyWith(color: _contentColor),
            ),
          ],
        ),
      ),
    );
  }
}
