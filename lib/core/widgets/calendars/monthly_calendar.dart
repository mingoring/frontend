import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../badges/day_of_the_month_badge.dart';

class MonthlyCalendar extends StatelessWidget {
  const MonthlyCalendar({
    super.key,
    required this.displayedMonth,
    this.dayStates = const {},
    this.onDateTap,
    this.onPrevMonthTap,
    this.onNextMonthTap,
    this.onTitleTap,
  });

  final DateTime displayedMonth;
  final Map<DateTime, DayOfTheMonthBadgeVariant> dayStates;
  final ValueChanged<DateTime>? onDateTap;
  final VoidCallback? onPrevMonthTap;
  final VoidCallback? onNextMonthTap;
  final VoidCallback? onTitleTap;

  static const List<String> _weekDayLabels = [
    'MO',
    'TU',
    'WE',
    'TH',
    'FR',
    'SA',
    'SU',
  ];

  static const List<String> _monthLabels = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  // 스케일 기준 너비 (dp). 실제 너비 / 기준 너비 = safeScale.
  static const double _baseCalendarWidth = 300.0;
  // 카드 상하 패딩 (dp). 좌우는 Title 제외 개별 적용.
  static const double _basePadding = 16.0;
  // Header(Title+Week)와 Days 영역 사이 간격 (dp)
  static const double _baseHeaderDaysGap = 9.0;
  // Title 행과 요일(Week) 헤더 사이 간격 (dp)
  static const double _baseTitleWeekGap = 2.0;
  // Title 행 높이 (dp)
  static const double _baseTitleHeight = 30.0;
  // 요일(Week) 헤더 행 높이 (dp)
  static const double _baseWeekHeaderHeight = 38.0;
  // 날짜 셀 한 칸 크기 (정사각형, dp)
  static const double _baseDayCellSize = 38.3;
  // 월 이동 화살표 아이콘 크기 (dp)
  static const double _baseIconSize = 17.0;
  // 화살표 버튼 최소 터치 영역 (dp, Material 가이드라인 44dp)
  static const double _minTapTargetSize = 44.0;
  // 카드 모서리 반경 (dp)
  static const double _baseCornerRadius = 12.0;
  // 카드 그림자 blur 반경 (dp)
  static const double _baseShadowBlur = 5.0;

  String get _monthTitle {
    final normalized = _normalizeDate(displayedMonth);
    final monthLabel = _monthLabels[normalized.month - 1];
    return '$monthLabel ${normalized.year}';
  }

  @override
  Widget build(BuildContext context) {
    final dayRows = _buildCalendarRows();

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth =
            constraints.hasBoundedWidth && constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : _baseCalendarWidth;

        final scale = maxWidth / _baseCalendarWidth;
        final safeScale = scale.clamp(0.0, double.infinity);

        final padding = _basePadding * safeScale;
        final headerDaysGap = _baseHeaderDaysGap * safeScale;
        final titleWeekGap = _baseTitleWeekGap * safeScale;
        final titleHeight = _baseTitleHeight * safeScale;
        final weekHeaderHeight = _baseWeekHeaderHeight * safeScale;
        final dayCellSize = _baseDayCellSize * safeScale;
        final iconSize = _baseIconSize * safeScale;
        final tapSize = (_minTapTargetSize * safeScale)
            .clamp(_minTapTargetSize, double.infinity);
        final cornerRadius =
            BorderRadius.all(Radius.circular(_baseCornerRadius * safeScale));

        final rowCount = dayRows.length;

        final hPad = EdgeInsets.symmetric(horizontal: padding);

        return Container(
          width: maxWidth,
          padding: EdgeInsets.symmetric(vertical: padding),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: cornerRadius,
            boxShadow: [
              BoxShadow(
                color: AppColors.gray200,
                blurRadius: _baseShadowBlur * safeScale,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Header: Title (좌우 여백 0, 카드 전체 폭 사용) ---
              SizedBox(
                height: titleHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _HeaderArrowButton(
                      icon: Icons.chevron_left,
                      onTap: onPrevMonthTap,
                      iconSize: iconSize,
                      tapSize: tapSize,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: onTitleTap,
                        behavior: HitTestBehavior.opaque,
                        child: Center(
                          child: Text(
                            _monthTitle,
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.body7B14.copyWith(
                              color: AppColors.pink600,
                              height: 1.0,
                              fontSize: 14.0 * safeScale,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    _HeaderArrowButton(
                      icon: Icons.chevron_right,
                      onTap: onNextMonthTap,
                      iconSize: iconSize,
                      tapSize: tapSize,
                    ),
                  ],
                ),
              ),

              SizedBox(height: titleWeekGap),

              // --- Header: Week day labels ---
              Padding(
                padding: hPad,
                child: SizedBox(
                  height: weekHeaderHeight,
                  child: Row(
                    children: _weekDayLabels
                        .map(
                          (label) => Expanded(
                            child: Center(
                              child: Text(
                                label,
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.clip,
                                style: AppTextStyles.detail5Sb12.copyWith(
                                  color: AppColors.gray600,
                                  height: 1.2,
                                  fontSize: 12.0 * safeScale,
                                  letterSpacing: -0.24 * safeScale,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),

              SizedBox(height: headerDaysGap),

              // --- Day rows ---
              Padding(
                padding: hPad,
                child: Column(
                  children: [
                    for (int rowIndex = 0; rowIndex < rowCount; rowIndex++)
                      Row(
                        children: [
                          for (final day in dayRows[rowIndex])
                            Expanded(
                              child: SizedBox(
                                height: dayCellSize,
                                child: Center(
                                  child: _buildDayBadge(day, safeScale),
                                ),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDayBadge(DateTime? day, double scale) {
    if (day == null) {
      return DayOfTheMonthBadge(
        variant: DayOfTheMonthBadgeVariant.empty,
        scale: scale,
      );
    }

    return DayOfTheMonthBadge(
      date: day.day,
      variant: _resolveVariant(day),
      onTap: onDateTap == null ? null : () => onDateTap!.call(day),
      scale: scale,
    );
  }

  DayOfTheMonthBadgeVariant _resolveVariant(DateTime date) {
    final normalized = _normalizeDate(date);
    return dayStates[normalized] ?? DayOfTheMonthBadgeVariant.incompletedPastDay;
  }

  List<List<DateTime?>> _buildCalendarRows() {
    final normalizedMonth = _normalizeDate(displayedMonth);
    final firstDayOfMonth =
        DateTime(normalizedMonth.year, normalizedMonth.month);
    final daysInMonth =
        DateUtils.getDaysInMonth(normalizedMonth.year, normalizedMonth.month);

    final leadingEmptyCount = firstDayOfMonth.weekday - DateTime.monday;
    final totalUsedSlots = leadingEmptyCount + daysInMonth;
    final trailingEmptyCount = (7 - (totalUsedSlots % 7)) % 7;
    final totalCellCount = totalUsedSlots + trailingEmptyCount;

    final allCells = List<DateTime?>.generate(totalCellCount, (index) {
      if (index < leadingEmptyCount) return null;

      final day = index - leadingEmptyCount + 1;
      if (day > daysInMonth) return null;

      return DateTime(normalizedMonth.year, normalizedMonth.month, day);
    });

    final rows = <List<DateTime?>>[];
    for (int i = 0; i < allCells.length; i += 7) {
      rows.add(allCells.sublist(i, i + 7));
    }

    return rows;
  }

  static DateTime _normalizeDate(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}

class _HeaderArrowButton extends StatelessWidget {
  const _HeaderArrowButton({
    required this.icon,
    required this.onTap,
    required this.iconSize,
    required this.tapSize,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double iconSize;
  final double tapSize;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon),
      iconSize: iconSize,
      color: AppColors.gray400,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.tightFor(
        width: tapSize,
        height: tapSize,
      ),
    );
  }
}
