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
