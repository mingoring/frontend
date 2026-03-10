import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_data_model.freezed.dart';

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

@freezed
class CalendarDataModel with _$CalendarDataModel {
  const factory CalendarDataModel({
    required CalendarViewType viewType,
    required DateTime rangeStart,
    required DateTime rangeEnd,
    required int streakDays,
    required List<DateTime> learnedDates,
  }) = _CalendarDataModel;
}
