import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// 라이브러리 필터 옵션
enum LibraryFilterOption { all, uploading, inProgress, completed }

extension _LibraryFilterOptionLabel on LibraryFilterOption {
  String get label => switch (this) {
        LibraryFilterOption.all => 'All',
        LibraryFilterOption.uploading => 'Uploading',
        LibraryFilterOption.inProgress => 'In Progress',
        LibraryFilterOption.completed => 'Completed',
      };
}

/// 좌우 스크롤 가능한 단일 선택 필터 바
///
/// Usage:
/// ```dart
/// LibraryFilterBar(
///   selectedOption: LibraryFilterOption.all,
///   onSelected: (option) => setState(() => _selected = option),
/// )
/// ```
class LibraryFilterBar extends StatelessWidget {
  const LibraryFilterBar({
    super.key,
    required this.selectedOption,
    required this.onSelected,
  });

  final LibraryFilterOption selectedOption;
  final ValueChanged<LibraryFilterOption> onSelected;

  static const double _barHeight = 33.0;
  static const double _chipHeight = 27.0;
  static const double _chipHorizontalPadding = 12.0;
  static const double _chipVerticalPadding = 4.0;
  static const double _chipRadius = 20.0;
  static const double _gap = 6.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _barHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < LibraryFilterOption.values.length; i++) ...[
              _LibraryFilterChip(
                option: LibraryFilterOption.values[i],
                isSelected: LibraryFilterOption.values[i] == selectedOption,
                onTap: () => onSelected(LibraryFilterOption.values[i]),
                chipHeight: _chipHeight,
                chipHorizontalPadding: _chipHorizontalPadding,
                chipVerticalPadding: _chipVerticalPadding,
                chipRadius: _chipRadius,
              ),
              if (i < LibraryFilterOption.values.length - 1)
                const SizedBox(width: _gap),
            ],
          ],
        ),
      ),
    );
  }
}

class _LibraryFilterChip extends StatelessWidget {
  const _LibraryFilterChip({
    required this.option,
    required this.isSelected,
    required this.onTap,
    required this.chipHeight,
    required this.chipHorizontalPadding,
    required this.chipVerticalPadding,
    required this.chipRadius,
  });

  final LibraryFilterOption option;
  final bool isSelected;
  final VoidCallback onTap;
  final double chipHeight;
  final double chipHorizontalPadding;
  final double chipVerticalPadding;
  final double chipRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: chipHeight,
        padding: EdgeInsets.symmetric(
          horizontal: chipHorizontalPadding,
          vertical: chipVerticalPadding,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(
            color: isSelected ? AppColors.pink600 : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(chipRadius),
        ),
        child: Text(
          option.label,
          style: AppTextStyles.body8Sb14.copyWith(
            color: isSelected ? AppColors.pink600 : AppColors.gray400,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
