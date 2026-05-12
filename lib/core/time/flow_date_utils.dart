DateTime dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

DateTime tomorrowOf(DateTime value) {
  return dateOnly(value).add(const Duration(days: 1));
}

bool isSameLocalDate(DateTime left, DateTime right) {
  return left.year == right.year &&
      left.month == right.month &&
      left.day == right.day;
}

String compactDateLabel(DateTime date, DateTime now) {
  if (isSameLocalDate(date, now)) {
    return 'Today';
  }
  if (isSameLocalDate(date, tomorrowOf(now))) {
    return 'Tomorrow';
  }
  return '${_monthName(date.month)} ${date.day}';
}

String taskListDateLabel(DateTime date, DateTime now) {
  if (isSameLocalDate(date, now)) {
    return 'Today';
  }
  if (isSameLocalDate(date, tomorrowOf(now))) {
    return 'Tomorrow';
  }
  final monthDay = '${_monthName(date.month)} ${date.day}';
  if (date.year == now.year) {
    return monthDay;
  }
  return '$monthDay, ${date.year}';
}

String detailDateLabel(DateTime date, DateTime now) {
  final days = dateOnly(now).difference(dateOnly(date)).inDays;
  if (days == 0) {
    return 'Today';
  }
  if (days == 1) {
    return 'Yesterday';
  }
  if (days > 1 && days < 7) {
    return 'Last ${_weekdayName(date.weekday)}, ${_monthName(date.month)} ${date.day}';
  }
  return taskListDateLabel(date, now);
}

String timeLabel(String value) {
  final parts = value.split(':');
  if (parts.length < 2) {
    return value;
  }
  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) {
    return value;
  }
  final period = hour >= 12 ? 'p.m.' : 'a.m.';
  final displayHour = hour % 12 == 0 ? 12 : hour % 12;
  return '$displayHour:${minute.toString().padLeft(2, '0')}$period';
}

String _weekdayName(int weekday) {
  const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return names[weekday - 1];
}

String _monthName(int month) {
  const names = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return names[month - 1];
}
