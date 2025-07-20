class DateUtils {
  static String formattedDateWithOffset(int offset) {
    final DateTime targetDate = DateTime.now().add(Duration(days: offset));
    return '${targetDate.year.toString().padLeft(4, '0')}-'
        '${targetDate.month.toString().padLeft(2, '0')}-'
        '${targetDate.day.toString().padLeft(2, '0')}';
  }
}
