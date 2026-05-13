import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flowtask/data/local/app_database.dart';
import 'package:flowtask/features/tasks/data/task_repository.dart';
import 'package:flowtask/features/tasks/domain/task_draft.dart';
import 'package:flowtask/features/tasks/domain/task_enums.dart';

void main() {
  late AppDatabase database;
  late TaskRepository repository;
  var now = DateTime(2026, 5, 12, 9);

  setUp(() {
    now = DateTime(2026, 5, 12, 9);
    database = AppDatabase(NativeDatabase.memory());
    repository = TaskRepository(database, now: () => now);
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'completing a daily repeating task creates the next occurrence',
    () async {
      final task = await repository.createTask(
        TaskDraft(
          title: 'Daily review',
          dueDate: DateTime(2026, 5, 12),
          repeatRule: const TaskRepeatDraft(
            frequency: TaskRepeatFrequency.daily,
          ),
        ),
      );

      await repository.completeTask(task.id);

      final completed = await repository.watchCompletedTasks().first;
      final open = await repository.watchAllOpenTasks().first;
      final next = open.single;

      expect(completed.single.id, task.id);
      expect(next.title, 'Daily review');
      expect(next.dueDate, DateTime(2026, 5, 13));
      expect(next.recurrenceRuleId, task.recurrenceRuleId);
      expect(next.recurrenceParentTaskId, task.id);
      expect(next.recurrenceOccurrenceDate, DateTime(2026, 5, 13));
    },
  );

  test('completion reuses an existing future occurrence', () async {
    final task = await repository.createTask(
      TaskDraft(
        title: 'Already generated',
        dueDate: DateTime(2026, 5, 12),
        repeatRule: const TaskRepeatDraft(frequency: TaskRepeatFrequency.daily),
      ),
    );
    await _insertOpenOccurrence(
      database,
      id: 'existing-next',
      parentTaskId: task.id,
      recurrenceRuleId: task.recurrenceRuleId!,
      title: task.title,
      occurrenceDate: DateTime(2026, 5, 13),
      now: now,
    );

    await repository.completeTask(task.id);
    await repository.completeTask(task.id);

    final open = await repository.watchAllOpenTasks().first;
    final matching = open
        .where(
          (item) =>
              item.recurrenceParentTaskId == task.id &&
              item.recurrenceOccurrenceDate == DateTime(2026, 5, 13),
        )
        .toList();

    expect(open.map((item) => item.id), contains('existing-next'));
    expect(matching, hasLength(1));
  });

  test('weekly rules honor selected weekdays and intervals', () async {
    final weekdays = await repository.createTask(
      TaskDraft(
        title: 'Monday Wednesday Friday',
        dueDate: DateTime(2026, 5, 12),
        repeatRule: const TaskRepeatDraft(
          frequency: TaskRepeatFrequency.weekly,
          weekdays: '1,3,5',
        ),
      ),
    );
    final everyOtherSaturday = await repository.createTask(
      TaskDraft(
        title: 'Every other Saturday',
        dueDate: DateTime(2026, 5, 16),
        repeatRule: const TaskRepeatDraft(
          frequency: TaskRepeatFrequency.weekly,
          interval: 2,
          weekdays: '6',
        ),
      ),
    );

    await repository.completeTask(weekdays.id);
    await repository.completeTask(everyOtherSaturday.id);

    final open = await repository.watchAllOpenTasks().first;
    final weekdayNext = open.singleWhere(
      (item) => item.recurrenceParentTaskId == weekdays.id,
    );
    final intervalNext = open.singleWhere(
      (item) => item.recurrenceParentTaskId == everyOtherSaturday.id,
    );

    expect(weekdayNext.recurrenceOccurrenceDate, DateTime(2026, 5, 13));
    expect(intervalNext.recurrenceOccurrenceDate, DateTime(2026, 5, 30));
  });

  test('monthly and yearly rules clamp unavailable month days', () async {
    final monthly = await repository.createTask(
      TaskDraft(
        title: 'Month end',
        dueDate: DateTime(2026, 1, 31),
        repeatRule: const TaskRepeatDraft(
          frequency: TaskRepeatFrequency.monthly,
          monthDay: 31,
        ),
      ),
    );
    final yearly = await repository.createTask(
      TaskDraft(
        title: 'Leap day',
        dueDate: DateTime(2028, 2, 29),
        repeatRule: const TaskRepeatDraft(
          frequency: TaskRepeatFrequency.yearly,
        ),
      ),
    );

    await repository.completeTask(monthly.id);
    await repository.completeTask(yearly.id);

    final open = await repository.watchAllOpenTasks().first;
    final monthlyNext = open.singleWhere(
      (item) => item.recurrenceParentTaskId == monthly.id,
    );
    final yearlyNext = open.singleWhere(
      (item) => item.recurrenceParentTaskId == yearly.id,
    );

    expect(monthlyNext.recurrenceOccurrenceDate, DateTime(2026, 2, 28));
    expect(yearlyNext.recurrenceOccurrenceDate, DateTime(2029, 2, 28));
  });

  test('end date and occurrence count stop future generation', () async {
    final endedByDate = await repository.createTask(
      TaskDraft(
        title: 'Ends today',
        dueDate: DateTime(2026, 5, 12),
        repeatRule: TaskRepeatDraft(
          frequency: TaskRepeatFrequency.daily,
          endType: 'date',
          endDate: DateTime(2026, 5, 12),
        ),
      ),
    );
    final endedByCount = await repository.createTask(
      TaskDraft(
        title: 'One time repeat',
        dueDate: DateTime(2026, 5, 12),
        repeatRule: const TaskRepeatDraft(
          frequency: TaskRepeatFrequency.daily,
          endType: 'count',
          occurrenceCount: 1,
        ),
      ),
    );

    await repository.completeTask(endedByDate.id);
    await repository.completeTask(endedByCount.id);

    final open = await repository.watchAllOpenTasks().first;
    expect(open, isEmpty);
  });

  test(
    'persistent repeating tasks keep only one open future occurrence',
    () async {
      final task = await repository.createTask(
        TaskDraft(
          title: 'Persistent repeat',
          dueDate: DateTime(2026, 5, 12),
          isPersistent: true,
          showInTodayUntilComplete: true,
          repeatRule: const TaskRepeatDraft(
            frequency: TaskRepeatFrequency.daily,
          ),
        ),
      );

      await repository.completeTask(task.id);
      var open = await repository.watchAllOpenTasks().first;
      final secondOccurrence = open.single;

      await repository.completeTask(secondOccurrence.id);
      await repository.completeTask(secondOccurrence.id);

      open = await repository.watchAllOpenTasks().first;
      final completed = await repository.watchCompletedTasks().first;

      expect(open, hasLength(1));
      expect(open.single.dueDate, DateTime(2026, 5, 14));
      expect(open.single.isPersistent, isTrue);
      expect(open.single.showInTodayUntilComplete, isTrue);
      expect(
        completed.map((item) => item.id),
        containsAll([task.id, secondOccurrence.id]),
      );
    },
  );
}

Future<void> _insertOpenOccurrence(
  AppDatabase database, {
  required String id,
  required String parentTaskId,
  required String recurrenceRuleId,
  required String title,
  required DateTime occurrenceDate,
  required DateTime now,
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
          dueDate: Value(occurrenceDate),
          timeZone: 'local',
          recurrenceRuleId: Value(recurrenceRuleId),
          recurrenceParentTaskId: Value(parentTaskId),
          recurrenceOccurrenceDate: Value(occurrenceDate),
        ),
      );
}
