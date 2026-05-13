import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flowtask/data/local/app_database.dart';
import 'package:flowtask/features/tasks/data/task_repository.dart';
import 'package:flowtask/features/tasks/domain/task_draft.dart';
import 'package:flowtask/features/widget/data/widget_data_service.dart';

void main() {
  late AppDatabase database;
  late TaskRepository taskRepository;
  late WidgetDataService service;

  final now = DateTime(2026, 5, 12, 9, 30);

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    taskRepository = TaskRepository(database, now: () => now);
    service = WidgetDataService(
      database,
      now: () => now,
      timeZoneName: () => 'America/Toronto',
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('generates a widget summary for open due-today tasks only', () async {
    await taskRepository.createTask(
      TaskDraft(title: 'Morning due today', dueDate: now, dueTime: '09:00'),
    );
    await taskRepository.createTask(
      TaskDraft(title: 'Evening due today', dueDate: now, dueTime: '18:00'),
    );
    await taskRepository.createTask(
      TaskDraft(
        title: 'Overdue',
        dueDate: now.subtract(const Duration(days: 1)),
      ),
    );
    await taskRepository.createTask(
      TaskDraft(title: 'Future', dueDate: now.add(const Duration(days: 1))),
    );
    await taskRepository.createTask(const TaskDraft(title: 'No date'));
    await taskRepository.createTask(
      const TaskDraft(
        title: 'Persistent no date',
        isPersistent: true,
        showInTodayUntilComplete: true,
      ),
    );

    final completed = await taskRepository.createTask(
      TaskDraft(title: 'Completed due today', dueDate: now),
    );
    final deleted = await taskRepository.createTask(
      TaskDraft(title: 'Deleted due today', dueDate: now),
    );
    await taskRepository.completeTask(completed.id);
    await taskRepository.moveTaskToTrash(deleted.id);

    final summary = await service.generateTodaySummary(maxTaskTitles: 5);

    expect(summary.dueTodayCount, 2);
    expect(summary.generatedAt, now);
    expect(summary.timeZone, 'America/Toronto');
    expect(summary.nextDueTodayTasks, [
      'Morning due today',
      'Evening due today',
    ]);
  });

  test('persists a widget-safe snapshot with stable today widget id', () async {
    await taskRepository.createTask(
      TaskDraft(title: 'First due today', dueDate: now, dueTime: '10:00'),
    );

    final firstSnapshot = await service.refreshTodaySnapshot();

    expect(firstSnapshot.id, WidgetDataService.todaySnapshotId);
    expect(firstSnapshot.dueTodayCount, 1);
    expect(firstSnapshot.generatedAt, now);
    expect(firstSnapshot.timeZone, 'America/Toronto');
    expect(jsonDecode(firstSnapshot.nextDueTodayTasksJson), [
      'First due today',
    ]);

    await taskRepository.createTask(
      TaskDraft(title: 'Second due today', dueDate: now, dueTime: '11:00'),
    );
    final secondSnapshot = await service.refreshTodaySnapshot();
    final snapshots = await database
        .select(database.widgetSnapshotEntries)
        .get();
    final summary = WidgetDataSummary.fromSnapshot(secondSnapshot);

    expect(snapshots, hasLength(1));
    expect(secondSnapshot.id, WidgetDataService.todaySnapshotId);
    expect(summary.dueTodayCount, 2);
    expect(summary.nextDueTodayTasks, ['First due today', 'Second due today']);
  });
}
