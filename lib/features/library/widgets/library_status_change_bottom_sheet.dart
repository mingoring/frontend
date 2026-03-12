import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_icon_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// 동영상 학습 상태 선택 값
enum LibraryVideoStatus { inProgress, completed }

/// 동영상 상태 변경 바텀시트 (library feature 전용)
///
/// 현재 상태를 강조 표시하며, 다른 상태 칩을 탭하면
/// [onStatusChanged] 를 호출하고 시트를 자동으로 닫습니다.
///
/// 사용 예시:
/// ```dart
/// LibraryStatusChangeBottomSheet.show(
///   context,
///   currentStatus: LibraryVideoStatus.inProgress,
///   onStatusChanged: (status) {
///     // status change logic
///   },
/// );
/// ```
class LibraryStatusChangeBottomSheet extends StatelessWidget {
  const LibraryStatusChangeBottomSheet({
    super.key,
    required this.currentStatus,
    required this.onStatusChanged,
  });

  static const double _borderRadius = 20.0;
  static const double _closeIconSize = 13.0;
  static const double _closeIconTopPadding = 22.0;
  static const double _closeIconRightPadding = 21.0;

  /// 피그마 기준: content top = 46, close icon row 높이 = 35 → 보정 11
  static const double _contentTopSpacing = 11.0;
  static const double _contentHorizontalPadding = 31.0;
  static const double _titleChipGap = 35.0;
  static const double _bottomPadding = 80.0;
  static const double _chipGap = 8.0;

  /// 현재 선택된 상태 (칩 강조 표시 기준)
  final LibraryVideoStatus currentStatus;

  /// 다른 상태 칩을 탭했을 때 호출되는 콜백
  final ValueChanged<LibraryVideoStatus> onStatusChanged;

  /// 상태 변경 바텀시트를 표시하는 편의 메서드
  static Future<T?> show<T>(
    BuildContext context, {
    required LibraryVideoStatus currentStatus,
    required ValueChanged<LibraryVideoStatus> onStatusChanged,
    Color barrierColor = AppColors.black50,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(_borderRadius),
        ),
      ),
      builder: (_) => LibraryStatusChangeBottomSheet(
        currentStatus: currentStatus,
        onStatusChanged: onStatusChanged,
      ),
    );
  }

  void _onChipTap(BuildContext context, LibraryVideoStatus tapped) {
    if (tapped == currentStatus) return;
    Navigator.of(context).pop();
    onStatusChanged(tapped);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(_borderRadius),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close button row — 상단 22px 여백 포함
            Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: _closeIconTopPadding,
                      right: _closeIconRightPadding,
                    ),
                    child: SvgPicture.asset(
                      AppIconAssets.close,
                      width: _closeIconSize,
                      height: _closeIconSize,
                    ),
                  ),
                ),
              ],
            ),
            // close icon row 높이(35) + 보정(11) = 46px → 타이틀 시작점
            const SizedBox(height: _contentTopSpacing),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: _contentHorizontalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Change the status',
                    style: AppTextStyles.head6B18.copyWith(
                      color: AppColors.pink600,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: _titleChipGap),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _StatusChip(
                        label: 'In Progress',
                        isSelected:
                            currentStatus == LibraryVideoStatus.inProgress,
                        onTap: () =>
                            _onChipTap(context, LibraryVideoStatus.inProgress),
                      ),
                      const SizedBox(width: _chipGap),
                      _StatusChip(
                        label: 'Completed',
                        isSelected:
                            currentStatus == LibraryVideoStatus.completed,
                        onTap: () =>
                            _onChipTap(context, LibraryVideoStatus.completed),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: _bottomPadding),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
// Private helper
// ─────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  static const double _height = 27.0;
  static const double _horizontalPadding = 12.0;
  static const double _verticalPadding = 4.0;
  static const double _borderRadius = 20.0;

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: _height,
        padding: const EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _verticalPadding,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(_borderRadius),
          border: Border.all(
            // 미선택 시 transparent border 로 레이아웃 유지
            color: isSelected ? AppColors.pink600 : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.body8Sb14.copyWith(
            color: isSelected ? AppColors.pink600 : AppColors.gray400,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
