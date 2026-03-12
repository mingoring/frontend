import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_icon_assets.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_logo_typography.dart';

import '../../../core/theme/app_text_styles.dart';
import '../widgets/day_of_the_month_badge.dart';
import '../widgets/monthly_calendar.dart';
import '../../../core/widgets/dialogs/error_alert_dialog.dart';
import '../../../core/widgets/layouts/mingoring_app_bar.dart';
import '../providers/calendar_provider.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _displayedMonth;
  int _cachedStreakDays = 0;

  static const double _horizontalPaddingRatio = 0.06;
  static const double _fireIconHeight = 80.0;
  static const double _fireToStreakGap = 20.0;
  static const double _streakToCalendarGap = 24.0;
  static const String _streakSubtitle = "You're doing great. Keep going.";

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _displayedMonth = DateTime(now.year, now.month, 1);
  }

  @override
  Widget build(BuildContext context) {
    final monthlyProvider = monthlyCalendarProvider(_displayedMonth);
    ref.listen<AsyncValue>(monthlyProvider, (prev, next) {
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

    final today = DateTime.now();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth * _horizontalPaddingRatio;
    final monthlyCalendarAsync = ref.watch(monthlyProvider);
    final newData = monthlyCalendarAsync.valueOrNull;
    if (newData != null) _cachedStreakDays = newData.streakDays;
    final learnedDates = newData?.learnedDates
            .map((date) => DateTime(date.year, date.month, date.day))
            .toSet() ??
        <DateTime>{};
    final dayStates = _buildDayStates(
      month: _displayedMonth,
      today: today,
      learnedDates: learnedDates,
    );

    return Scaffold(
      backgroundColor: AppColors.pink200,
      appBar: MingoringAppBar(
        type: MingoringBackHeaderType.none,
        onBack: () => Navigator.of(context).pop(),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              SvgPicture.asset(
                AppIconAssets.fire,
                height: _fireIconHeight,
              ),
              const SizedBox(height: _fireToStreakGap),
              _StreakSection(
                streakDays: _cachedStreakDays,
                subtitle: _streakSubtitle,
              ),
              const SizedBox(height: _streakToCalendarGap),
              MonthlyCalendar(
                displayedMonth: _displayedMonth,
                dayStates: dayStates,
                onPrevMonthTap: _goToPrevMonth,
                onNextMonthTap: _isCurrentMonth(today) ? null : _goToNextMonth,
                onTitleTap: _goToCurrentMonth,
              ),
              const SizedBox(height: 16),
            ],
        ),
      ),
    );
  }

  Map<DateTime, DayOfTheMonthBadgeVariant> _buildDayStates(
    {
    required DateTime month,
    required DateTime today,
    required Set<DateTime> learnedDates,
  }
  ) {
    final normalizedMonth = DateTime(month.year, month.month, 1);
    final todayNormalized = DateTime(today.year, today.month, today.day);
    final states = <DateTime, DayOfTheMonthBadgeVariant>{};

    final lastDay =
        DateTime(normalizedMonth.year, normalizedMonth.month + 1, 0).day;
    for (int day = 1; day <= lastDay; day++) {
      final date = DateTime(normalizedMonth.year, normalizedMonth.month, day);
      if (date.isAfter(todayNormalized)) break;

      if (learnedDates.contains(date)) {
        states[date] = DayOfTheMonthBadgeVariant.completedDay;
      } else if (date == todayNormalized) {
        states[date] = DayOfTheMonthBadgeVariant.incompletedToday;
      } else {
        states[date] = DayOfTheMonthBadgeVariant.incompletedPastDay;
      }
    }

    return states;
  }

  void _goToPrevMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
        1,
      );
    });
  }

  void _goToNextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
        1,
      );
    });
  }

  void _goToCurrentMonth() {
    final now = DateTime.now();
    setState(() {
      _displayedMonth = DateTime(now.year, now.month, 1);
    });
  }

  bool _isCurrentMonth(DateTime today) =>
      _displayedMonth.year == today.year &&
      _displayedMonth.month == today.month;
}

class _StreakSection extends StatelessWidget {
  const _StreakSection({
    required this.streakDays,
    required this.subtitle,
  });

  final int streakDays;
  final String subtitle;

  static const double _numberToStreakGap = 3.0;
  static const double _streakToSubtitleGap = 4.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$streakDays',
          style: AppLogoTypography.logo1.copyWith(
            color: AppColors.pink600,
          ),
        ),
        const SizedBox(height: _numberToStreakGap),
        Text(
          'Days Streak',
          style: AppLogoTypography.logoB4.copyWith(
            color: AppColors.pink600,
          ),
        ),
        const SizedBox(height: _streakToSubtitleGap),
        Text(
          subtitle,
          style: AppTextStyles.body5Sb15.copyWith(
            color: AppColors.gray500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
