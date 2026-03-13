import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_icon_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../buttons/mingoring_text_button.dart';

/// 밍고링 공통 바텀시트 프레임
///
/// [primaryButtonText] / [secondaryButtonText] 로 두 버튼의 텍스트를 지정합니다.
/// - Primary 버튼: [onPrimaryPressed] 가 null 이면 비활성, null 이 아니면 활성됩니다.
/// - Secondary 버튼: 회색 스타일로 표시되며, 눌리면 시트를 닫고 [onSecondaryPressed] 를 호출합니다.
/// - [primaryButtonOnLeft] = false(기본): secondary(좌) | primary(우)
/// - [primaryButtonOnLeft] = true  : primary(좌) | secondary(우)
///
/// 사용 예시:
/// ```dart
/// MingoringBottomSheet.show(
///   context,
///   title: 'Delete Video',
///   subtitle: 'Are you sure you want to delete the selected video?',
///   primaryButtonText: 'Delete',
///   secondaryButtonText: 'Cancel',
///   onPrimaryPressed: () { /* delete logic */ },
/// );
/// ```
class MingoringBottomSheet extends StatelessWidget {
  const MingoringBottomSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.primaryButtonText,
    required this.secondaryButtonText,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.onClose,
    this.primaryButtonOnLeft = false,
  });

  static const double _borderRadius = 20.0;
  static const double _closeIconSize = 13.0;
  static const double _closeIconTopPadding = 22.0;
  static const double _closeIconRightPadding = 21.0;
  static const double _contentTopSpacing = 11.0;
  static const double _contentHorizontalPadding = 31.0;
  static const double _titleSubtitleGap = 15.0;
  static const double _subtitleButtonGap = 40.0;
  static const double _buttonGap = 5.0;
  static const double _bottomPadding = 40.0;

  static const double _titleHeight = 1.2;
  static const double _subtitleHeight = 1.4;

  static const Color _titleColor = AppColors.pink600;
  static const Color _subtitleColor = AppColors.gray700;
  static const Color _sheetBackgroundColor = AppColors.white;
  static const Color _defaultBarrierColor = AppColors.black50;

  static const ButtonStyle _secondaryButtonStyle = ButtonStyle(
    backgroundColor: WidgetStatePropertyAll(AppColors.gray400),
    overlayColor: WidgetStatePropertyAll(AppColors.white70),
  );

  /// 바텀시트 제목
  final String title;

  /// 바텀시트 부제목
  final String subtitle;

  /// 확인(primary) 버튼 텍스트
  final String primaryButtonText;

  /// 취소(secondary) 버튼 텍스트
  final String secondaryButtonText;

  /// 확인 버튼 콜백 — null 이면 버튼이 비활성(회색)
  final VoidCallback? onPrimaryPressed;

  /// 취소 버튼 추가 콜백 — null 이면 시트 닫기만 수행
  final VoidCallback? onSecondaryPressed;

  /// X 닫기 버튼 추가 콜백 — null 이면 시트 닫기만 수행
  final VoidCallback? onClose;

  /// true: primary 버튼 왼쪽, false(기본): primary 버튼 오른쪽
  final bool primaryButtonOnLeft;

  static const BorderRadius _sheetBorderRadius = BorderRadius.vertical(
        top: Radius.circular(_borderRadius),
      );

  static const EdgeInsets _contentHorizontalInsets = EdgeInsets.symmetric(
        horizontal: _contentHorizontalPadding,
      );
  static TextStyle get _titleTextStyle => AppTextStyles.head6B18.copyWith(
        color: _titleColor,
        height: _titleHeight,
      );

  static TextStyle get _subtitleTextStyle => AppTextStyles.body9Md14.copyWith(
        color: _subtitleColor,
        height: _subtitleHeight,
      );

  /// 바텀시트를 표시하는 편의 메서드
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String primaryButtonText,
    required String secondaryButtonText,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    VoidCallback? onClose,
    bool primaryButtonOnLeft = false,
    Color barrierColor = _defaultBarrierColor,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor,
      shape: const RoundedRectangleBorder(
        borderRadius: _sheetBorderRadius,
      ),
      builder: (_) => MingoringBottomSheet(
        title: title,
        subtitle: subtitle,
        primaryButtonText: primaryButtonText,
        secondaryButtonText: secondaryButtonText,
        onPrimaryPressed: onPrimaryPressed,
        onSecondaryPressed: onSecondaryPressed,
        onClose: onClose,
        primaryButtonOnLeft: primaryButtonOnLeft,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _sheetBackgroundColor,
        borderRadius: _sheetBorderRadius,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CloseButtonRow(
              iconSize: _closeIconSize,
              topPadding: _closeIconTopPadding,
              rightPadding: _closeIconRightPadding,
              onTap: () => _popThen(context, onClose),
            ),
            const SizedBox(height: _contentTopSpacing),
            Padding(
              padding: _contentHorizontalInsets,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: _titleTextStyle),
                  const SizedBox(height: _titleSubtitleGap),
                  Text(subtitle, style: _subtitleTextStyle),
                ],
              ),
            ),
            const SizedBox(height: _subtitleButtonGap),
            Padding(
              padding: _contentHorizontalInsets,
              child: _buildButtonRow(context),
            ),
            const SizedBox(height: _bottomPadding),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonRow(BuildContext context) {
    final primaryButton = _ActionButton(
      text: primaryButtonText,
      onPressed: onPrimaryPressed == null
          ? null
          : () => _popThen(context, onPrimaryPressed),
    );

    final secondaryButton = _ActionButton(
      text: secondaryButtonText,
      onPressed: () => _popThen(context, onSecondaryPressed),
      style: _secondaryButtonStyle,
    );

    final leftButton = primaryButtonOnLeft ? primaryButton : secondaryButton;
    final rightButton = primaryButtonOnLeft ? secondaryButton : primaryButton;

    return Row(
      children: [
        Expanded(child: leftButton),
        const SizedBox(width: _buttonGap),
        Expanded(child: rightButton),
      ],
    );
  }

  void _popThen(BuildContext context, VoidCallback? callback) {
    Navigator.of(context).pop();
    callback?.call();
  }
}

// ─────────────────────────────────────────
// Private helpers
// ─────────────────────────────────────────

class _CloseButtonRow extends StatelessWidget {
  const _CloseButtonRow({
    required this.iconSize,
    required this.topPadding,
    required this.rightPadding,
    required this.onTap,
  });

  final double iconSize;
  final double topPadding;
  final double rightPadding;
  final VoidCallback onTap;

  EdgeInsets get _iconPadding =>
      EdgeInsets.only(top: topPadding, right: rightPadding);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: _iconPadding,
            child: SvgPicture.asset(
              AppIconAssets.close,
              width: iconSize,
              height: iconSize,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.text,
    required this.onPressed,
    this.style,
  });

  final String text;
  final VoidCallback? onPressed;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return MingoringTextButton(
      onPressed: onPressed,
      size: MingoringTextButtonSize.small,
      style: style,
      child: Text(text),
    );
  }
}
