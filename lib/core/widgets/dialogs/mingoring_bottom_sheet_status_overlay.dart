import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_icon_assets.dart';
import '../../theme/app_colors.dart';
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
///   subtitle: 'It may take a few minutes.',
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
    this.subtitle,
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

  /// 오버레이 타이틀 텍스트
  final String? title;

  /// 오버레이 서브타이틀 텍스트 (선택)
  final String? subtitle;

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
        AnimatedSwitcher(
          duration: _fadeDuration,
          child: overlayStatus != null
              ? _PartialOverlay(
                  key: ValueKey(overlayStatus),
                  status: overlayStatus!,
                  title: title ?? '',
                  subtitle: subtitle,
                  topInset: topInset,
                  color: overlayColor,
                  borderRadius: overlayBorderRadius,
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// Private: overlay layer (topInset 이하 영역만 커버)
// ─────────────────────────────────────────

class _PartialOverlay extends StatelessWidget {
  const _PartialOverlay({
    super.key,
    required this.status,
    required this.title,
    this.subtitle,
    required this.topInset,
    required this.color,
    required this.borderRadius,
  });

  static const double _iconSize = 60.0;
  static const double _iconTitleGap = 20.0;
  static const double _titleSubtitleGap = 6.0;
  static const double _horizontalPadding = 31.0;

  final MingoringBottomSheetOverlayStatus status;
  final String title;
  final String? subtitle;
  final double topInset;
  final Color color;
  final BorderRadius borderRadius;

  String get _iconAsset => switch (status) {
        MingoringBottomSheetOverlayStatus.success => AppIconAssets.check2True1,
        MingoringBottomSheetOverlayStatus.failure => AppIconAssets.check2False,
      };

  Color get _titleColor => switch (status) {
        MingoringBottomSheetOverlayStatus.success => AppColors.pink600,
        MingoringBottomSheetOverlayStatus.failure => AppColors.gray900,
      };

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: topInset,
      left: 0,
      right: 0,
      bottom: 0,
      child: ClipRRect(
        borderRadius: topInset > 0
            ? BorderRadius.zero
            : borderRadius,
        child: ColoredBox(
          color: color,
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: _horizontalPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    _iconAsset,
                    width: _iconSize,
                    height: _iconSize,
                  ),
                  const SizedBox(height: _iconTitleGap),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.head6B18.copyWith(
                      color: _titleColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: _titleSubtitleGap),
                    Text(
                      subtitle!,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.detail2Sb13.copyWith(
                        color: AppColors.gray500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
