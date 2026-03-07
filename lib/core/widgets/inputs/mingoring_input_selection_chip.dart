import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

// 칩 사이즈 종류
enum InputSelectionChipSize {
  big,
  small,
}

class MingoringInputSelectionChip extends StatelessWidget {
  const MingoringInputSelectionChip({
    super.key,
    required this.size, // 칩 사이즈
    required this.label, // 표시할 텍스트 라벨
    required this.value, // 현재 선택 여부
    required this.onChanged, // 선택 상태 변경 콜백
  });

  final InputSelectionChipSize size;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    if (size == InputSelectionChipSize.big) {
      return _buildBigChip();
    } else {
      return _buildSmallChip();
    }
  }

  Widget _buildBigChip() {
    final borderColor = value ? AppColors.pink600 : AppColors.gray400;
    final textColor = value ? AppColors.pink600 : AppColors.black;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20.0),
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: borderColor),
          ),
          child: Text(
            label,
            style: AppTextStyles.body4B15.copyWith(
              color: textColor,
              height: 1.2,
              letterSpacing: -0.3,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildSmallChip() {
    final borderColor = value ? AppColors.pink600 : Colors.transparent;
    final textColor = value ? AppColors.pink600 : AppColors.gray400;

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(24.0),
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: BorderRadius.circular(24.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          height: 27.0,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: AppTextStyles.body8Sb14.copyWith(
                  color: textColor,
                  height: 1.2,
                  letterSpacing: -0.28,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
