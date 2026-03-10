import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../buttons/mingoring_text_button.dart';
import '../buttons/mingoring_watch_button.dart';

/// 다이얼로그 하단 버튼 타입
enum MingoringAlertDialogType { close, watch }

/// 밍고링 공통 얼럿 다이얼로그 프레임
///
/// [type]에 따라 하단에 해당 타입의 버튼이 자동으로 추가된다.
class MingoringAlertDialog extends StatelessWidget {
  const MingoringAlertDialog({
    super.key,
    required this.child,
    required this.type,
    this.onButtonPressed,
    this.buttonGap = _defaultButtonGap,
    this.padding = const EdgeInsets.symmetric(
      horizontal: _defaultHorizontalPadding,
      vertical: _defaultVerticalPadding,
    ),
  });

  static const double _defaultBorderRadius = 20.0;
  static const double _defaultHorizontalPadding = 27.0;
  static const double _defaultVerticalPadding = 28.0;
  static const double _defaultButtonGap = 24.0;

  final Widget child;
  final MingoringAlertDialogType type;
  final VoidCallback? onButtonPressed;
  final double buttonGap;
  final EdgeInsetsGeometry padding;

  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    Color barrierColor = AppColors.black70,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) {
    return showDialog<T>(
      context: context,
      builder: builder,
      barrierColor: barrierColor,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.alertDialogHorizontalSpacing,
        vertical: 24.0,
      ),
      child: Container(
        width: double.infinity,
        padding: padding,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(_defaultBorderRadius)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            child,
            SizedBox(height: buttonGap),
            _buildButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return switch (type) {
      MingoringAlertDialogType.close => MingoringTextButton(
          size: MingoringTextButtonSize.popup,
          onPressed: () {
            Navigator.of(context).pop();
            onButtonPressed?.call();
          },
          child: const Text('Close'),
        ),
      MingoringAlertDialogType.watch => SizedBox(
          width: double.infinity,
          child: MingoringWatchButton(
            size: MingoringWatchButtonSize.big,
            onPressed: () {
              Navigator.of(context).pop();
              onButtonPressed?.call();
            },
          ),
        ),
    };
  }
}
