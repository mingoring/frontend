import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class MingoringIndicator extends StatelessWidget {
  const MingoringIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    this.dotSize = 8.0,
    this.spacing = 8.0,
    this.selectedScale = 2.5,
    this.activeColor = AppColors.pink600,
    this.inactiveColor = AppColors.gray200,
  });

  final int itemCount;
  final int currentIndex;
  final double dotSize;
  final double spacing;
  final double selectedScale;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final isSelected = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          width: isSelected ? dotSize * selectedScale : dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            color: isSelected ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(dotSize / 2),
          ),
        );
      }),
    );
  }
}
