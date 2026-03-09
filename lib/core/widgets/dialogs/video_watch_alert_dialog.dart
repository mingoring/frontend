import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import 'mingoring_alert_dialog.dart';

/// 학습 영상 선택 후 Watch 액션을 수행하는 팝업
///
/// 사용법:
/// ```dart
/// VideoWatchAlertDialog.show(
///   context,
///   videoTitle: '...',
///   learningTextKo: '...',
///   learningTextEn: '...',
/// );
/// ```
class VideoWatchAlertDialog extends StatelessWidget {
  const VideoWatchAlertDialog({
    super.key,
    required this.videoTitle,
    required this.learningTextKo,
    required this.learningTextEn,
    this.onWatchPressed,
  });

  final String videoTitle;
  final String learningTextKo;
  final String learningTextEn;
  final VoidCallback? onWatchPressed;

  static const double _textToDividerGap = 15.0;
  static const double _dividerToLearningTextGap = 15.0;
  static const double _learningTextGap = 2.0;
  static const double _contentToButtonGap = 18.0;
  static const double _dividerHeight = 1.0;

  static Future<void> show(
    BuildContext context, {
    required String videoTitle,
    required String learningTextKo,
    required String learningTextEn,
    VoidCallback? onWatchPressed,
  }) {
    return MingoringAlertDialog.show(
      context,
      builder: (_) => VideoWatchAlertDialog(
        videoTitle: videoTitle,
        learningTextKo: learningTextKo,
        learningTextEn: learningTextEn,
        onWatchPressed: onWatchPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MingoringAlertDialog(
      type: MingoringAlertDialogType.watch,
      onButtonPressed: onWatchPressed,
      buttonGap: _contentToButtonGap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            videoTitle,
            style: AppTextStyles.body8Sb14.copyWith(
              color: AppColors.gray900,
              height: 1.2,
            ),
          ),
          const SizedBox(height: _textToDividerGap),
          const Divider(
            color: AppColors.gray300,
            height: _dividerHeight,
            thickness: _dividerHeight,
          ),
          const SizedBox(height: _dividerToLearningTextGap),
          Text(
            learningTextKo,
            style: AppTextStyles.body8Sb14.copyWith(
              color: AppColors.gray600,
              height: 1.2,
            ),
          ),
          const SizedBox(height: _learningTextGap),
          Text(
            learningTextEn,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.body8Sb14.copyWith(
              color: AppColors.gray400,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
