import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_icon_assets.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_spacing.dart';

// 상단 AppBar 타입
enum MingoringBackHeaderType {
  none, // [뒤로가기]
  title, // [뒤로가기] + [타이틀]
  titleWithSave, // [뒤로가기] + [타이틀] + [저장]
  titleOnly, // [타이틀]
}

class MingoringAppBar extends StatelessWidget implements PreferredSizeWidget {
  // none 타입, title 타입 전용
  const MingoringAppBar({
    super.key,
    required VoidCallback this.onBack,
    this.type = MingoringBackHeaderType.none,
    this.text,
    this.backgroundColor = AppColors.white,
    this.horizontalPadding = AppSpacing.homeContentHorizontalSpacing,
  })  : onActionPressed = null,
        titleWidget = null,
        isActionEnabled = true,
        assert(
          type != MingoringBackHeaderType.titleWithSave &&
              type != MingoringBackHeaderType.titleOnly,
          '액션 헤더는 MingoringAppBar.actionSave()를 사용하세요. '
          'titleOnly는 MingoringAppBar.titleOnly()를 사용하세요.',
        );

  // titleOnly 타입 전용
  const MingoringAppBar.titleOnly({
    super.key,
    required String this.text,
    this.backgroundColor = AppColors.white,
    this.horizontalPadding = AppSpacing.homeContentHorizontalSpacing,
  })  : type = MingoringBackHeaderType.titleOnly,
        onBack = null,
        onActionPressed = null,
        titleWidget = null,
        isActionEnabled = true;

  // titleWithSave 타입 전용
  const MingoringAppBar.actionSave({
    super.key,
    required this.onBack,
    this.text,
    required VoidCallback this.onActionPressed,
    this.titleWidget,
    this.isActionEnabled = true,
    this.backgroundColor = AppColors.white,
    this.horizontalPadding = AppSpacing.homeContentHorizontalSpacing,
  }) : type = MingoringBackHeaderType.titleWithSave;

  final VoidCallback? onBack; // 뒤로가기 콜백 (titleOnly 타입은 null)
  final MingoringBackHeaderType type; // 헤더 타입
  final String? text; // 타이틀 텍스트
  final Widget? titleWidget; // 커스텀 타이틀 위젯 (text 대신 사용)
  final VoidCallback? onActionPressed; // 우측 액션 버튼 클릭 콜백
  final bool isActionEnabled; // Save 버튼 활성화 여부
  final Color backgroundColor; // 배경색
  final double horizontalPadding; // 좌우 여백

  static const double _iconSize = 24.0;
  static const double _slotWidth = 48.0;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final isTitleOnly = type == MingoringBackHeaderType.titleOnly;
    return AppBar(
      backgroundColor: backgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: kToolbarHeight,
      leadingWidth: isTitleOnly ? 0 : horizontalPadding + _slotWidth,
      centerTitle: true,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leading: _buildLeading(),
      title: _buildTitle(),
      actions: [_buildTrailing()],
    );
  }

  /// 좌측 슬롯 — 뒤로가기 아이콘
  Widget _buildLeading() {
    if (type == MingoringBackHeaderType.titleOnly) {
      return const SizedBox.shrink();
    }
    return Semantics(
      button: true,
      label: 'Back',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onBack,
        child: SizedBox(
          width: horizontalPadding + _slotWidth,
          height: kToolbarHeight,
          child: Padding(
            padding: EdgeInsets.only(left: horizontalPadding),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SvgPicture.asset(
                AppIconAssets.back,
                width: _iconSize,
                height: _iconSize,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 중앙 타이틀 영역
  Widget _buildTitle() {
    if (titleWidget != null) return titleWidget!;
    if (text != null &&
        (type == MingoringBackHeaderType.title ||
            type == MingoringBackHeaderType.titleOnly ||
            type == MingoringBackHeaderType.titleWithSave)) {
      return Text(
        text!,
        style: AppTextStyles.body7B14.copyWith(
          color: AppColors.black,
          height: 1.2,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
    return const SizedBox.shrink();
  }

  /// 우측 슬롯 — 액션 텍스트 버튼
  Widget _buildTrailing() {
    if (type == MingoringBackHeaderType.titleOnly) {
      return const SizedBox.shrink();
    }

    if (type == MingoringBackHeaderType.titleWithSave) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: isActionEnabled ? onActionPressed : null,
        child: SizedBox(
          width: horizontalPadding + _slotWidth,
          height: kToolbarHeight,
          child: Padding(
            padding: EdgeInsets.only(right: horizontalPadding),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Save',
                style: AppTextStyles.body7B14.copyWith(
                  color: isActionEnabled ? AppColors.pink600 : AppColors.gray400,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // 액션 없는 타입 — trailing 영역만 확보 (레이아웃 균형 유지)
    return SizedBox(width: horizontalPadding + _slotWidth);
  }
}
