import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_icon_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/badges/mingoring_badge.dart';
import '../../../core/widgets/indicators/mingoring_circular_progress_indicator.dart';
import '../../../core/widgets/video/video_thumbnail.dart';

/// 라이브러리 목록 카드 상태
enum LibraryListCardStatus { uploading, inProgress, completed }

/// 라이브러리 목록 카드 위젯
///
/// 업로드 중 / 진행 중 / 완료 상태
/// - [LibraryListCardStatus.uploading]
/// - [LibraryListCardStatus.inProgress]
/// - [LibraryListCardStatus.completed]
///
/// Edit 버튼 활성화 시 [isSelectable]을 true로 설정하면 선택 모드가 활성화됩니다.
/// - [isSelectable] == false: 그림자
/// - [isSelectable] == true && [isSelected] == false: gray400 테두리, 빈 체크박스 아이콘
/// - [isSelectable] == true && [isSelected] == true: pink600 테두리, 채워진 체크박스 아이콘
class LibraryListCard extends StatelessWidget {
  const LibraryListCard({
    super.key,
    required this.width,
    required this.status,
    required this.title,
    required this.videoTime,
    this.thumbnailUrl,

    /// inProgress 상태에서 0.0 ~ 1.0 사이의 진행률
    /// completed 상태에서는 자동으로 1.0 처리됨
    this.progressRatio = 0.0,
    this.onTap,

    /// Edit 버튼 활성화 시 선택 모드 여부
    this.isSelectable = false,

    /// [isSelectable]이 true일 때 선택 여부
    this.isSelected = false,
  }) : assert(
          progressRatio >= 0.0 && progressRatio <= 1.0,
          'progressRatio must be between 0.0 and 1.0',
        );

  final double width;
  final LibraryListCardStatus status;
  final String title;
  final String videoTime;
  final String? thumbnailUrl;
  final double progressRatio;
  final VoidCallback? onTap;
  final bool isSelectable;
  final bool isSelected;

  static const double _cardPaddingH = 14.0;
  static const double _cardPaddingV = 17.0;
  static const double _cardRadius = 20.0;
  static const double _itemGap = 11.0;
  static const double _textGap = 4.0;
  static const double _checkboxSize = 24.0;
  static const double _checkboxRight = -4.0;
  static const double _checkboxTop = -7.0;

  /// 선택 모드이면서 uploading 상태가 아닐 때만 true
  bool get _isActuallySelectable =>
      isSelectable && status != LibraryListCardStatus.uploading;

  Color get _backgroundColor {
    if (_isActuallySelectable && isSelected) {
      return AppColors.pink200;
    }
    if (status == LibraryListCardStatus.uploading) {
      return AppColors.pink100;
    }
    return AppColors.white;
  }

  /// 그림자 (isSelectable = false 일 때 적용)
  List<BoxShadow>? get _boxShadow {
    if (isSelectable) {
      return null;
    }
    return const [
      BoxShadow(
        color: AppColors.gray300,
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ];
  }

  /// 테두리
  Color get _borderColor =>
      isSelected ? AppColors.pink600 : AppColors.gray400;

  MingoringBadgeColor get _badgeColor => switch (status) {
        LibraryListCardStatus.uploading => MingoringBadgeColor.lightPink,
        LibraryListCardStatus.inProgress => MingoringBadgeColor.darkPink,
        LibraryListCardStatus.completed => MingoringBadgeColor.pink,
      };

  String get _badgeLabel => switch (status) {
        LibraryListCardStatus.uploading => 'Uploading',
        LibraryListCardStatus.inProgress => 'In Progress',
        LibraryListCardStatus.completed => 'Completed',
      };

  double get _thumbnailWidth => width - (_cardPaddingH * 2);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(
          horizontal: _cardPaddingH,
          vertical: _cardPaddingV,
        ),
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(_cardRadius),
          border: _isActuallySelectable
              ? Border.all(color: _borderColor, width: 1)
              : null,
          boxShadow: _boxShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumbnail(),
            const SizedBox(height: _itemGap),
            _buildBadgeRow(),
            const SizedBox(height: _itemGap),
            _buildTextSection(),
          ],
        ),
      ),
    );
  }

  /// 썸네일 + 진행 중/완료 상태일 때 하단 진행 바 오버레이
  /// 선택 모드일 때 우측 상단 체크박스 아이콘 오버레이
  Widget _buildThumbnail() {
    final showProgressBar = status == LibraryListCardStatus.inProgress ||
        status == LibraryListCardStatus.completed;
    final ratio =
        status == LibraryListCardStatus.completed ? 1.0 : progressRatio;

    if (!showProgressBar && !_isActuallySelectable) {
      return VideoThumbnail(
        size: VideoThumbnailSize.big,
        thumbnailUrl: thumbnailUrl,
        width: _thumbnailWidth,
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        VideoThumbnail(
          size: VideoThumbnailSize.big,
          thumbnailUrl: thumbnailUrl,
          width: _thumbnailWidth,
        ),
        if (showProgressBar)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _VideoProgressBar(ratio: ratio),
          ),
        if (_isActuallySelectable)
          Positioned(
            right: _checkboxRight,
            top: _checkboxTop,
            child: SvgPicture.asset(
              isSelected
                  ? AppIconAssets.check2True1
                  : AppIconAssets.check2None,
              width: _checkboxSize,
              height: _checkboxSize,
            ),
          ),
      ],
    );
  }

  /// 배지 + uploading 상태일 때 로딩 스피너
  Widget _buildBadgeRow() {
    final badge = MingoringBadge(
      label: Text(_badgeLabel),
      size: MingoringBadgeSize.small,
      badgeColor: _badgeColor,
    );

    if (status == LibraryListCardStatus.uploading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          badge,
          const SizedBox(width: 8),
          const MingoringCircularProgressIndicator(),
        ],
      );
    }

    return badge;
  }

  /// 타이틀(2줄) + 재생 시간
  Widget _buildTextSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: AppTextStyles.detail4B12.copyWith(color: AppColors.gray900),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: _textGap),
        Text(
          videoTime,
          style: AppTextStyles.detail7Md10.copyWith(color: AppColors.gray600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

/// 비디오 썸네일 위에 오버레이되는 재생 진행 바
class _VideoProgressBar extends StatelessWidget {
  const _VideoProgressBar({required this.ratio});

  /// 0.0 ~ 1.0
  final double ratio;

  static const double _height = 3.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final filledWidth = constraints.maxWidth * ratio.clamp(0.0, 1.0);
          return Stack(
            children: [
              Container(
                height: _height,
                color: AppColors.gray300,
              ),
              Container(
                width: filledWidth,
                height: _height,
                color: AppColors.pink600,
              ),
            ],
          );
        },
      ),
    );
  }
}
