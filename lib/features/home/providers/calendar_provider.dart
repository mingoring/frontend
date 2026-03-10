import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import '../../../core/errors/app_exception.dart';
import '../models/calendar_data_model.dart';
import '../repositories/calendar_repository.dart';

final recentCalendarProvider = FutureProvider<CalendarDataModel>((ref) async {
  final repository = ref.watch(calendarRepositoryProvider);
  final now = DateTime.now();
  try {
    return repository.fetchRecent(
      timezone: await _resolveTimezone(),
      todayDate: now,
    );
  } on UnauthorizedException {
    return CalendarDataModel(
      viewType: CalendarViewType.recent,
      rangeStart: now.subtract(const Duration(days: 3)),
      rangeEnd: now,
      streakDays: 0,
      learnedDates: const [],
    );
  }
});

final monthlyCalendarProvider =
    FutureProvider.family<CalendarDataModel, DateTime>(
        (ref, displayedMonth) async {
  final repository = ref.watch(calendarRepositoryProvider);
  final now = DateTime.now();
  final targetMonth = DateTime(displayedMonth.year, displayedMonth.month, 1);
  try {
    return repository.fetchMonthly(
      timezone: await _resolveTimezone(),
      todayDate: now,
      targetMonth: targetMonth,
    );
  } on UnauthorizedException {
    // 401은 예외로 올리지 않고 streakDays: 0, learnedDates: []로 반환
    final rangeStart = DateTime(targetMonth.year, targetMonth.month, 1);
    final rangeEnd = DateTime(targetMonth.year, targetMonth.month + 1, 0);
    return CalendarDataModel(
      viewType: CalendarViewType.monthly,
      rangeStart: rangeStart,
      rangeEnd: rangeEnd,
      streakDays: 0,
      learnedDates: const [],
    );
  }
});

Future<String> _resolveTimezone() async {
  return FlutterTimezone.getLocalTimezone();
}
