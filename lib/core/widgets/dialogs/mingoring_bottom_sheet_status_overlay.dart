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

/// 기존 콘텐츠 위에 반투명 상태 오버레이를 덮는 래퍼 위젯
///
/// 동작:
/// - [overlayStatus]가 null이면 [child]만 표시한다.
/// - [overlayStatus]가 설정되면 [child] 위에 반투명 오버레이와 상태 내용(아이콘 + 텍스트)을 표시한다.
/// - 오버레이의 높이는 [child]의 높이를 그대로 따른다.
/// - 오버레이의 가로 폭은 부모의 좌우 여백과 무관하게 화면 전체 폭으로 확장한다.
///   즉, 세로는 유지하고 좌우만 화면 끝까지 확장하는 구조다.
///
/// 레이아웃 주의사항:
/// - `LayoutBuilder`로 부모의 가용 폭을 측정하고, `MediaQuery`로 화면 전체 폭을 구한다.
/// - 두 값의 차이를 절반씩 음수 offset 으로 보정해 오버레이가 화면 가득 채우도록 한다.
///   (바텀시트는 수평으로 중앙 배치되는 구조를 전제한다.)
/// - Stack 은 `clipBehavior: Clip.none` 으로 설정해 오버레이가 Stack 경계 밖으로
///   확장되더라도 클립되지 않는다.
/// - non-positioned child 인 [child]가 높이를 결정하므로,
///   세로 크기는 기존 child 레이아웃을 유지한다.
///
/// [topInset]:
/// - 오버레이 상단에서 제외할 높이
/// - 바텀시트 상단에 X 닫기 버튼 row 가 있다면 그 높이를 전달해,
///   해당 영역은 오버레이가 덮지 않도록 한다.
///
/// 사용 예시:
/// ```dart
/// MingoringBottomSheetStatusOverlay(
///   overlayStatus: _overlayStatus,
///   title: 'Video is being added!',
///   description: 'It may take a few minutes.',
///   topInset: 35.0,
///   child: Container(
///     width: double.infinity,
///     // 기존 바텀시트 콘텐츠...
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
    this.overlayColor = AppColors.white85,
    this.overlayBorderRadius = const BorderRadius.vertical(
      top: Radius.circular(_defaultBorderRadius),
    ),
  });

  static const double _defaultBorderRadius = 20.0;
  static const Duration _fadeDuration = Duration(milliseconds: 300);

  /// 기존 콘텐츠 (Stack 하단 레이어)
  final Widget child;

  /// null이면 오버레이 미표시, non-null이면 해당 상태 오버레이 표시
  final MingoringBottomSheetOverlayStatus? overlayStatus;

  /// 오버레이 타이틀 텍스트
  /// null이면 실패 기본 타이틀을 사용한다.
  final String? title;

  /// 오버레이 설명 텍스트
  /// null이면 실패 기본 설명을 사용한다.
  final String? description;

  /// 오버레이 상단에서 제외할 높이
  final double topInset;

  /// 오버레이 배경색
  final Color overlayColor;

  /// 오버레이 모서리 반경
  ///
  /// 일반적으로 바텀시트 상단 radius 와 맞춰 사용한다.
  final BorderRadius overlayBorderRadius;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        // 부모에 좌우 여백이 있어 constraints.maxWidth 가 화면 폭보다 좁을 수 있다.
        // 좌우 여백이 대칭적(바텀시트 기준)이라고 가정하고, 차이의 절반씩 음수 offset 으로 보정해
        // 오버레이가 항상 화면 전체 폭을 덮도록 한다.
        final horizontalInset =
            ((screenWidth - constraints.maxWidth) / 2).clamp(0.0, screenWidth);

        return Stack(
          clipBehavior: Clip.none,
          children: [
            child,
            Positioned(
              top: topInset,
              left: -horizontalInset,
              right: -horizontalInset,
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
                        borderRadius: topInset > 0
                            ? BorderRadius.zero
                            : overlayBorderRadius,
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        );
      },
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

  /// 오버레이 배경 높이는 유지한 채,
  /// 내용물만 상단에서 일정 간격 내려 시작하도록 하는 패딩
  ///
  /// AnimatedSwitcher 의 기본 layoutBuilder 는 내부에 Stack(alignment: center) 를 만들며,
  /// 비-positioned 자식에게 loose constraint(0 ~ screenWidth)를 전달한다.
  /// 루트를 SizedBox(width: double.infinity)로 감싸 가용 최대 폭을 강제한다.
  static const double _contentTopPadding = 20.0;

  static const double _iconSize = 60.0;
  static const double _iconTitleGap = 20.0;
  static const double _titleDescriptionGap = 6.0;
  static const double _horizontalPadding = 31.0;

  static const String _defaultTitle = 'Something went wrong.';
  static const String _defaultDescription =
      'If the issue continues, please contact us.';

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
    return SizedBox(
      width: double.infinity,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: ColoredBox(
          color: color,
          child: Padding(
            padding: const EdgeInsets.only(
              top: _contentTopPadding,
              left: _horizontalPadding,
              right: _horizontalPadding,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
