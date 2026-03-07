import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../theme/app_colors.dart';
import '../../constants/app_icon_assets.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/app_spacing.dart';

// 상단 헤더 타입
enum MingoringBackHeaderType {
  none, // [뒤로가기]
  title, // [뒤로가기] + [타이틀]
  titleWithSave, // [뒤로가기] + [타이틀] + [저장]
  titleWithEdit, // [뒤로가기] + [타이틀] + [수정]
}

class MingoringBackHeader extends StatelessWidget {
  // none 타입, title 타입 전용
  const MingoringBackHeader({
    super.key,
    required this.onBack,
    this.type = MingoringBackHeaderType.none,
    this.text,
    this.backgroundColor = Colors.transparent,
    this.horizontalPadding =
        AppSpacing.buttonHorizontalPadding,
  })  : onActionPressed = null,
        assert(
          type != MingoringBackHeaderType.titleWithSave &&
              type != MingoringBackHeaderType.titleWithEdit,
          '액션 헤더는 MingoringBackHeader.actionSave() 또는 '
          'MingoringBackHeader.actionEdit()를 사용하세요.',
        );

  // titleWithSave 타입 전용
  const MingoringBackHeader.actionSave({
    super.key,
    required this.onBack,
    required String this.text,
    required VoidCallback this.onActionPressed,
    this.backgroundColor = Colors.transparent,
    this.horizontalPadding =
        AppSpacing.buttonHorizontalPadding,
  }) : type = MingoringBackHeaderType.titleWithSave;

  // titleWithEdit 타입 전용
  const MingoringBackHeader.actionEdit({
    super.key,
    required this.onBack,
    required String this.text,
    required VoidCallback this.onActionPressed,
    this.backgroundColor = Colors.transparent,
    this.horizontalPadding =
        AppSpacing.buttonHorizontalPadding,
  }) : type = MingoringBackHeaderType.titleWithEdit;

  final VoidCallback onBack; // 뒤로가기 콜백
  final MingoringBackHeaderType type; // 헤더 타입
  final String? text; // 타이틀 또는 액션 텍스트
  final VoidCallback? onActionPressed; // 우측 액션 버튼 클릭 콜백
  final Color backgroundColor; // 배경색
  final double horizontalPadding; // 가로 여백

  static const double _iconSize = 24.0;
  static const double _slotWidth = 48.0;

  @override
  Widget build(BuildContext context) {
    final isTransparent = backgroundColor == Colors.transparent;

    return Material(
      type: isTransparent ? MaterialType.transparency : MaterialType.canvas,
      color: isTransparent ? null : backgroundColor,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: kToolbarHeight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Row(
              children: [
                // ── Leading 슬롯 (고정 48px, 전체 영역 터치 가능) ──
                _buildLeading(),
                // ── Title 영역 (남은 공간, 중앙 정렬) ──
                Expanded(child: _buildTitle()),
                // ── Trailing 슬롯 (고정 48px, 전체 영역 터치 가능) ──
                _buildTrailing(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 좌측 고정 슬롯 — 뒤로가기 아이콘
  Widget _buildLeading() {
    return Semantics(
      button: true,
      label: 'Back',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onBack,
        child: SizedBox(
          width: _slotWidth,
          height: kToolbarHeight,
          child: Align(
            alignment: Alignment.centerLeft,
            child: SvgPicture.asset(
              AppIconAssets.arrowLeft,
              width: _iconSize,
              height: _iconSize,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  /// 중앙 타이틀 영역
  Widget _buildTitle() {
    if (type == MingoringBackHeaderType.title && text != null) {
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

  /// 우측 고정 슬롯 — 액션 텍스트 버튼
  Widget _buildTrailing() {
    final Color? actionColor = switch (type) {
      MingoringBackHeaderType.titleWithSave => AppColors.pink600,
      MingoringBackHeaderType.titleWithEdit => AppColors.gray700,
      _ => null,
    };

    if (actionColor != null && text != null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onActionPressed,
        child: SizedBox(
          width: _slotWidth,
          height: kToolbarHeight,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              text!,
              style: AppTextStyles.body7B14.copyWith(
                color: actionColor,
                height: 1.2,
              ),
            ),
          ),
        ),
      );
    }

    // 액션 없는 타입 — trailing 영역만 확보 (레이아웃 균형 유지)
    return const SizedBox(width: _slotWidth);
  }
}
