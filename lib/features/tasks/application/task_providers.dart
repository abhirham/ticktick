import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../data/local/app_database.dart';

final todayDateProvider = Provider<DateTime>((ref) => DateTime.now());

final todayTasksProvider = StreamProvider<List<TaskItem>>((ref) {
  final today = ref.watch(todayDateProvider);
  return ref.watch(taskRepositoryProvider).watchTodayTasks(today: today);
});

final allOpenTasksProvider = StreamProvider<List<TaskItem>>((ref) {
  return ref.watch(taskRepositoryProvider).watchAllOpenTasks();
});

final completedTasksProvider = StreamProvider<List<TaskItem>>((ref) {
  return ref.watch(taskRepositoryProvider).watchCompletedTasks();
});

final trashTasksProvider = StreamProvider<List<TaskItem>>((ref) {
  return ref.watch(taskRepositoryProvider).watchTrashTasks();
});

final taskByIdProvider = StreamProvider.family<TaskItem?, String>((ref, id) {
  return ref.watch(taskRepositoryProvider).watchTask(id);
});

final taskListsProvider = StreamProvider<List<TaskList>>((ref) {
  return ref.watch(taskRepositoryProvider).watchLists();
});

final openTaskCountProvider = StreamProvider<int>((ref) {
  return ref.watch(taskRepositoryProvider).watchOpenCount();
});

final completedTaskCountProvider = StreamProvider<int>((ref) {
  return ref.watch(taskRepositoryProvider).watchCompletedCount();
});

final trashTaskCountProvider = StreamProvider<int>((ref) {
  return ref.watch(taskRepositoryProvider).watchTrashCount();
});

final inboxOpenCountProvider = StreamProvider<int>((ref) {
  return ref.watch(taskRepositoryProvider).watchInboxOpenCount();
});

final tasksForDateProvider = StreamProvider.family<List<TaskItem>, DateTime>((
  ref,
  date,
) {
  return ref.watch(taskRepositoryProvider).watchTasksForDate(date: date);
});
