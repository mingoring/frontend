import '../models/calendar_data_model.dart';

class CalendarResponseDto {
  const CalendarResponseDto({
    required this.viewType,
    required this.rangeStart,
    required this.rangeEnd,
    required this.streakDays,
    required this.learnedDates,
  });

  factory CalendarResponseDto.fromJson(Map<String, dynamic> json) {
    return CalendarResponseDto(
      viewType: (json['viewType'] as String?) ?? 'MONTHLY',
      rangeStart: (json['rangeStart'] as String?) ?? '',
      rangeEnd: (json['rangeEnd'] as String?) ?? '',
      streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
      learnedDates: ((json['learnedDates'] as List<dynamic>?) ?? const [])
          .whereType<String>()
          .toList(),
    );
  }

  final String viewType;
  final String rangeStart;
  final String rangeEnd;
  final int streakDays;
  final List<String> learnedDates;

  CalendarDataModel toModel() {
    final parsedRangeStart = DateTime.tryParse(rangeStart);
    final parsedRangeEnd = DateTime.tryParse(rangeEnd);

    final normalizedLearnedDates = learnedDates
        .map(DateTime.tryParse)
        .whereType<DateTime>()
        .map((date) => DateTime(date.year, date.month, date.day))
        .toList();

    return CalendarDataModel(
      viewType: CalendarViewType.fromApiValue(viewType),
      rangeStart: parsedRangeStart ?? DateTime.now(),
      rangeEnd: parsedRangeEnd ?? DateTime.now(),
      streakDays: streakDays,
      learnedDates: normalizedLearnedDates,
    );
  }
}
