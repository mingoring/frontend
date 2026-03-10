enum CalendarViewType {
  recent,
  monthly;

  static CalendarViewType fromApiValue(String value) {
    return switch (value.toUpperCase()) {
      'RECENT' => CalendarViewType.recent,
      'MONTHLY' => CalendarViewType.monthly,
      _ => () {
          assert(false, 'Unknown CalendarViewType: $value');
          return CalendarViewType.monthly;
        }(),
    };
  }

  String toApiValue() {
    return switch (this) {
      CalendarViewType.recent => 'RECENT',
      CalendarViewType.monthly => 'MONTHLY',
    };
  }
}

class CalendarDataModel {
  const CalendarDataModel({
    required this.viewType,
    required this.rangeStart,
    required this.rangeEnd,
    required this.streakDays,
    required this.learnedDates,
  });

  final CalendarViewType viewType;
  final DateTime rangeStart;
  final DateTime rangeEnd;
  final int streakDays;
  final List<DateTime> learnedDates;
}
