import '../../../core/errors/app_exception.dart';
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
    final viewType = json['viewType'];
    final rangeStart = json['rangeStart'];
    final rangeEnd = json['rangeEnd'];
    final streakDays = json['streakDays'];
    final learnedDates = json['learnedDates'];

    if (viewType is! String ||
        rangeStart is! String ||
        rangeEnd is! String ||
        streakDays is! num ||
        learnedDates is! List) {
      throw const UnknownException();
    }

    return CalendarResponseDto(
      viewType: viewType,
      rangeStart: rangeStart,
      rangeEnd: rangeEnd,
      streakDays: streakDays.toInt(),
      learnedDates: learnedDates.map((e) {
        if (e is! String) throw const UnknownException();
        return e;
      }).toList(),
    );
  }

  final String viewType;
  final String rangeStart;
  final String rangeEnd;
  final int streakDays;
  final List<String> learnedDates;

  CalendarDataModel toModel() {
    final parsedStart = DateTime.tryParse(rangeStart);
    final parsedEnd = DateTime.tryParse(rangeEnd);

    if (parsedStart == null) {
      throw UnknownException('Invalid rangeStart date: $rangeStart');
    }
    if (parsedEnd == null) {
      throw UnknownException('Invalid rangeEnd date: $rangeEnd');
    }

    final parsedLearnedDates = learnedDates.map((s) {
      final date = DateTime.tryParse(s);
      if (date == null) throw UnknownException('Invalid learnedDate: $s');
      return DateTime(date.year, date.month, date.day);
    }).toList();

    return CalendarDataModel(
      viewType: CalendarViewType.fromApiValue(viewType),
      rangeStart: parsedStart,
      rangeEnd: parsedEnd,
      streakDays: streakDays,
      learnedDates: parsedLearnedDates,
    );
  }
}
