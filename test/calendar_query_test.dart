import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flowtask/data/local/app_database.dart';
import 'package:flowtask/features/tasks/data/task_repository.dart';
import 'package:flowtask/features/tasks/domain/task_draft.dart';
import 'package:flowtask/features/tasks/domain/task_enums.dart';

void main() {
  late AppDatabase database;
  late TaskRepository repository;
  final now = DateTime(2026, 5, 12, 9);

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = TaskRepository(database, now: () => now);
  });

  tearDown(() async {
    await database.close();
  });

  test('calendar date query only includes tasks on that exact date', () async {
    await repository.createTask(TaskDraft(title: 'Due today', dueDate: now));
    await repository.createTask(
      TaskDraft(
        title: 'Overdue',
        dueDate: now.subtract(const Duration(days: 1)),
      ),
    );
    await repository.createTask(
      const TaskDraft(
        title: 'Persistent no date',
        isPersistent: true,
        showInTodayUntilComplete: true,
      ),
    );
    await repository.createTask(
      TaskDraft(
        title: 'Persistent with date',
        dueDate: now.add(const Duration(days: 1)),
        isPersistent: true,
        showInTodayUntilComplete: true,
      ),
    );
    final completed = await repository.createTask(
      TaskDraft(title: 'Completed today', dueDate: now),
    );
    final deleted = await repository.createTask(
      TaskDraft(title: 'Deleted today', dueDate: now),
    );

    await repository.completeTask(completed.id);
    await repository.moveTaskToTrash(deleted.id);

    final today = await repository.watchTasksForDate(date: now).first;
    final tomorrow = await repository
        .watchTasksForDate(date: now.add(const Duration(days: 1)))
        .first;
    final todayWithCompleted = await repository
        .watchTasksForDate(date: now, includeCompleted: true)
        .first;

    expect(today.map((task) => task.title), ['Due today']);
    expect(tomorrow.map((task) => task.title), ['Persistent with date']);
    expect(
      todayWithCompleted.map((task) => task.title),
      containsAll(['Due today', 'Completed today']),
    );
    expect(
      todayWithCompleted.map((task) => task.title),
      isNot(contains('Deleted today')),
    );
  });

  test('recurrence occurrence date is used as the calendar date', () async {
    await repository.createTask(TaskDraft(title: 'Normal due', dueDate: now));
    await _insertTask(
      database,
      id: 'repeat-occurrence',
      title: 'Repeating occurrence',
      dueDate: now,
      recurrenceRuleId: 'repeat-rule-1',
      recurrenceOccurrenceDate: DateTime(2026, 5, 16),
      now: now,
    );

    final dueDateTasks = await repository.watchTasksForDate(date: now).first;
    final occurrenceTasks = await repository
        .watchTasksForDate(date: DateTime(2026, 5, 16))
        .first;

    expect(dueDateTasks.map((task) => task.title), ['Normal due']);
    expect(occurrenceTasks.map((task) => task.title), ['Repeating occurrence']);
  });

  test(
    'calendar range excludes deleted, completed, and no-date tasks',
    () async {
      await repository.createTask(
        TaskDraft(title: 'Inside month', dueDate: DateTime(2026, 5, 20)),
      );
      await repository.createTask(
        TaskDraft(title: 'Outside month', dueDate: DateTime(2026, 6, 2)),
      );
      await repository.createTask(const TaskDraft(title: 'No date'));
      final completed = await repository.createTask(
        TaskDraft(title: 'Completed in month', dueDate: DateTime(2026, 5, 21)),
      );
      final deleted = await repository.createTask(
        TaskDraft(title: 'Deleted in month', dueDate: DateTime(2026, 5, 22)),
      );
      await _insertTask(
        database,
        id: 'range-repeat',
        title: 'Range repeat',
        dueDate: DateTime(2026, 4, 1),
        recurrenceRuleId: 'repeat-rule-2',
        recurrenceOccurrenceDate: DateTime(2026, 5, 23),
        now: now,
      );

      await repository.completeTask(completed.id);
      await repository.moveTaskToTrash(deleted.id);

      final tasks = await repository
          .watchCalendarTasksForRange(
            start: DateTime(2026, 5),
            end: DateTime(2026, 5, 31),
          )
          .first;

      expect(
        tasks.map((task) => task.title),
        containsAll(['Inside month', 'Range repeat']),
      );
      expect(tasks.map((task) => task.title), isNot(contains('Outside month')));
      expect(tasks.map((task) => task.title), isNot(contains('No date')));
      expect(
        tasks.map((task) => task.title),
        isNot(contains('Completed in month')),
      );
      expect(
        tasks.map((task) => task.title),
        isNot(contains('Deleted in month')),
      );
    },
  );

  test('moving and clearing task dates updates calendar visibility', () async {
    final task = await repository.createTask(const TaskDraft(title: 'Move me'));

    await repository.moveTaskToDate(id: task.id, date: DateTime(2026, 5, 18));
    var movedTasks = await repository
        .watchTasksForDate(date: DateTime(2026, 5, 18))
        .first;
    expect(movedTasks.map((task) => task.title), ['Move me']);

    await repository.clearTaskDate(task.id);
    movedTasks = await repository
        .watchTasksForDate(date: DateTime(2026, 5, 18))
        .first;
    expect(movedTasks, isEmpty);
  });
}

Future<void> _insertTask(
  AppDatabase database, {
  required String id,
  required String title,
  required DateTime now,
  DateTime? dueDate,
  String? recurrenceRuleId,
  DateTime? recurrenceOccurrenceDate,
}) {
  return database
      .into(database.taskItems)
      .insert(
        TaskItemsCompanion.insert(
          id: id,
          title: title,
          status: Value(TaskStatus.open.value),
          listId: AppDatabase.inboxListId,
          createdAt: now,
          updatedAt: now,
          dueDate: Value(dueDate),
          timeZone: 'local',
          recurrenceRuleId: Value(recurrenceRuleId),
          recurrenceOccurrenceDate: Value(recurrenceOccurrenceDate),
        ),
      );
}
