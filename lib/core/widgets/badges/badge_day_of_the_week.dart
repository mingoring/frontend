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
  completedPastDay, // 배경 pink300 (다른 날, 학습완료)
  incompletePastDay, // 배경 white (다른 날, 미학습)
  completedToday, // 배경 pink600 (오늘, 학습완료)
  incompleteToday, // 배경 white + inner border pink600 (오늘, 미학습)
}

/// HomeActionCard(calendar) 타입에서 사용하는 뱃지 데이터 모델
class BadgeDayOfWeekData {
  const BadgeDayOfWeekData({
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
  static const EdgeInsets _padding = EdgeInsets.all(12.0);
  static const BorderRadius _borderRadius =
      BorderRadius.all(Radius.circular(20));
  static const double _gap = 4.0;

  Color get _backgroundColor => switch (variant) {
        DayBadgeVariant.completedPastDay => AppColors.pink300,
        DayBadgeVariant.incompletePastDay => AppColors.white,
        DayBadgeVariant.completedToday => AppColors.pink600,
        DayBadgeVariant.incompleteToday => AppColors.white,
      };

  Color get _weekDayColor => switch (variant) {
        DayBadgeVariant.completedPastDay => AppColors.pink100,
        DayBadgeVariant.incompletePastDay => AppColors.gray600,
        DayBadgeVariant.completedToday => AppColors.pink200,
        DayBadgeVariant.incompleteToday => AppColors.pink600,
      };

  Color get _dateColor => switch (variant) {
        DayBadgeVariant.completedPastDay => AppColors.white,
        DayBadgeVariant.incompletePastDay => AppColors.gray500,
        DayBadgeVariant.completedToday => AppColors.white,
        DayBadgeVariant.incompleteToday => AppColors.pink600,
      };

  BoxBorder? get _border => switch (variant) {
        DayBadgeVariant.incompleteToday => Border.all(
            color: AppColors.pink600,
            width: 1,
          ),
        _ => null,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      padding: _padding,
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: _borderRadius,
        border: _border,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            weekDay.displayName,
            style: AppTextStyles.detail5Sb12.copyWith(color: _weekDayColor),
          ),
          const SizedBox(height: _gap),
          Text(
            date,
            style: AppTextStyles.body7B14.copyWith(color: _dateColor),
          ),
        ],
      ),
    );
  }
}
