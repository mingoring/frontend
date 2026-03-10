import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_icon_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_logo_typography.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/badges/day_of_the_month_badge.dart';
import '../../../core/widgets/calendars/monthly_calendar.dart';
import '../../../core/widgets/layouts/mingoring_app_bar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _displayedMonth;

  static const double _horizontalPaddingRatio = 0.06;
  static const double _fireIconHeight = 80.0;
  static const double _fireToStreakGap = 20.0;
  static const double _streakToCalendarGap = 24.0;
  static const int _streakDays = 3;
  static const String _streakSubtitle = "You're doing great. Keep going.";

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _displayedMonth = DateTime(now.year, now.month, 1);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = screenWidth * _horizontalPaddingRatio;

    return Scaffold(
      backgroundColor: AppColors.pink200,
      appBar: MingoringAppBar(
        type: MingoringBackHeaderType.none,
        onBack: () => Navigator.of(context).pop(),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              const _StreakSection(
                streakDays: _streakDays,
                subtitle: _streakSubtitle,
              ),
              const SizedBox(height: _streakToCalendarGap),
              MonthlyCalendar(
                displayedMonth: _displayedMonth,
                dayStates: _buildSampleDayStates(_displayedMonth),
                onPrevMonthTap: _goToPrevMonth,
                onNextMonthTap: _goToNextMonth,
                onTitleTap: _goToCurrentMonth,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Map<DateTime, DayOfTheMonthBadgeVariant> _buildSampleDayStates(
    DateTime month,
  ) {
    final normalizedMonth = DateTime(month.year, month.month, 1);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final states = <DateTime, DayOfTheMonthBadgeVariant>{};

    for (int day = 1; day <= 4; day++) {
      states[DateTime(normalizedMonth.year, normalizedMonth.month, day)] =
          DayOfTheMonthBadgeVariant.incompletedPastDay;
    }
    for (int day = 5; day <= 7; day++) {
      states[DateTime(normalizedMonth.year, normalizedMonth.month, day)] =
          DayOfTheMonthBadgeVariant.completedDay;
    }

    if (today.year == normalizedMonth.year &&
        today.month == normalizedMonth.month) {
      final existing = states[today];
      if (existing != DayOfTheMonthBadgeVariant.completedDay) {
        states[today] = DayOfTheMonthBadgeVariant.incompletedToday;
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
