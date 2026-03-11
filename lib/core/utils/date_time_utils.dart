class DateTimeUtils {
  const DateTimeUtils._();

  /// DateTime → 'yyyy-MM-dd' 형식 문자열
  static String formatDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  /// DateTime → 'yyyy-MM' 형식 문자열
  static String formatMonth(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}';
}
