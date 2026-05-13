import '../../../core/time/flow_date_utils.dart';
import '../../../data/local/app_database.dart';
import '../domain/task_enums.dart';

const flowTaskVisualFixtureEnabled = bool.fromEnvironment(
  'FLOWTASK_VISUAL_FIXTURE',
);

List<TaskItem> visualFixtureOverdueTasks(DateTime now) {
  return [
    _task(
      id: 'fixture-overdue-1',
      title: 'Sushma OCi',
      dueDate: DateTime(2025, 11, 18),
      sortOrder: 1,
    ),
    _task(
      id: 'fixture-overdue-2',
      title: 'Buy Naruto and kuroko posters for nivas',
      dueDate: DateTime(2025, 12, 10),
      sortOrder: 2,
    ),
    _task(
      id: 'fixture-overdue-3',
      title: 'deep pore cleanser (not when face scrub)',
      dueDate: DateTime(2025, 12, 20),
      recurrenceRuleId: 'fixture-repeat-1',
      sortOrder: 3,
    ),
    _task(
      id: 'fixture-overdue-4',
      title: 'Pluto glands smelled',
      dueDate: DateTime(2026, 4, 24),
      sortOrder: 4,
    ),
    _task(
      id: 'fixture-overdue-5',
      title: 'Check back up',
      dueDate: DateTime(2026, 4, 30),
      recurrenceRuleId: 'fixture-repeat-2',
      sortOrder: 5,
    ),
    _task(
      id: 'fixture-overdue-6',
      title: 'Face scrub',
      dueDate: DateTime(2026, 5, 2),
      recurrenceRuleId: 'fixture-repeat-3',
      sortOrder: 6,
    ),
    _task(
      id: 'fixture-overdue-7',
      title: 'Get insurance fixed',
      dueDate: DateTime(2026, 5, 8),
      sortOrder: 7,
    ),
    _task(
      id: 'fixture-overdue-8',
      title: 'Helmet',
      dueDate: DateTime(2026, 5, 10),
      recurrenceRuleId: 'fixture-repeat-4',
      sortOrder: 8,
    ),
  ];
}

List<TaskItem> visualFixtureTodayTasks(DateTime now) {
  return [
    _task(
      id: 'fixture-today-1',
      title: 'Get Goodlife Membership',
      dueDate: dateOnly(now),
      dueTime: '15:00',
      isAllDay: false,
    ),
  ];
}

List<TaskItem> visualFixtureCompletedTasks(DateTime now) {
  final completedAt = DateTime(now.year, now.month, now.day, 12);
  return [
    _task(
      id: 'fixture-completed-1',
      title: 'Vitamin D',
      dueDate: dateOnly(now),
      status: TaskStatus.completed,
      completedAt: completedAt,
      sortOrder: 1,
    ),
    _task(
      id: 'fixture-completed-2',
      title: 'Throw egg white .',
      dueDate: dateOnly(now),
      status: TaskStatus.completed,
      completedAt: completedAt,
      sortOrder: 2,
    ),
  ];
}

List<TaskItem> visualFixtureOpenTasks(DateTime now) {
  return [...visualFixtureOverdueTasks(now), ...visualFixtureTodayTasks(now)];
}

TaskItem? visualFixtureTaskById(String id, DateTime now) {
  for (final task in [
    ...visualFixtureOpenTasks(now),
    ...visualFixtureCompletedTasks(now),
  ]) {
    if (task.id == id) {
      return task;
    }
  }
  return null;
}

List<TaskList> visualFixtureLists(DateTime now) {
  return [
    _list(id: 'inbox', name: 'Inbox', sortOrder: 0, now: now, system: true),
    _list(id: 'today-only', name: 'today only', sortOrder: 1, now: now),
    _list(id: 'skin-care', name: 'Skin care', sortOrder: 2, now: now),
    _list(id: 'utilities', name: 'Utilities', sortOrder: 3, now: now),
    _list(id: 'bank', name: 'Bank', sortOrder: 4, now: now),
  ];
}

TaskItem _task({
  required String id,
  required String title,
  DateTime? dueDate,
  String? dueTime,
  TaskStatus status = TaskStatus.open,
  DateTime? completedAt,
  String? recurrenceRuleId,
  int sortOrder = 0,
  bool isAllDay = true,
}) {
  final createdAt = DateTime(2026, 5, 1, 9);
  return TaskItem(
    id: id,
    title: title,
    status: status.value,
    priority: TaskPriority.none.value,
    listId: 'inbox',
    createdAt: createdAt,
    updatedAt: createdAt,
    completedAt: completedAt,
    dueDate: dueDate == null ? null : dateOnly(dueDate),
    dueTime: dueTime,
    timeZone: 'America/Toronto',
    isAllDay: isAllDay,
    isPersistent: false,
    showInTodayUntilComplete: false,
    todayCarryForwardCount: 0,
    recurrenceRuleId: recurrenceRuleId,
    sortOrder: sortOrder,
  );
}

TaskList _list({
  required String id,
  required String name,
  required int sortOrder,
  required DateTime now,
  bool system = false,
}) {
  return TaskList(
    id: id,
    name: name,
    color: '#4774FA',
    sortOrder: sortOrder,
    createdAt: now,
    updatedAt: now,
    isArchived: false,
    isSystemList: system,
  );
}
