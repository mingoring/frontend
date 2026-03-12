import 'package:flutter/material.dart';

import '../../constants/app_mingo_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_logo_typography.dart';
import '../../theme/app_text_styles.dart';
import 'mingoring_alert_dialog.dart';

/// 에러 팝업 다이얼로그
///
/// 사용법:
/// ```dart
/// ErrorAlertDialog.show(context, errorMessage: 'Network error.');
/// ErrorAlertDialog.show(context); // 기본 메시지 표시
/// ```
class ErrorAlertDialog extends StatelessWidget {
  const ErrorAlertDialog({super.key, this.errorMessage});

  final String? errorMessage;

  static const double _mingoWidth = 89.0;
  static const double _mingoHeight = 124.0;
  static const double _mingoTopSpace = 16.0;
  static const double _mingoToTextGap = 24.0;
  static const double _titleToMessageGap = 8.0;
  static const double _MessageToButtonGap = 24.0;

  String get _message {
    final firstLine = errorMessage ?? 'Something went wrong.';
    return '$firstLine\nIf the problem persists, contact us.';
  }

  static Future<void> show(BuildContext context, {String? errorMessage}) {
    return MingoringAlertDialog.show(
      context,
      builder: (_) => ErrorAlertDialog(errorMessage: errorMessage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MingoringAlertDialog(
      type: MingoringAlertDialogType.close,
      buttonGap: _MessageToButtonGap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: _mingoTopSpace),
          Image.asset(
            MingoAssets.idleWingsSad,
            width: _mingoWidth,
            height: _mingoHeight,
          ),
          const SizedBox(height: _mingoToTextGap),
          Text(
            'Oops!',
            style: AppLogoTypography.logoEb5.copyWith(
              color: AppColors.pink600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: _titleToMessageGap),
          Text(
            _message,
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
