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
