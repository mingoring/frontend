import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_mingo_assets.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_logo_typography.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/badges/day_of_the_week_badge.dart';
import '../../../core/widgets/cards/home_action_card.dart';
import '../../../core/widgets/layouts/gradient_background.dart';
import '../constants/home_greeting_text_constants.dart';
import '../constants/home_constants.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const _contentTopPaddingMin = 56.0;
  static const _contentTopPaddingMax = 92.0;
  static const _contentTopPaddingRatio = 0.12;
  static const _greetingToCalendarSpacing = 34.0;
  static const _cardSpacing = 16.0;
  static const _calendarCardWidth = 236.0;
  static const _mingoWidth = 174.0;
  static const _mingoHeight = 243.0;
  static const _mingoTopOffsetRatio = 0.25;
  static const _mingoRightOffset = -20.0;

  // 플레이스홀더 캘린더 데이터
  static const _weekBadges = [
    DayOfWeekBadgeData(
      weekDay: DayOfWeek.th,
      date: '22',
      variant: DayBadgeVariant.completedPastDay,
    ),
    DayOfWeekBadgeData(
      weekDay: DayOfWeek.fr,
      date: '23',
      variant: DayBadgeVariant.completedPastDay,
    ),
    DayOfWeekBadgeData(
      weekDay: DayOfWeek.sa,
      date: '24',
      variant: DayBadgeVariant.completedPastDay,
    ),
    DayOfWeekBadgeData(
      weekDay: DayOfWeek.su,
      date: '25',
      variant: DayBadgeVariant.completedToday,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nickname =
        ref.watch(localStorageServiceProvider).valueOrNull?.getNickname() ??
            '-';
    final greetingText = HomeGreetingTextConstants.resolve();

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final contentTopPadding =
                  _resolveContentTopPadding(constraints.maxHeight);
              final mingoTopOffset = contentTopPadding * _mingoTopOffsetRatio;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: mingoTopOffset,
                    right: _mingoRightOffset,
                    child: Image.asset(
                      MingoAssets.idleMainMain,
                      width: _mingoWidth,
                      height: _mingoHeight,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.homeContentHorizontalSpacing,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: contentTopPadding),
                          _GreetingSection(
                            nickname: nickname,
                            greetingText: greetingText,
                          ),
                          const SizedBox(height: _greetingToCalendarSpacing),
                          SizedBox(
                            width: _calendarCardWidth,
                            child: HomeActionCard.calendar(
                              streakDays: HomeConstants.mockStreakDays,
                              weekBadges: _weekBadges,
                            ),
                          ),
                          const SizedBox(height: _cardSpacing),
                          HomeActionCard.goToLesson(
                            title: 'Go to Lesson',
                            subtitle: HomeConstants.goToLessonSubtitle,
                            videoTitle: HomeConstants.mockVideoTitle,
                            videoTime: HomeConstants.mockVideoTime,
                            thumbnailUrl: HomeConstants.mockThumbnailUrl,
                          ),
                          const SizedBox(height: _cardSpacing),
                          HomeActionCard.bookmarks(
                            bookmarkCount: HomeConstants.mockBookmarkCount,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  static double _resolveContentTopPadding(double availableHeight) {
    final adaptive = availableHeight * _contentTopPaddingRatio;
    return adaptive
        .clamp(_contentTopPaddingMin, _contentTopPaddingMax)
        .toDouble();
  }
}

// ──────────────────────────────────────────────────────────────────
// 인사말 섹션
// ──────────────────────────────────────────────────────────────────

class _GreetingSection extends StatelessWidget {
  const _GreetingSection({
    required this.nickname,
    required this.greetingText,
  });

  final String nickname;
  final String greetingText;

  static const _nicknameStyle = AppLogoTypography.logoEb2;
  static const _nicknameFallbackStyle = AppLogoTypography.logoEb3;

  @override
  Widget build(BuildContext context) {
    final nicknameText = '$nickname!';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Hello,',
          style: AppTextStyles.head7Sb18.copyWith(
            color: AppColors.pink600,
          ),
        ),
        const SizedBox(height: 4),
        LayoutBuilder(
          builder: (context, constraints) {
            final style = _fitsInOneLine(
              context: context,
              text: nicknameText,
              style: _nicknameStyle,
              maxWidth: constraints.maxWidth,
            )
                ? _nicknameStyle
                : _nicknameFallbackStyle;

            return Text(
              nicknameText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style.copyWith(color: AppColors.pink600),
            );
          },
        ),
        const SizedBox(height: 11),
        Text(
          greetingText,
          style: AppTextStyles.head4Sb20.copyWith(
            color: AppColors.gray500,
          ),
        ),
      ],
    );
  }

  static bool _fitsInOneLine({
    required BuildContext context,
    required String text,
    required TextStyle style,
    required double maxWidth,
  }) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    )..layout(maxWidth: maxWidth);

    final fits = !painter.didExceedMaxLines;
    painter.dispose();
    return fits;
  }
}
