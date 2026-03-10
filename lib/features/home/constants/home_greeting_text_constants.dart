abstract final class HomeGreetingTextConstants {
  static const int _morningStartHour = 5;
  static const int _lunchStartHour = 11;
  static const int _afternoonStartHour = 14;
  static const int _nightStartHour = 18;

  static const Map<int, Map<_GreetingTimeSlot, String>> _greetingTextMap = {
    DateTime.monday: {
      _GreetingTimeSlot.morning: '월요일이에요',
      _GreetingTimeSlot.lunch: '점심 후 한국어 한 편',
      _GreetingTimeSlot.afternoon: '오늘 한국어 어때요',
      _GreetingTimeSlot.night: '오늘도 한국어 한 장면',
    },
    DateTime.tuesday: {
      _GreetingTimeSlot.morning: '좋은 아침이에요',
      _GreetingTimeSlot.lunch: '점심 후 잠깐 볼까요',
      _GreetingTimeSlot.afternoon: '잠깐 한국어 볼까요',
      _GreetingTimeSlot.night: '편안한 밤이에요',
    },
    DateTime.wednesday: {
      _GreetingTimeSlot.morning: '수요일이에요',
      _GreetingTimeSlot.lunch: '한국어 한 편 어때요',
      _GreetingTimeSlot.afternoon: '오늘도 한국어 한 번',
      _GreetingTimeSlot.night: '오늘 한국어 어땠어요',
    },
    DateTime.thursday: {
      _GreetingTimeSlot.morning: '좋은 아침이에요',
      _GreetingTimeSlot.lunch: '점심 후 한국어 타임',
      _GreetingTimeSlot.afternoon: '잠깐 한국어 볼까요',
      _GreetingTimeSlot.night: '편안한 밤 보내요',
    },
    DateTime.friday: {
      _GreetingTimeSlot.morning: '금요일이에요',
      _GreetingTimeSlot.lunch: '점심 후 가볍게 한 편',
      _GreetingTimeSlot.afternoon: '주말 전 한국어 한 편',
      _GreetingTimeSlot.night: '오늘은 한국어 한 장면',
    },
    DateTime.saturday: {
      _GreetingTimeSlot.morning: '좋은 주말이에요',
      _GreetingTimeSlot.lunch: '주말 한국어 어때요',
      _GreetingTimeSlot.afternoon: '느긋하게 한국어',
      _GreetingTimeSlot.night: '주말 밤이에요',
    },
    DateTime.sunday: {
      _GreetingTimeSlot.morning: '편안한 일요일이에요',
      _GreetingTimeSlot.lunch: '오늘 한국어 한 편',
      _GreetingTimeSlot.afternoon: '잠깐 한국어 볼까요',
      _GreetingTimeSlot.night: '내일 또 만나요',
    },
  };

  static String resolve({DateTime? now}) {
    final localNow = now ?? DateTime.now();

    final timeSlot = _resolveTimeSlot(localNow.hour);
    final weekdayGreetingMap = _greetingTextMap[localNow.weekday] ??
        _greetingTextMap[DateTime.monday]!;
    return weekdayGreetingMap[timeSlot] ?? '화이팅이에요';
  }

  static _GreetingTimeSlot _resolveTimeSlot(int hour) {
    if (hour >= _morningStartHour && hour < _lunchStartHour) {
      return _GreetingTimeSlot.morning;
    }
    if (hour >= _lunchStartHour && hour < _afternoonStartHour) {
      return _GreetingTimeSlot.lunch;
    }
    if (hour >= _afternoonStartHour && hour < _nightStartHour) {
      return _GreetingTimeSlot.afternoon;
    }
    return _GreetingTimeSlot.night;
  }
}

enum _GreetingTimeSlot {
  morning,
  lunch,
  afternoon,
  night,
}
