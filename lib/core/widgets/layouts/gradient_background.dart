import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// 앱 공통 배경 그라데이션 (pink200 25%, white 60% 지점에서 전환, top-to-bottom).
class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key, required this.child});

  final Widget child;

  static const _gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.pink200, AppColors.white],
    stops: [0.25, 0.60],
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: const BoxDecoration(gradient: _gradient),
        child: child,
      ),
    );
  }
}
