import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

enum PlaybackSpeed {
  half(0.5, '0.5x'),
  threeQuarter(0.75, '0.75x'),
  normal(1.0, '1x'),
  onePointTwoFive(1.25, '1.25x'),
  onePointFive(1.5, '1.5x'),
  onePointSevenFive(1.75, '1.75x');

  const PlaybackSpeed(this.value, this.label);

  final double value;
  final String label;
}

/// 재생 속도 선택 팝업. PlayingBar 위에 오버레이로 표시됩니다.
///
/// 사용 예:
/// ```dart
/// Positioned(
///   left: 10,
///   bottom: PlayingBar.height,
///   child: PlayingSpeedPopup(
///     selectedSpeed: _selectedSpeed,
///     onSpeedSelected: (speed) {
///       setState(() {
///         _selectedSpeed = speed;
///         _showSpeedPopup = false;
///       });
///     },
///   ),
/// )
/// ```
class PlayingSpeedPopup extends StatelessWidget {
  const PlayingSpeedPopup({
    super.key,
    required this.selectedSpeed,
    required this.onSpeedSelected,
  });

  static const double _width = 87;
  static const double _height = 163;

  final PlaybackSpeed selectedSpeed;
  final ValueChanged<PlaybackSpeed> onSpeedSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _height,
      padding: const EdgeInsets.fromLTRB(15, 16, 7, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: AppColors.gray300, blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: PlaybackSpeed.values
            .map(
              (speed) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onSpeedSelected(speed),
                child: Text(
                  speed.label,
                  style: AppTextStyles.detail5Sb12.copyWith(
                    color: speed == selectedSpeed
                        ? AppColors.pink600
                        : AppColors.gray600,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
