import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

/// 하단 토스트 메시지 컴포넌트.
///
/// Flutter의 [ScaffoldMessenger]와 [SnackBar]를 기반으로
/// 디자인 시스템(AppColors, AppTextStyles)을 적용합니다.
///
/// 사용 예시:
/// ```dart
/// MingoringToast.show(context, message: 'Copied to clipboard!');
///
/// // 표시 시간 커스텀:
/// MingoringToast.show(
///   context,
///   message: 'Saved!',
///   duration: const Duration(seconds: 3),
/// );
/// ```
abstract final class MingoringToast {
  static const Duration _defaultDuration = Duration(seconds: 2);
  static const double _borderRadius = 12.0;
  static const EdgeInsets _contentPadding = EdgeInsets.symmetric(
    horizontal: 20.0,
    vertical: 14.0,
  );
  static const double _margin = 24.0;

  /// 하단 토스트를 표시합니다.
  ///
  /// - [message]: 표시할 문구
  /// - [duration]: 토스트 표시 시간 (기본 2초)
  static void show(
    BuildContext context, {
    required String message,
    Duration duration = _defaultDuration,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.body9Md14.copyWith(color: AppColors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: AppColors.gray900,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        margin: EdgeInsets.only(
          left: _margin,
          right: _margin,
          bottom: _margin,
        ),
        padding: _contentPadding,
      ),
    );
  }
}
