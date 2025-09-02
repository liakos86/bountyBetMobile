class DateUtilsFt {
  static String formattedDateWithOffset(int offset) {
    final DateTime targetDate = DateTime.now().add(Duration(days: offset));
    return '${targetDate.year.toString().padLeft(4, '0')}-'
        '${targetDate.month.toString().padLeft(2, '0')}-'
        '${targetDate.day.toString().padLeft(2, '0')}';
  }

  static String formatDateForLabelDisplay(int offset) {
    final DateTime date = DateTime.now().add(Duration(days: offset));
    const weekdayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    // Dart's DateTime weekday: 1 = Monday, ..., 7 = Sunday
    String weekday = weekdayNames[date.weekday - 1];

    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');

    return '$weekday.$day/$month';
  }

}
