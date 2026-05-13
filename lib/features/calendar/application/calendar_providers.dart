import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/time/flow_date_utils.dart';
import '../../../data/local/app_database.dart';
import '../../tasks/application/task_providers.dart';
import '../../tasks/application/visual_fixture.dart';

typedef CalendarRange = ({DateTime start, DateTime end});

final calendarTasksForRangeProvider =
    StreamProvider.family<List<TaskItem>, CalendarRange>((ref, range) {
      if (flowTaskVisualFixtureEnabled) {
        final today = ref.watch(todayDateProvider);
        final start = dateOnly(range.start);
        final end = dateOnly(range.end);
        final tasks = visualFixtureOpenTasks(today).where((task) {
          final calendarDate = calendarDateForTask(task);
          return calendarDate != null &&
              !calendarDate.isBefore(start) &&
              !calendarDate.isAfter(end);
        }).toList();
        return Stream.value(tasks);
      }
      return ref
          .watch(taskRepositoryProvider)
          .watchCalendarTasksForRange(start: range.start, end: range.end);
    });

DateTime? calendarDateForTask(TaskItem task) {
  final date = task.recurrenceOccurrenceDate ?? task.dueDate;
  return date == null ? null : dateOnly(date);
}

Map<DateTime, List<TaskItem>> groupTasksByCalendarDate(List<TaskItem> tasks) {
  final grouped = <DateTime, List<TaskItem>>{};
  for (final task in tasks) {
    final day = calendarDateForTask(task);
    if (day == null) {
      continue;
    }
    grouped.putIfAbsent(day, () => <TaskItem>[]).add(task);
  }
  return grouped;
}
