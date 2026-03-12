import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_icon_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// 동영상 학습 상태 선택 값
enum LibraryVideoStatus { inProgress, completed }

/// 동영상 상태 변경 바텀시트 (library feature 전용)
///
/// - 현재 상태 칩: pink600 border (선택됨)
/// - 미선택 상태 칩: gray400 border
/// - 다른 상태 칩 탭 시: 해당 칩 즉시 pink600으로 피드백 → 150ms 후 닫히고 [onStatusChanged] 호출
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
class LibraryStatusChangeBottomSheet extends StatefulWidget {
  const LibraryStatusChangeBottomSheet({
    super.key,
    required this.currentStatus,
    required this.onStatusChanged,
  });

  static const double _borderRadius = 20.0;

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

  @override
  State<LibraryStatusChangeBottomSheet> createState() =>
      _LibraryStatusChangeBottomSheetState();
}

class _LibraryStatusChangeBottomSheetState
    extends State<LibraryStatusChangeBottomSheet> {
  static const double _borderRadius = 20.0;
  static const double _closeIconSize = 13.0;
  static const double _closeIconTopPadding = 22.0;
  static const double _closeIconRightPadding = 21.0;
  static const double _contentTopSpacing = 11.0;
  static const double _contentHorizontalPadding = 31.0;
  static const double _titleChipGap = 35.0;
  static const double _bottomPadding = 80.0;
  static const double _chipGap = 8.0;
  static const Duration _tapFeedbackDelay = Duration(milliseconds: 150);

  LibraryVideoStatus? _tappedStatus;

  bool _isSelected(LibraryVideoStatus status) {
    if (_tappedStatus != null) return status == _tappedStatus;
    return status == widget.currentStatus;
  }

  void _onChipTap(LibraryVideoStatus tapped) {
    if (tapped == widget.currentStatus) return;
    setState(() => _tappedStatus = tapped);
    Future.delayed(_tapFeedbackDelay, () {
      if (!mounted) return;
      Navigator.of(context).pop();
      widget.onStatusChanged(tapped);
    });
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
                        isSelected: _isSelected(LibraryVideoStatus.inProgress),
                        onTap: () => _onChipTap(LibraryVideoStatus.inProgress),
                      ),
                      const SizedBox(width: _chipGap),
                      _StatusChip(
                        label: 'Completed',
                        isSelected: _isSelected(LibraryVideoStatus.completed),
                        onTap: () => _onChipTap(LibraryVideoStatus.completed),
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
            color: isSelected ? AppColors.pink600 : AppColors.gray400,
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
