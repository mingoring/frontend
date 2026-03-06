import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class MingoringIndicator extends StatelessWidget {
  const MingoringIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    this.activeColor = AppColors.pink600,
    this.inactiveColor = AppColors.gray300,
  });

  final int itemCount;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;

  static const _dotSize = 6.0;
  static const _spacing = 6.0;
  static const _selectedScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final isSelected = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: _spacing / 2),
          width: isSelected ? _dotSize * _selectedScale : _dotSize,
          height: _dotSize,
          decoration: BoxDecoration(
            color: isSelected ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(_dotSize / 2),
          ),
        );
      }),
    );
  }
}
