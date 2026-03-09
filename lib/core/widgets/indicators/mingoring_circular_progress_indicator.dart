import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// 밍고링 공통 로딩 스피너
class MingoringCircularProgressIndicator extends StatelessWidget {
  const MingoringCircularProgressIndicator({
    super.key,
    this.size = _defaultSize,
    this.strokeWidth = _defaultStrokeWidth,
  });

  static const double _defaultSize = 16.0;
  static const double _defaultStrokeWidth = 2.2;

  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        color: AppColors.pink600,
        backgroundColor: AppColors.pink300,
      ),
    );
  }
}
