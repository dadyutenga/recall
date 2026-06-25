import 'package:intl/intl.dart';

class AppDateUtils {
  static final _dateFormat = DateFormat('MMM d, yyyy');
  static final _timeFormat = DateFormat('h:mm a');
  static final _dayFormat = DateFormat('EEEE');
  static final _shortDayFormat = DateFormat('EEE');

  static String formatDate(DateTime date) => _dateFormat.format(date);
  static String formatTime(DateTime date) => _timeFormat.format(date);
  static String formatDay(DateTime date) => _dayFormat.format(date);
  static String formatShortDay(DateTime date) => _shortDayFormat.format(date);

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  static bool isOverdue(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    return due.isBefore(today);
  }

  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final endOfWeek = now.add(Duration(days: 7 - now.weekday));
    return date.isAfter(now) && date.isBefore(endOfWeek);
  }

  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  static String dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
