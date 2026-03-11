import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import '../../../core/errors/app_exception.dart';
import '../../auth/models/auth_state.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/calendar_data_model.dart';
import '../repositories/calendar_repository.dart';

final recentCalendarProvider = FutureProvider<CalendarDataModel>((ref) async {
  final authState = ref.watch(authNotifierProvider);
  final now = DateTime.now();
  if (authState is! AuthStateAuthenticated) {
    return CalendarDataModel.emptyRecent(today: now);
  }

  final repository = ref.watch(calendarRepositoryProvider);
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
  final authState = ref.watch(authNotifierProvider);
  final now = DateTime.now();
  final targetMonth = DateTime(displayedMonth.year, displayedMonth.month, 1);
  if (authState is! AuthStateAuthenticated) {
    return CalendarDataModel.emptyMonthly(targetMonth: targetMonth);
  }

  final repository = ref.watch(calendarRepositoryProvider);
  try {
    return repository.fetchMonthly(
      timezone: await _resolveTimezone(),
      todayDate: now,
      targetMonth: targetMonth,
    );
  } on UnauthorizedException {
    return CalendarDataModel.emptyMonthly(targetMonth: targetMonth);
  }
});

Future<String> _resolveTimezone() async {
  return FlutterTimezone.getLocalTimezone();
}
