import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class MingoringInputSelectionChip extends StatelessWidget {
  const MingoringInputSelectionChip({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
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
}
