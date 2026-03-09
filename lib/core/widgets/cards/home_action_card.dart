import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_icon_assets.dart';
import '../../theme/app_colors.dart';
import '../video/video_thumbnail.dart';
import '../../theme/app_logo_typography.dart';
import '../../theme/app_text_styles.dart';
import '../badges/day_of_the_week_badge.dart';

enum HomeActionCardType { bookmarks, goToLesson, calendar }

/// 홈 화면에서 사용하는 액션 카드 위젯 (3가지 타입)
///
/// - [HomeActionCard.bookmarks]: 북마크 수를 표시하는 카드
/// - [HomeActionCard.goToLesson]: 최근 학습 레슨으로 이동하는 카드
/// - [HomeActionCard.calendar]: 학습 연속 일수와 주간 뱃지를 보여주는 카드
///
/// 터치 중에만 배경색이 변하며 손을 떼면 원래 색으로 복귀합니다.
class HomeActionCard extends StatefulWidget {
  const HomeActionCard.bookmarks({
    super.key,
    required int bookmarkCount,
    VoidCallback? onTap,
  })  : _type = HomeActionCardType.bookmarks,
        _bookmarkCount = bookmarkCount,
        _lessonTitle = null,
        _lessonSubtitle = null,
        _videoTitle = null,
        _videoChannel = null,
        _thumbnailUrl = null,
        _streakDays = null,
        _weekBadges = null,
        _onTap = onTap;

  const HomeActionCard.goToLesson({
    super.key,
    required String title,
    required String subtitle,
    required String videoTitle,
    required String videoTime,
    String? thumbnailUrl,
    VoidCallback? onTap,
  })  : _type = HomeActionCardType.goToLesson,
        _bookmarkCount = null,
        _lessonTitle = title,
        _lessonSubtitle = subtitle,
        _videoTitle = videoTitle,
        _videoChannel = videoTime,
        _thumbnailUrl = thumbnailUrl,
        _streakDays = null,
        _weekBadges = null,
        _onTap = onTap;

  const HomeActionCard.calendar({
    super.key,
    required int streakDays,
    required List<DayOfWeekBadgeData> weekBadges,
    VoidCallback? onTap,
  })  : _type = HomeActionCardType.calendar,
        _bookmarkCount = null,
        _lessonTitle = null,
        _lessonSubtitle = null,
        _videoTitle = null,
        _videoChannel = null,
        _thumbnailUrl = null,
        _streakDays = streakDays,
        _weekBadges = weekBadges,
        _onTap = onTap;

  final HomeActionCardType _type;
  final int? _bookmarkCount;
  final String? _lessonTitle;
  final String? _lessonSubtitle;
  final String? _videoTitle;
  final String? _videoChannel; // videoTime (mm:ss 형식)
  final String? _thumbnailUrl;
  final int? _streakDays;
  final List<DayOfWeekBadgeData>? _weekBadges;
  final VoidCallback? _onTap;

  @override
  State<HomeActionCard> createState() => _HomeActionCardState();
}

class _HomeActionCardState extends State<HomeActionCard> {
  bool _isPressed = false;

  static const _borderRadius = BorderRadius.all(Radius.circular(20));
  static const _padding = EdgeInsets.symmetric(horizontal: 20, vertical: 19);
  static const _pressDuration = Duration(milliseconds: 80);

  Color get _normalColor => switch (widget._type) {
        HomeActionCardType.bookmarks ||
        HomeActionCardType.goToLesson =>
          AppColors.white,
        HomeActionCardType.calendar => AppColors.pink50,
      };

  Color get _pressedColor => switch (widget._type) {
        HomeActionCardType.bookmarks => AppColors.pink100,
        HomeActionCardType.goToLesson => AppColors.pink200,
        HomeActionCardType.calendar => AppColors.pink200,
      };

  List<BoxShadow> get _boxShadow => switch (widget._type) {
        HomeActionCardType.bookmarks => const [
            BoxShadow(color: AppColors.gray300, blurRadius: 5)
          ],
        HomeActionCardType.calendar => const [
            BoxShadow(color: AppColors.gray300, blurRadius: 5)
          ],
        HomeActionCardType.goToLesson => const [
            BoxShadow(color: AppColors.gray300, blurRadius: 5)
          ],
      };

  void _onTapDown(TapDownDetails _) => setState(() => _isPressed = true);

  void _onTapUp(TapUpDetails _) {
    setState(() => _isPressed = false);
    widget._onTap?.call();
  }

  void _onTapCancel() => setState(() => _isPressed = false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedContainer(
        duration: _pressDuration,
        padding: _padding,
        decoration: BoxDecoration(
          color: _isPressed ? _pressedColor : _normalColor,
          borderRadius: _borderRadius,
          boxShadow: _boxShadow,
        ),
        child: switch (widget._type) {
          HomeActionCardType.bookmarks => _BookmarksContent(
              count: widget._bookmarkCount!,
              isPressed: _isPressed,
            ),
          HomeActionCardType.goToLesson => _GoToLessonContent(
              title: widget._lessonTitle!,
              subtitle: widget._lessonSubtitle!,
              videoTitle: widget._videoTitle!,
              videoTime: widget._videoChannel!,
              thumbnailUrl: widget._thumbnailUrl,
              isPressed: _isPressed,
            ),
          HomeActionCardType.calendar => _CalendarContent(
              streakDays: widget._streakDays!,
              weekBadges: widget._weekBadges!,
            ),
        },
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────
// Bookmarks 콘텐츠
// ──────────────────────────────────────────────────────────────────

class _BookmarksContent extends StatelessWidget {
  const _BookmarksContent({required this.count, required this.isPressed});

  final int count;
  final bool isPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(AppIconAssets.bookmark, width: 16, height: 17),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Bookmarks',
              style: AppTextStyles.head6B18.copyWith(
                color: isPressed ? AppColors.pink600 : AppColors.gray900,
              ),
            ),
            Text(
              '$count expressions saved',
              style:
                  AppTextStyles.detail5Sb12.copyWith(color: AppColors.gray500),
            ),
          ],
        ),
        const Spacer(),
        SvgPicture.asset(AppIconAssets.arrowRight, width: 17, height: 17),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────
// Go to Lesson 콘텐츠
// ──────────────────────────────────────────────────────────────────

class _GoToLessonContent extends StatelessWidget {
  const _GoToLessonContent({
    required this.title,
    required this.subtitle,
    required this.videoTitle,
    required this.videoTime,
    required this.thumbnailUrl,
    required this.isPressed,
  });

  final String title;
  final String subtitle;
  final String videoTitle;
  final String videoTime;
  final String? thumbnailUrl;
  final bool isPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            SvgPicture.asset(AppIconAssets.lesson, width: 20, height: 20),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.head6B18.copyWith(
                      color: isPressed ? AppColors.pink600 : AppColors.gray900,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.detail5Sb12
                        .copyWith(color: AppColors.gray500),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(AppIconAssets.arrowRight, width: 17, height: 17),
          ],
        ),
        const SizedBox(height: 13),
        Row(
          children: [
            VideoThumbnail(
              size: VideoThumbnailSize.small,
              thumbnailUrl: thumbnailUrl,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    videoTitle,
                    style: AppTextStyles.detail4B12
                        .copyWith(color: AppColors.gray900),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    videoTime,
                    style: AppTextStyles.detail6Md12
                        .copyWith(color: AppColors.gray600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────
// Calendar 콘텐츠
// ──────────────────────────────────────────────────────────────────

class _CalendarContent extends StatelessWidget {
  const _CalendarContent({
    required this.streakDays,
    required this.weekBadges,
  });

  final int streakDays;
  final List<DayOfWeekBadgeData> weekBadges;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            SvgPicture.asset(AppIconAssets.fire, width: 17, height: 18),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${streakDays}days',
                  style: AppLogoTypography.logoB5
                      .copyWith(color: AppColors.pink600),
                ),
                Text(
                  'Continuous learning!',
                  style: AppTextStyles.detail5Sb12
                      .copyWith(color: AppColors.gray500),
                ),
              ],
            ),
            const Spacer(),
            SvgPicture.asset(AppIconAssets.arrowRight, width: 17, height: 17),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < weekBadges.length; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              DayOfTheWeekBadge(
                weekDay: weekBadges[i].weekDay,
                date: weekBadges[i].date,
                variant: weekBadges[i].variant,
              ),
            ],
          ],
        ),
      ],
    );
  }
}
