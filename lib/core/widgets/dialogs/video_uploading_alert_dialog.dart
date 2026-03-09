import 'package:flutter/material.dart';

import '../../constants/app_mingo_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_logo_typography.dart';
import '../../theme/app_text_styles.dart';
import '../indicators/mingoring_circular_progress_indicator.dart';
import 'mingoring_alert_dialog.dart';

/// 영상 생성(업로드) 진행 중 상태 팝업
///
/// 사용법:
/// ```dart
/// VideoUploadingAlertDialog.show(context);
/// ```
class VideoUploadingAlertDialog extends StatelessWidget {
  const VideoUploadingAlertDialog({
    super.key,
    this.onNextPressed,
  });

  final VoidCallback? onNextPressed;

  static const double _mingoWidth = 88.0;
  static const double _mingoHeight = 122.607;
  static const double _spinnerTopOffset = -2.0;
  static const double _spinnerRightOffset = 0.0;
  static const double _mingoToTextGap = 24.0;
  static const double _titleToDescriptionGap = 8.0;
  static const double _buttonTopGap = 24.0;

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onNextPressed,
  }) {
    return MingoringAlertDialog.show(
      context,
      builder: (_) => VideoUploadingAlertDialog(onNextPressed: onNextPressed),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MingoringAlertDialog(
      type: MingoringAlertDialogType.close,
      onButtonPressed: onNextPressed,
      buttonGap: _buttonTopGap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: _mingoWidth,
            height: _mingoHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: Image.asset(MingoAssets.idleWingsMain),
                ),
                const Positioned(
                  top: _spinnerTopOffset,
                  right: _spinnerRightOffset,
                  child: MingoringCircularProgressIndicator(),
                ),
              ],
            ),
          ),
          const SizedBox(height: _mingoToTextGap),
          Text(
            'Mingo\u2019s cooking...',
            style: AppLogoTypography.logoEb5.copyWith(color: AppColors.pink600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: _titleToDescriptionGap),
          Text(
            "You can leave the app.\nI'll send you a notification when it's done!",
            style: AppTextStyles.body9Md14.copyWith(
              color: AppColors.gray500,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
