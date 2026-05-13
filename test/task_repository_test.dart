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

  test('creates title-only normal task without due date', () async {
    final task = await repository.createTask(
      const TaskDraft(title: 'Standalone task'),
    );

    expect(task.title, 'Standalone task');
    expect(task.dueDate, isNull);
    expect(task.description, isNull);
    expect(task.isPersistent, isFalse);
    expect(task.showInTodayUntilComplete, isFalse);
  });

  test(
    'creates, completes, trashes, restores, and permanently deletes a task',
    () async {
      final task = await repository.createTask(
        const TaskDraft(title: 'Buy groceries'),
      );

      expect(task.title, 'Buy groceries');
      expect(TaskStatus.fromValue(task.status), TaskStatus.open);

      await repository.completeTask(task.id);
      var completed = await repository.watchCompletedTasks().first;
      expect(completed.single.id, task.id);

      await repository.reopenTask(task.id);
      await repository.moveTaskToTrash(task.id);
      var trash = await repository.watchTrashTasks().first;
      expect(trash.single.id, task.id);

      await repository.restoreTask(task.id);
      var open = await repository.watchAllOpenTasks().first;
      expect(open.single.id, task.id);

      await repository.permanentlyDeleteTask(task.id);
      open = await repository.watchAllOpenTasks().first;
      expect(open, isEmpty);
    },
  );

  test('today includes due-today and persistent no-date tasks', () async {
    await repository.createTask(TaskDraft(title: 'Due today', dueDate: now));
    await repository.createTask(
      const TaskDraft(
        title: 'Keep visible',
        isPersistent: true,
        showInTodayUntilComplete: true,
      ),
    );
    await repository.createTask(
      TaskDraft(title: 'Tomorrow', dueDate: now.add(const Duration(days: 1))),
    );

    final today = await repository.watchTodayTasks(today: now).first;

    expect(
      today.map((task) => task.title),
      containsAll(['Due today', 'Keep visible']),
    );
    expect(today.map((task) => task.title), isNot(contains('Tomorrow')));
  });

  test(
    'today filtering honors overdue and persistent visibility flags',
    () async {
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

      final defaultToday = await repository.watchTodayTasks(today: now).first;
      final todayWithOverdue = await repository
          .watchTodayTasks(today: now, includeOverdue: true)
          .first;
      final todayWithoutPersistent = await repository
          .watchTodayTasks(today: now, includePersistent: false)
          .first;

      expect(defaultToday.map((task) => task.title), [
        'Due today',
        'Persistent no date',
      ]);
      expect(
        todayWithOverdue.map((task) => task.title),
        containsAll(['Overdue', 'Due today', 'Persistent no date']),
      );
      expect(todayWithOverdue, hasLength(3));
      expect(todayWithoutPersistent.map((task) => task.title), ['Due today']);
    },
  );

  test('persistent task created yesterday is carried forward today', () async {
    final yesterday = now;
    final task = await repository.createTask(
      const TaskDraft(
        title: 'Call insurance',
        isPersistent: true,
        showInTodayUntilComplete: true,
      ),
    );

    now = yesterday.add(const Duration(days: 1));
    final today = await repository.watchTodayTasks(today: now).first;
    final carried = today.singleWhere((item) => item.id == task.id);

    expect(carried.todayCarryForwardCount, 1);
    expect(carried.lastCarriedForwardAt, DateTime(2026, 5, 13));
  });

  test(
    'completed persistent task stays out of Today and visible in Completed',
    () async {
      final task = await repository.createTask(
        TaskDraft(
          title: 'Persistent with due date',
          dueDate: now,
          isPersistent: true,
          showInTodayUntilComplete: true,
        ),
      );

      await repository.completeTask(task.id);
      now = now.add(const Duration(days: 1));

      final today = await repository.watchTodayTasks(today: now).first;
      final completed = await repository.watchCompletedTasks().first;

      expect(today.map((item) => item.id), isNot(contains(task.id)));
      expect(completed.single.id, task.id);
      expect(completed.single.dueDate, DateTime(2026, 5, 12));
    },
  );

  test('completed and trash counts follow status transitions', () async {
    final keepOpen = await repository.createTask(
      const TaskDraft(title: 'Keep open'),
    );
    final completeMe = await repository.createTask(
      const TaskDraft(title: 'Complete me'),
    );
    final trashMe = await repository.createTask(
      const TaskDraft(title: 'Trash me'),
    );

    expect(await repository.watchOpenCount().first, 3);

    await repository.completeTask(completeMe.id);
    await repository.moveTaskToTrash(trashMe.id);

    expect(await repository.watchOpenCount().first, 1);
    expect(await repository.watchCompletedCount().first, 1);
    expect(await repository.watchTrashCount().first, 1);
    expect((await repository.watchAllOpenTasks().first).single.id, keepOpen.id);

    await repository.reopenTask(completeMe.id);
    await repository.restoreTask(trashMe.id);

    expect(await repository.watchOpenCount().first, 3);
    expect(await repository.watchCompletedCount().first, 0);
    expect(await repository.watchTrashCount().first, 0);
  });

  test('moving and clearing dates keeps time state consistent', () async {
    final task = await repository.createTask(
      const TaskDraft(title: 'Schedule me', dueTime: '14:30', isAllDay: false),
    );

    await repository.moveTaskToDate(id: task.id, date: DateTime(2026, 5, 20));
    var updated = await repository.watchTask(task.id).first;

    expect(updated!.dueDate, DateTime(2026, 5, 20));
    expect(updated.dueTime, '14:30');
    expect(updated.isAllDay, isFalse);

    await repository.clearTaskDate(task.id);
    updated = await repository.watchTask(task.id).first;

    expect(updated!.dueDate, isNull);
    expect(updated.dueTime, isNull);
    expect(updated.isAllDay, isTrue);
  });

  test('persistent carry-forward preserves original due date', () async {
    final yesterday = now;
    final task = await repository.createTask(
      TaskDraft(
        title: 'Overdue but persistent',
        dueDate: yesterday,
        isPersistent: true,
        showInTodayUntilComplete: true,
      ),
    );

    now = yesterday.add(const Duration(days: 1));
    final today = await repository.watchTodayTasks(today: now).first;
    final carried = today.singleWhere((item) => item.id == task.id);

    expect(carried.dueDate, DateTime(2026, 5, 12));
    expect(carried.todayCarryForwardCount, 1);
  });

  test(
    'natural-language persistent trigger marks task as keep in today',
    () async {
      final task = await repository.createTask(
        const TaskDraft(
          title: 'Send builder email',
          originalInput: 'keep in today send builder email',
        ),
      );

      expect(task.isPersistent, isTrue);
      expect(task.showInTodayUntilComplete, isTrue);
      expect(task.persistentStartedAt, now);
    },
  );

  test(
    'updates task metadata with list, group, reminder, and repeat rule',
    () async {
      await database
          .into(database.taskLists)
          .insert(
            TaskListsCompanion.insert(
              id: 'home',
              name: 'Home',
              color: const Value('#4774FA'),
              sortOrder: const Value(1),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await database
          .into(database.listGroups)
          .insert(
            ListGroupsCompanion.insert(
              id: 'chores',
              listId: 'home',
              name: 'Chores',
              sortOrder: const Value(1),
              createdAt: now,
              updatedAt: now,
            ),
          );
      final task = await repository.createTask(
        const TaskDraft(title: 'Clean kitchen'),
      );

      await repository.updateTask(
        id: task.id,
        title: 'Clean kitchen sink',
        description: 'Use the gentle cleaner.',
        priority: TaskPriority.high,
        listId: 'home',
        updateGroup: true,
        groupId: 'chores',
        dueDate: DateTime(2026, 5, 14),
        dueTime: '17:00',
        isAllDay: false,
        isPersistent: true,
        showInTodayUntilComplete: true,
        updateReminders: true,
        reminders: [
          TaskReminderDraft(
            reminderType: 'relative',
            remindAt: DateTime(2026, 5, 14, 16, 50),
            offsetMinutes: -10,
          ),
        ],
        updateRepeatRule: true,
        repeatRule: const TaskRepeatDraft(
          frequency: TaskRepeatFrequency.weekly,
          weekdays: '1,2,3,4,5',
        ),
      );

      final updated = await repository.watchTask(task.id).first;
      final reminders = await repository.watchRemindersForTask(task.id).first;
      final repeatRule = await repository
          .watchRecurrenceRule(updated!.recurrenceRuleId!)
          .first;

      expect(updated.title, 'Clean kitchen sink');
      expect(updated.description, 'Use the gentle cleaner.');
      expect(updated.priority, TaskPriority.high.value);
      expect(updated.listId, 'home');
      expect(updated.groupId, 'chores');
      expect(updated.dueDate, DateTime(2026, 5, 14));
      expect(updated.dueTime, '17:00');
      expect(updated.isAllDay, isFalse);
      expect(updated.isPersistent, isTrue);
      expect(updated.showInTodayUntilComplete, isTrue);
      expect(reminders.single.offsetMinutes, -10);
      expect(repeatRule!.repeatFrequency, TaskRepeatFrequency.weekly.value);
      expect(repeatRule.repeatWeekdays, '1,2,3,4,5');
    },
  );

  test('widget count includes due today only', () async {
    final dueToday = await repository.createTask(
      TaskDraft(title: 'Due today', dueDate: now),
    );
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
    final completed = await repository.createTask(
      TaskDraft(title: 'Completed today', dueDate: now),
    );
    final deleted = await repository.createTask(
      TaskDraft(title: 'Deleted today', dueDate: now),
    );

    await repository.completeTask(completed.id);
    await repository.moveTaskToTrash(deleted.id);

    expect(await repository.dueTodayWidgetCount(now), 1);
    expect(dueToday.dueDate, DateTime(2026, 5, 12));
  });
}
