import 'package:flutter/material.dart';

import '../../constants/app_mingo_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_logo_typography.dart';
import '../../theme/app_text_styles.dart';

// ─────────────────────────────────────────
// Enum
// ─────────────────────────────────────────

/// 바텀시트 위에 얹히는 오버레이의 상태
enum MingoringBottomSheetOverlayStatus { success, failure }

// ─────────────────────────────────────────
// Widget
// ─────────────────────────────────────────

/// 기존 바텀시트 콘텐츠 위에 반투명 상태 오버레이를 얹는 래퍼 위젯
///
/// - [overlayStatus]가 null이면 [child]를 그대로 표시합니다.
/// - [overlayStatus]가 설정되면 [child] 위에 반투명 레이어와 상태 내용(아이콘 + 텍스트)이 표시됩니다.
/// - [child]로 바텀시트의 루트 위젯을 전달하면, 해당 위젯 위에 오버레이가 자동으로 겹쳐집니다.
/// - [topInset]으로 오버레이 상단 시작 위치를 지정합니다.
///   바텀시트 상단에 X 닫기 버튼 row가 있다면 그 높이(= topPadding + iconSize)를 전달해
///   X 버튼이 오버레이에 가려지지 않고 그대로 보이고 탭됩니다.
///
/// 사용 예시:
/// ```dart
/// // X 버튼 row 높이 = closeIconTopPadding(22) + closeIconSize(13) = 35
/// MingoringBottomSheetStatusOverlay(
///   overlayStatus: _overlayStatus,      // null이면 오버레이 미표시
///   title: 'Video is being added!',
///   description: 'It may take a few minutes.',
///   topInset: 35.0,                     // X 버튼 row 높이만큼 오버레이 상단 제외
///   child: Container(
///     // 기존 바텀시트 콘텐츠 ...
///   ),
/// )
/// ```
class MingoringBottomSheetStatusOverlay extends StatelessWidget {
  const MingoringBottomSheetStatusOverlay({
    super.key,
    required this.child,
    this.overlayStatus,
    this.title,
    this.description,
    this.topInset = 0.0,
    this.overlayColor = AppColors.white70,
    this.overlayBorderRadius = const BorderRadius.vertical(
      top: Radius.circular(_defaultBorderRadius),
    ),
  });

  static const double _defaultBorderRadius = 20.0;
  static const Duration _fadeDuration = Duration(milliseconds: 220);

  /// 기존 바텀시트 콘텐츠 (Stack 하단 레이어)
  final Widget child;

  /// null이면 오버레이 미표시, non-null이면 해당 상태 오버레이 표시
  final MingoringBottomSheetOverlayStatus? overlayStatus;

  /// 오버레이 타이틀 텍스트 (null이면 기본값 "Something went wrong." 표시)
  final String? title;

  /// 오버레이 설명 텍스트 (null이면 기본값 표시)
  final String? description;

  /// 오버레이 상단에서 제외할 높이 (기본: 0)
  /// X 닫기 버튼 row가 있는 바텀시트에서는 해당 row 높이를 전달하세요.
  /// 예: closeIconTopPadding(22) + closeIconSize(13) = 35.0
  final double topInset;

  /// 오버레이 배경색 (기본: AppColors.white70 — 흰색 70% 불투명)
  final Color overlayColor;

  /// 바텀시트 모서리 반경과 맞추기 위한 borderRadius (기본: 상단 20px 라운드)
  final BorderRadius overlayBorderRadius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        // Positioned을 Stack 직접 자식으로 두어야 Stack이 child 크기로 결정된다.
        // AnimatedSwitcher를 non-positioned로 두면 Stack이 무한 확장되는 문제가 생긴다.
        Positioned(
          top: topInset,
          left: 0,
          right: 0,
          bottom: 0,
          child: AnimatedSwitcher(
            duration: _fadeDuration,
            child: overlayStatus != null
                ? _PartialOverlay(
                    key: ValueKey(overlayStatus),
                    status: overlayStatus!,
                    title: title,
                    description: description,
                    color: overlayColor,
                    borderRadius:
                        topInset > 0 ? BorderRadius.zero : overlayBorderRadius,
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// Private: overlay content
// ─────────────────────────────────────────

class _PartialOverlay extends StatelessWidget {
  const _PartialOverlay({
    super.key,
    required this.status,
    this.title,
    this.description,
    required this.color,
    required this.borderRadius,
  });

  static const double _iconSize = 60.0;
  static const double _iconTitleGap = 20.0;
  static const double _titleDescriptionGap = 6.0;
  static const double _horizontalPadding = 31.0;

  static const String _defaultTitle = 'Something went wrong.';
  static const String _defaultDescription =
      'Something went wrong.\nIf the issue continues, pleaase contact us.';

  final MingoringBottomSheetOverlayStatus status;
  final String? title;
  final String? description;
  final Color color;
  final BorderRadius borderRadius;

  String get _mingoAsset => switch (status) {
        MingoringBottomSheetOverlayStatus.success => MingoAssets.idleWingsSmile,
        MingoringBottomSheetOverlayStatus.failure => MingoAssets.idleMainSad,
      };

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: ColoredBox(
        color: color,
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: _horizontalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  _mingoAsset,
                  width: _iconSize,
                ),
                const SizedBox(height: _iconTitleGap),
                Text(
                  title ?? _defaultTitle,
                  textAlign: TextAlign.center,
                  style: AppLogoTypography.logoEb5.copyWith(
                    color: AppColors.pink600,
                  ),
                ),
                const SizedBox(height: _titleDescriptionGap),
                Text(
                  description ?? _defaultDescription,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body8Sb14.copyWith(
                    color: AppColors.gray700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
