import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_logo_typography.dart';
import '../../constants/app_mingo_assets.dart';
import '../../theme/app_text_styles.dart';
import '../buttons/mingoring_text_button.dart';

/// 에러 팝업 다이얼로그
///
/// 사용법:
/// ```dart
/// ErrorPopup.show(context, errorMessage: 'Network error.');
/// ErrorPopup.show(context); // 기본 메시지 표시
/// ```
class ErrorPopup extends StatelessWidget {
  const ErrorPopup({super.key, this.errorMessage});

  final String? errorMessage;

  static const double _popupWidth = 360.0;
  static const double _borderRadius = 20.0;
  static const double _horizontalPadding = 27.0;
  static const double _verticalPadding = 28.0;
  static const double _mingoWidth = 89.0;
  static const double _mingoHeight = 124.0;
  static const double _mingoTopSpace = 16.0;
  static const double _mingoToTextGap = 24.0;
  static const double _titleToMessageGap = 8.0;
  static const double _messageToButtonGap = 45.0;

  static Future<void> show(BuildContext context, {String? errorMessage}) {
    return showDialog(
      context: context,
      barrierColor: AppColors.black70,
      builder: (_) => ErrorPopup(errorMessage: errorMessage),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firstLine =
        errorMessage != null ? errorMessage! : 'Something went wrong.';
    final message = '$firstLine\nIf the problem persists, contact us.';

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: _popupWidth,
        padding: const EdgeInsets.symmetric(
          horizontal: _horizontalPadding,
          vertical: _verticalPadding,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
        ),
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
              message,
              style: AppTextStyles.body9Md14.copyWith(
                color: AppColors.gray500,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: _messageToButtonGap),
            MingoringTextButton(
              size: MingoringTextButtonSize.popup,
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
