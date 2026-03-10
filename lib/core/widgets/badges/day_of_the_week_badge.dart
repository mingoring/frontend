import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

// 요일 표기
enum DayOfWeek {
  mo,
  tu,
  we,
  th,
  fr,
  sa,
  su;

  String get displayName => name.toUpperCase();
}

// 요일 뱃지 상태
enum DayBadgeVariant {
  completedDay, // 학습완료
  incompletedPastDay, // 미학습 (과거 날짜)
  incompletedToday, // 미학습 (오늘 날짜)
}

/// HomeActionCard(calendar) 타입에서 사용하는 뱃지 데이터 모델
class DayOfWeekBadgeData {
  const DayOfWeekBadgeData({
    required this.weekDay,
    required this.date,
    required this.variant,
  });

  final DayOfWeek weekDay;
  final String date;
  final DayBadgeVariant variant;
}

/// 요일 / 날짜 / 상태를 표시하는 달력 뱃지 위젯
class DayOfTheWeekBadge extends StatelessWidget {
  const DayOfTheWeekBadge({
    super.key,
    required this.weekDay,
    required this.date,
    required this.variant,
  });

  final DayOfWeek weekDay;
  final String date;
  final DayBadgeVariant variant;

  static const double _width = 40.0;
  static const double _height = 60.0;
  static const EdgeInsets _padding = EdgeInsets.zero;
  static const BorderRadius _borderRadius =
      BorderRadius.all(Radius.circular(20));
  static const double _gap = 4.0;

  Color get _backgroundColor => switch (variant) {
        DayBadgeVariant.completedDay => AppColors.pink600,
        DayBadgeVariant.incompletedPastDay => AppColors.white,
        DayBadgeVariant.incompletedToday => AppColors.pink300,
      };

  Color get _weekDayColor => switch (variant) {
        DayBadgeVariant.completedDay => AppColors.pink200,
        DayBadgeVariant.incompletedPastDay => AppColors.gray600,
        DayBadgeVariant.incompletedToday => AppColors.pink100,
      };

  Color get _dateColor => switch (variant) {
        DayBadgeVariant.completedDay => AppColors.white,
        DayBadgeVariant.incompletedPastDay => AppColors.gray500,
        DayBadgeVariant.incompletedToday => AppColors.white,
      };

  BoxBorder? get _border => null;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _height,
      padding: _padding,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: _borderRadius,
        border: _border,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            weekDay.displayName,
            style: AppTextStyles.detail5Sb12.copyWith(color: _weekDayColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: _gap),
          Text(
            date,
            style: AppTextStyles.body7B14.copyWith(color: _dateColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
