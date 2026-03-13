import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_icon_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../buttons/mingoring_text_button.dart';

/// 밍고링 공통 바텀시트 프레임
///
/// [primaryButtonText] / [secondaryButtonText] 로 두 버튼의 텍스트를 지정합니다.
/// - Primary 버튼: [onPrimaryPressed] 가 null 이면 비활성(회색), null 이 아니면 활성(핑크).
/// - Secondary 버튼: 항상 회색. 눌리면 시트를 닫고 [onSecondaryPressed] 를 호출합니다.
/// - [primaryButtonOnLeft] = false(기본): secondary(좌) | primary(우) — Delete / Logout 패턴
/// - [primaryButtonOnLeft] = true  : primary(좌) | secondary(우) — Withdraw 패턴
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

  /// 피그마 기준 content top = 46, close icon row 높이 = 22(top) + 13(icon) = 35
  /// 나머지 11 을 SizedBox 로 보정해 총 46px 확보
  static const double _contentTopSpacing = 11.0;
  static const double _contentHorizontalPadding = 31.0;
  static const double _titleSubtitleGap = 3.0;
  static const double _textButtonGap = 20.0;
  static const double _buttonGap = 5.0;
  static const double _bottomPadding = 40.0;

  /// 바텀시트 제목 (핑크, Bold 18)
  final String title;

  /// 바텀시트 부제목 (회색, SemiBold 13)
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
    Color barrierColor = AppColors.black50,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(_borderRadius),
        ),
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
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(_borderRadius),
        ),
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
              onTap: () {
                Navigator.of(context).pop();
                onClose?.call();
              },
            ),
            const SizedBox(height: _contentTopSpacing),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: _contentHorizontalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.head6B18.copyWith(
                      color: AppColors.pink600,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: _titleSubtitleGap),
                  Text(
                    subtitle,
                    style: AppTextStyles.detail2Sb13.copyWith(
                      color: AppColors.gray500,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: _textButtonGap),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: _contentHorizontalPadding,
              ),
              child: _buildButtonRow(context),
            ),
            const SizedBox(height: _bottomPadding),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonRow(BuildContext context) {
    final primary = _PrimaryButton(
      text: primaryButtonText,
      onPressed: onPrimaryPressed == null
          ? null
          : () {
              Navigator.of(context).pop();
              onPrimaryPressed!();
            },
    );
    final secondary = _SecondaryButton(
      text: secondaryButtonText,
      onPressed: () {
        Navigator.of(context).pop();
        onSecondaryPressed?.call();
      },
    );

    return Row(
      children: [
        Expanded(child: primaryButtonOnLeft ? primary : secondary),
        const SizedBox(width: _buttonGap),
        Expanded(child: primaryButtonOnLeft ? secondary : primary),
      ],
    );
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.only(top: topPadding, right: rightPadding),
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

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.text, required this.onPressed});

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return MingoringTextButton(
      onPressed: onPressed,
      size: MingoringTextButtonSize.small,
      child: Text(text),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return MingoringTextButton(
      onPressed: onPressed,
      size: MingoringTextButtonSize.small,
      style: const ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.gray400),
        overlayColor: WidgetStatePropertyAll(AppColors.white70),
      ),
      child: Text(text),
    );
  }
}
