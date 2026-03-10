abstract final class StreakDaysCalculator {
  /// Streak 계산 규칙
  /// 1) baseStreak = 어제부터 과거로 연속 학습일 수
  /// 2) todayBonus = 오늘 학습했으면 1, 아니면 0
  /// 3) 최종 streakDays = baseStreak + todayBonus
  static int calculate({
    required DateTime todayDate,
    required Iterable<DateTime> learnedDates,
  }) {
    final normalizedToday = _normalize(todayDate);
    final normalizedLearnedDates = learnedDates.map(_normalize).toSet();
    final baseStreak = _countConsecutiveLearnedDaysFromYesterday(
      today: normalizedToday,
      learnedDates: normalizedLearnedDates,
    );
    final todayBonus = _hasLearnedOn(
      date: normalizedToday,
      learnedDates: normalizedLearnedDates,
    )
        ? 1
        : 0;

    return baseStreak + todayBonus;
  }

  static int _countConsecutiveLearnedDaysFromYesterday({
    required DateTime today,
    required Set<DateTime> learnedDates,
  }) {
    var count = 0;
    var cursor = today.subtract(const Duration(days: 1));

    while (learnedDates.contains(cursor)) {
      count += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return count;
  }

  static bool _hasLearnedOn({
    required DateTime date,
    required Set<DateTime> learnedDates,
  }) {
    return learnedDates.contains(date);
  }

  static DateTime _normalize(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
