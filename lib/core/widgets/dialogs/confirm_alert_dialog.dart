import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_logo_typography.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import '../buttons/mingoring_text_button.dart';

/// 확인/취소 두 버튼을 가진 확인 얼럿 다이얼로그
///
/// [cancelLabel]을 누르면 다이얼로그를 닫고 [onCancel]을 호출합니다.
/// [confirmLabel]을 누르면 다이얼로그를 닫고 [onConfirm]을 호출합니다.
class ConfirmAlertDialog extends StatelessWidget {
  const ConfirmAlertDialog({
    super.key,
    required this.title,
    required this.description,
    this.cancelLabel = 'Cancel',
    this.confirmLabel = 'Discard',
    this.onCancel,
    this.onConfirm,
  });

  static const double _borderRadius = 20.0;
  static const double _horizontalPadding = 21.0;
  static const double _topPadding = 50.0;
  static const double _bottomPadding = 25.0;
  static const double _textGap = 8.0;
  static const double _contentToButtonGap = 50.0;
  static const double _buttonGap = 18.0;

  final String title;
  final String description;
  final String cancelLabel;
  final String confirmLabel;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String description,
    String cancelLabel = 'Keep Editing',
    String confirmLabel = 'Discard',
    VoidCallback? onCancel,
    VoidCallback? onConfirm,
    Color barrierColor = AppColors.black70,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) {
    return showDialog<T>(
      context: context,
      barrierColor: barrierColor,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      builder: (_) => ConfirmAlertDialog(
        title: title,
        description: description,
        cancelLabel: cancelLabel,
        confirmLabel: confirmLabel,
        onCancel: onCancel,
        onConfirm: onConfirm,
      ),
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
        padding: const EdgeInsets.fromLTRB(
          _horizontalPadding,
          _topPadding,
          _horizontalPadding,
          _bottomPadding,
        ),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppLogoTypography.logoEb5.copyWith(
                color: AppColors.pink600,
              ),
            ),
            const SizedBox(height: _textGap),
            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTextStyles.body9Md14.copyWith(
                color: AppColors.gray500,
              ),
            ),
            const SizedBox(height: _contentToButtonGap),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MingoringTextButton(
            size: MingoringTextButtonSize.popup,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColors.gray400),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              onCancel?.call();
            },
            child: Text(cancelLabel),
          ),
        ),
        const SizedBox(width: _buttonGap),
        Expanded(
          child: MingoringTextButton(
            size: MingoringTextButtonSize.popup,
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm?.call();
            },
            child: Text(confirmLabel),
          ),
        ),
      ],
    );
  }
}
