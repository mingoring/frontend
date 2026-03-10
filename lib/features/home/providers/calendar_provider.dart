import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/storage/local_storage_service.dart';
import '../models/calendar_data_model.dart';
import '../repositories/calendar_repository.dart';

final recentCalendarProvider = FutureProvider<CalendarDataModel>((ref) async {
  final repository = ref.watch(calendarRepositoryProvider);
  final localStorageService =
      await ref.watch(localStorageServiceProvider.future);
  final now = DateTime.now();
  final accessToken = localStorageService.getAccessToken();
  if (accessToken == null || accessToken.isEmpty) {
    return CalendarDataModel(
      viewType: CalendarViewType.recent,
      rangeStart: now.subtract(const Duration(days: 3)),
      rangeEnd: now,
      streakDays: 0,
      learnedDates: const [],
    );
  }
  try {
    return repository.fetchRecent(
      accessToken: accessToken,
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
  final localStorageService =
      await ref.watch(localStorageServiceProvider.future);
  final now = DateTime.now();
  final targetMonth = DateTime(displayedMonth.year, displayedMonth.month, 1);
  final accessToken = localStorageService.getAccessToken();
  if (accessToken == null || accessToken.isEmpty) {
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
  try {
    return repository.fetchMonthly(
      accessToken: accessToken,
      timezone: await _resolveTimezone(),
      todayDate: now,
      targetMonth: targetMonth,
    );
  } on UnauthorizedException {
    // 401은 정상 처리: 예외로 올리지 않고 streakDays: 0, learnedDates: []로 반환
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
