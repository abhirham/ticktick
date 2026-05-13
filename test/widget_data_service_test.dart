import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flowtask/data/local/app_database.dart';
import 'package:flowtask/features/settings/data/settings_repository.dart';
import 'package:flowtask/features/tasks/data/task_repository.dart';
import 'package:flowtask/features/tasks/domain/task_draft.dart';
import 'package:flowtask/features/widget/data/native_widget_bridge.dart';
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

  test('publishes snapshots to native widgets with privacy settings', () async {
    final bridge = _RecordingNativeWidgetBridge();
    final settingsRepository = SettingsRepository(database, now: () => now);
    service = WidgetDataService(
      database,
      now: () => now,
      timeZoneName: () => 'America/Toronto',
      nativeBridge: bridge,
    );
    await settingsRepository.setString(
      SettingKeys.widgetDisplayMode,
      'countAndTitles',
    );
    await settingsRepository.setBool(
      SettingKeys.widgetShowsLockScreenTitles,
      true,
    );
    await settingsRepository.setString(
      SettingKeys.widgetTapDestination,
      'calendar',
    );
    await taskRepository.createTask(
      TaskDraft(title: 'Widget-visible task', dueDate: now, dueTime: '08:00'),
    );

    await service.refreshTodaySnapshot();

    expect(bridge.publishedSummary?.dueTodayCount, 1);
    expect(bridge.publishedSummary?.nextDueTodayTasks, ['Widget-visible task']);
    expect(bridge.displayMode, 'countAndTitles');
    expect(bridge.lockScreenTitlesEnabled, isTrue);
    expect(bridge.tapDestination, 'calendar');
  });
}

class _RecordingNativeWidgetBridge extends NativeWidgetBridge {
  _RecordingNativeWidgetBridge();

  WidgetDataSummary? publishedSummary;
  String? displayMode;
  bool? lockScreenTitlesEnabled;
  String? tapDestination;

  @override
  Future<void> publishTodaySnapshot(
    WidgetDataSummary summary, {
    required String displayMode,
    required bool lockScreenTitlesEnabled,
    required String tapDestination,
  }) async {
    publishedSummary = summary;
    this.displayMode = displayMode;
    this.lockScreenTitlesEnabled = lockScreenTitlesEnabled;
    this.tapDestination = tapDestination;
  }
}
