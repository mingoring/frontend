import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_mingo_assets.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/storage/memory_cache_service.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_logo_typography.dart';
import '../../../core/theme/app_text_styles.dart';
import '../widgets/day_of_the_week_badge.dart';
import '../widgets/home_action_card.dart';
import '../../../core/widgets/dialogs/error_alert_dialog.dart';
import '../../../core/widgets/dialogs/video_watch_alert_dialog.dart';
import '../../../core/widgets/layouts/gradient_background.dart';
import '../../../core/router/route_names.dart';
import '../../bookmarks/providers/bookmark_stats_provider.dart';
import '../constants/home_greeting_text_constants.dart';
import '../constants/home_constants.dart';
import '../providers/calendar_provider.dart';

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

  static const _weekBadgeCount = 4;
  static const _contentBottomPadding = 32.0;

  static List<DayOfWeekBadgeData> _buildWeekBadges({
    required DateTime today,
    required Set<DateTime> learnedDates,
  }) {
    final todayNormalized = DateTime(today.year, today.month, today.day);

    return List.generate(_weekBadgeCount, (i) {
      final date =
          todayNormalized.subtract(Duration(days: _weekBadgeCount - 1 - i));
      final DayBadgeVariant variant;
      if (learnedDates.contains(date)) {
        variant = DayBadgeVariant.completedDay;
      } else if (date == todayNormalized) {
        variant = DayBadgeVariant.incompletedToday;
      } else {
        variant = DayBadgeVariant.incompletedPastDay;
      }
      return DayOfWeekBadgeData(
        weekDay: DayOfWeek.values[date.weekday - 1],
        date: date.day.toString(),
        variant: variant,
      );
    });
  }

  static String _resolveGreetingText({
    required MemoryCacheService cacheService,
    required DateTime now,
  }) {
    final cachedText = cacheService.getGreetingTextCache(
      weekday: now.weekday,
      hour: now.hour,
    );
    if (cachedText != null) {
      return cachedText;
    }

    final greetingText = HomeGreetingTextConstants.resolve(now: now);
    unawaited(
      cacheService.saveGreetingTextCache(
        weekday: now.weekday,
        hour: now.hour,
        greetingText: greetingText,
      ),
    );
    return greetingText;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(recentCalendarProvider, (prev, next) {
      final wasError = prev is AsyncError;
      final isError = next is AsyncError;
      if (!wasError && isError) {
        next.whenOrNull(
          error: (e, _) {
            if (e is AppException) {
              ErrorAlertDialog.show(context, errorMessage: e.message);
            } else {
              ErrorAlertDialog.show(context);
            }
          },
        );
      }
    });


    final localStorage = ref.watch(localStorageServiceProvider).valueOrNull;
    final memoryCacheService = ref.watch(memoryCacheServiceProvider);
    final nickname = localStorage?.getNickname() ?? '-';
    final today = DateTime.now();
    final recentCalendarAsync = ref.watch(recentCalendarProvider);
    final learnedDates = recentCalendarAsync.valueOrNull?.learnedDates
            .map((date) => DateTime(date.year, date.month, date.day))
            .toSet() ??
        <DateTime>{};
    final streakDays = recentCalendarAsync.valueOrNull?.streakDays ?? 0;
    final greetingText = _resolveGreetingText(
      cacheService: memoryCacheService,
      now: today,
    );
    final bookmarkCount =
        ref.watch(bookmarkStatsProvider).valueOrNull?.count ?? 0;

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
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.homeContentHorizontalSpacing,
                    ),
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
                              streakDays: streakDays,
                              weekBadges: _buildWeekBadges(
                                today: today,
                                learnedDates: learnedDates,
                              ),
                              onTap: () => context.push(RouteNames.calendar),
                            ),
                          ),
                          const SizedBox(height: _cardSpacing),
                          HomeActionCard.goToLesson(
                            title: 'Go to Lesson',
                            subtitle: HomeConstants.goToLessonSubtitle,
                            videoTitle: HomeConstants.mockVideoTitle,
                            videoTime: HomeConstants.mockVideoTime,
                            thumbnailUrl: HomeConstants.mockThumbnailUrl,
                            onTap: () => VideoWatchAlertDialog.show(
                              context,
                              videoTitle: HomeConstants.mockVideoTitle,
                              originalText: HomeConstants.mockLearningTextKo,
                              translatedText: HomeConstants.mockLearningTextEn,
                            ),
                          ),
                          const SizedBox(height: _cardSpacing),
                          HomeActionCard.bookmarks(
                            bookmarkCount: bookmarkCount,
                            onTap: () async {
                              final result = await context.push<Object?>(
                                RouteNames.bookmarks,
                              );
                              if (!context.mounted) return;
                              if (result is Exception) {
                                ErrorAlertDialog.show(
                                  context,
                                  errorMessage: result is AppException
                                      ? result.message
                                      : 'Failed to load bookmark information.',
                                );
                              } else {
                                ref.invalidate(bookmarkStatsProvider);
                              }
                            },
                          ),
                          const SizedBox(height: _contentBottomPadding),
                        ],
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
