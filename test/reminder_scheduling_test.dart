import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flowtask/data/local/app_database.dart';
import 'package:flowtask/features/reminders/data/reminder_notification_service.dart';
import 'package:flowtask/features/tasks/data/task_repository.dart';
import 'package:flowtask/features/tasks/domain/task_draft.dart';
import 'package:flowtask/features/tasks/domain/task_enums.dart';

void main() {
  late AppDatabase database;
  late _FakeReminderScheduler scheduler;
  late TaskRepository repository;
  final now = DateTime(2026, 5, 12, 9);

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    scheduler = _FakeReminderScheduler();
    repository = TaskRepository(
      database,
      now: () => now,
      reminderScheduler: scheduler,
    );
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'create and update schedule current reminders and cancel old ones',
    () async {
      final task = await repository.createTask(
        TaskDraft(
          title: 'Pay bill',
          dueDate: DateTime(2026, 5, 13),
          dueTime: '10:00',
          reminders: [
            TaskReminderDraft(remindAt: DateTime(2026, 5, 13, 9, 50)),
          ],
        ),
      );

      expect(scheduler.scheduledTaskIds, [task.id]);
      expect(scheduler.scheduledReminderCounts, [1]);

      await repository.updateTask(
        id: task.id,
        title: task.title,
        dueDate: DateTime(2026, 5, 14),
        dueTime: '11:00',
        updateReminders: true,
        reminders: [
          TaskReminderDraft(remindAt: DateTime(2026, 5, 14, 10, 45)),
          TaskReminderDraft(remindAt: DateTime(2026, 5, 14, 10)),
        ],
      );

      expect(scheduler.cancelledTaskIds, contains(task.id));
      expect(scheduler.scheduledTaskIds, [task.id, task.id]);
      expect(scheduler.scheduledReminderCounts, [1, 2]);
    },
  );

  test('complete, trash, and delete cancel reminders', () async {
    final completed = await repository.createTask(
      TaskDraft(
        title: 'Complete me',
        dueDate: DateTime(2026, 5, 13),
        reminders: [TaskReminderDraft(remindAt: DateTime(2026, 5, 13, 9))],
      ),
    );
    final trashed = await repository.createTask(
      TaskDraft(
        title: 'Trash me',
        dueDate: DateTime(2026, 5, 13),
        reminders: [TaskReminderDraft(remindAt: DateTime(2026, 5, 13, 10))],
      ),
    );

    await repository.completeTask(completed.id);
    await repository.moveTaskToTrash(trashed.id);
    await repository.permanentlyDeleteTask(trashed.id);

    expect(scheduler.cancelledTaskIds, containsAll([completed.id, trashed.id]));
  });

  test(
    'repeating completion schedules copied reminders on next occurrence',
    () async {
      final task = await repository.createTask(
        TaskDraft(
          title: 'Daily meds',
          dueDate: DateTime(2026, 5, 12),
          dueTime: '08:00',
          reminders: [
            TaskReminderDraft(remindAt: DateTime(2026, 5, 12, 7, 45)),
          ],
          repeatRule: const TaskRepeatDraft(
            frequency: TaskRepeatFrequency.daily,
          ),
        ),
      );

      await repository.completeTask(task.id);

      final open = await repository.watchAllOpenTasks().first;
      expect(open.single.recurrenceParentTaskId, task.id);
      expect(scheduler.cancelledTaskIds, contains(task.id));
      expect(scheduler.scheduledTaskIds, contains(open.single.id));
    },
  );
}

class _FakeReminderScheduler implements TaskReminderScheduler {
  final scheduledTaskIds = <String>[];
  final scheduledReminderCounts = <int>[];
  final cancelledTaskIds = <String>[];

  @override
  Future<void> scheduleTaskReminders(
    TaskItem task,
    List<ReminderEntry> reminders,
  ) async {
    scheduledTaskIds.add(task.id);
    scheduledReminderCounts.add(reminders.length);
  }

  @override
  Future<void> cancelTaskReminders(
    String taskId, {
    List<ReminderEntry> reminders = const [],
  }) async {
    cancelledTaskIds.add(taskId);
  }

  @override
  Future<void> snoozeTaskReminder(TaskItem task, Duration duration) async {}
}
