class DateUtils {
  static DateTime getStartOfWeek(DateTime date) {
    final daysFromSunday = date.weekday % 7;
    return date.subtract(Duration(days: daysFromSunday));
  }

  static DateTime getEndOfWeek(DateTime date) {
    final startOfWeek = getStartOfWeek(date);
    return startOfWeek.add(const Duration(days: 6));
  }

  static DateTime getLastWeekStart(DateTime date) {
    final thisWeekStart = getStartOfWeek(date);
    return thisWeekStart.subtract(const Duration(days: 7));
  }

  static DateTime getNextWeekStart(DateTime date) {
    final thisWeekStart = getStartOfWeek(date);
    return thisWeekStart.add(const Duration(days: 7));
  }

  static bool isSameWeek(DateTime date1, DateTime date2) {
    final start1 = getStartOfWeek(date1);
    final start2 = getStartOfWeek(date2);
    return start1.year == start2.year &&
           start1.month == start2.month &&
           start1.day == start2.day;
  }

  static bool isLastWeek(DateTime targetDate, DateTime currentDate) {
    final lastWeekStart = getLastWeekStart(currentDate);
    final lastWeekEnd = lastWeekStart.add(const Duration(days: 6));
    return targetDate.isAfter(lastWeekStart.subtract(const Duration(days: 1))) &&
           targetDate.isBefore(lastWeekEnd.add(const Duration(days: 1)));
  }

  static bool isThisWeek(DateTime targetDate, DateTime currentDate) {
    return isSameWeek(targetDate, currentDate);
  }

  static bool isNextWeek(DateTime targetDate, DateTime currentDate) {
    final nextWeekStart = getNextWeekStart(currentDate);
    final nextWeekEnd = nextWeekStart.add(const Duration(days: 6));
    return targetDate.isAfter(nextWeekStart.subtract(const Duration(days: 1))) &&
           targetDate.isBefore(nextWeekEnd.add(const Duration(days: 1)));
  }

  static int getWeekOfYear(DateTime date) {
    final startOfYear = DateTime(date.year, 1, 1);
    final firstSunday = startOfYear.subtract(Duration(days: startOfYear.weekday % 7));
    final difference = date.difference(firstSunday).inDays;
    return (difference / 7).floor() + 1;
  }
}
