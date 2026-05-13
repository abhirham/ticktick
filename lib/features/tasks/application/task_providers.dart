import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../data/local/app_database.dart';
import 'visual_fixture.dart';

final todayDateProvider = Provider<DateTime>((ref) => DateTime.now());

final todayTasksProvider = StreamProvider<List<TaskItem>>((ref) {
  final today = ref.watch(todayDateProvider);
  if (flowTaskVisualFixtureEnabled) {
    return Stream.value(visualFixtureTodayTasks(today));
  }
  return ref.watch(taskRepositoryProvider).watchTodayTasks(today: today);
});

final overdueTasksProvider = StreamProvider<List<TaskItem>>((ref) {
  final today = ref.watch(todayDateProvider);
  if (flowTaskVisualFixtureEnabled) {
    return Stream.value(visualFixtureOverdueTasks(today));
  }
  return ref.watch(taskRepositoryProvider).watchOverdueTasks(today: today);
});

final allOpenTasksProvider = StreamProvider<List<TaskItem>>((ref) {
  if (flowTaskVisualFixtureEnabled) {
    final today = ref.watch(todayDateProvider);
    return Stream.value(visualFixtureOpenTasks(today));
  }
  return ref.watch(taskRepositoryProvider).watchAllOpenTasks();
});

final completedTasksProvider = StreamProvider<List<TaskItem>>((ref) {
  if (flowTaskVisualFixtureEnabled) {
    final today = ref.watch(todayDateProvider);
    return Stream.value(visualFixtureCompletedTasks(today));
  }
  return ref.watch(taskRepositoryProvider).watchCompletedTasks();
});

final trashTasksProvider = StreamProvider<List<TaskItem>>((ref) {
  if (flowTaskVisualFixtureEnabled) {
    return Stream.value(const <TaskItem>[]);
  }
  return ref.watch(taskRepositoryProvider).watchTrashTasks();
});

final taskByIdProvider = StreamProvider.family<TaskItem?, String>((ref, id) {
  if (flowTaskVisualFixtureEnabled) {
    final today = ref.watch(todayDateProvider);
    return Stream.value(visualFixtureTaskById(id, today));
  }
  return ref.watch(taskRepositoryProvider).watchTask(id);
});

final taskListsProvider = StreamProvider<List<TaskList>>((ref) {
  if (flowTaskVisualFixtureEnabled) {
    final today = ref.watch(todayDateProvider);
    return Stream.value(visualFixtureLists(today));
  }
  return ref.watch(taskRepositoryProvider).watchLists();
});

final taskGroupsForListProvider =
    StreamProvider.family<List<ListGroup>, String>((ref, listId) {
      if (flowTaskVisualFixtureEnabled) {
        return Stream.value(const <ListGroup>[]);
      }
      return ref.watch(taskRepositoryProvider).watchGroupsForList(listId);
    });

final taskRemindersProvider =
    StreamProvider.family<List<ReminderEntry>, String>((ref, taskId) {
      if (flowTaskVisualFixtureEnabled) {
        return Stream.value(const <ReminderEntry>[]);
      }
      return ref.watch(taskRepositoryProvider).watchRemindersForTask(taskId);
    });

final taskRepeatRuleProvider =
    StreamProvider.family<RecurrenceRuleEntry?, String>((ref, ruleId) {
      if (flowTaskVisualFixtureEnabled) {
        return Stream.value(null);
      }
      return ref.watch(taskRepositoryProvider).watchRecurrenceRule(ruleId);
    });

final openTaskCountProvider = StreamProvider<int>((ref) {
  if (flowTaskVisualFixtureEnabled) {
    final today = ref.watch(todayDateProvider);
    return Stream.value(visualFixtureOpenTasks(today).length);
  }
  return ref.watch(taskRepositoryProvider).watchOpenCount();
});

final completedTaskCountProvider = StreamProvider<int>((ref) {
  if (flowTaskVisualFixtureEnabled) {
    final today = ref.watch(todayDateProvider);
    return Stream.value(visualFixtureCompletedTasks(today).length);
  }
  return ref.watch(taskRepositoryProvider).watchCompletedCount();
});

final trashTaskCountProvider = StreamProvider<int>((ref) {
  if (flowTaskVisualFixtureEnabled) {
    return Stream.value(0);
  }
  return ref.watch(taskRepositoryProvider).watchTrashCount();
});

final inboxOpenCountProvider = StreamProvider<int>((ref) {
  if (flowTaskVisualFixtureEnabled) {
    final today = ref.watch(todayDateProvider);
    return Stream.value(visualFixtureOpenTasks(today).length);
  }
  return ref.watch(taskRepositoryProvider).watchInboxOpenCount();
});

final tasksForDateProvider = StreamProvider.family<List<TaskItem>, DateTime>((
  ref,
  date,
) {
  if (flowTaskVisualFixtureEnabled) {
    final today = ref.watch(todayDateProvider);
    final targetDay = DateTime(date.year, date.month, date.day);
    final todayDay = DateTime(today.year, today.month, today.day);
    return Stream.value(
      targetDay == todayDay ? visualFixtureTodayTasks(today) : const [],
    );
  }
  return ref.watch(taskRepositoryProvider).watchTasksForDate(date: date);
});
