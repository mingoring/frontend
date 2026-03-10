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
    return CalendarDataModel.emptyRecent(today: now);
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
    // 401은 예외로 올리지 않고 빈 달력 반환
    return CalendarDataModel.emptyMonthly(targetMonth: targetMonth);
  }
});

Future<String> _resolveTimezone() async {
  return FlutterTimezone.getLocalTimezone();
}
