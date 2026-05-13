import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/time/flow_date_utils.dart';
import '../../../data/local/app_database.dart';
import '../../settings/data/settings_repository.dart';
import '../../tasks/domain/task_enums.dart';
import 'native_widget_bridge.dart';

class WidgetDataSummary {
  WidgetDataSummary({
    required this.dueTodayCount,
    required this.generatedAt,
    required this.timeZone,
    required List<String> nextDueTodayTasks,
  }) : nextDueTodayTasks = List.unmodifiable(nextDueTodayTasks);

  factory WidgetDataSummary.fromSnapshot(WidgetSnapshotEntry snapshot) {
    final decoded = jsonDecode(snapshot.nextDueTodayTasksJson);
    final nextTasks = decoded is List
        ? decoded.whereType<String>().toList(growable: false)
        : const <String>[];

    return WidgetDataSummary(
      dueTodayCount: snapshot.dueTodayCount,
      generatedAt: snapshot.generatedAt,
      timeZone: snapshot.timeZone,
      nextDueTodayTasks: nextTasks,
    );
  }

  final int dueTodayCount;
  final DateTime generatedAt;
  final String timeZone;
  final List<String> nextDueTodayTasks;

  String get nextDueTodayTasksJson => jsonEncode(nextDueTodayTasks);
}

class WidgetDataService {
  WidgetDataService(
    this._db, {
    DateTime Function()? now,
    String Function()? timeZoneName,
    NativeWidgetBridge? nativeBridge,
  }) : _now = now ?? DateTime.now,
       _timeZoneName = timeZoneName,
       _nativeBridge = nativeBridge;

  static const todaySnapshotId = 'today_count_bubble';
  static const defaultMaxTaskTitles = 3;

  final AppDatabase _db;
  final DateTime Function() _now;
  final String Function()? _timeZoneName;
  final NativeWidgetBridge? _nativeBridge;

  Future<WidgetDataSummary> generateTodaySummary({
    DateTime? today,
    int maxTaskTitles = defaultMaxTaskTitles,
  }) async {
    final generatedAt = _now();
    final day = dateOnly(today ?? generatedAt);
    final dueTodayCount = await _dueTodayCount(day);
    final nextDueTodayTasks = await _nextDueTodayTaskTitles(
      day,
      limit: maxTaskTitles,
    );

    return WidgetDataSummary(
      dueTodayCount: dueTodayCount,
      generatedAt: generatedAt,
      timeZone: _timeZoneName?.call() ?? generatedAt.timeZoneName,
      nextDueTodayTasks: nextDueTodayTasks,
    );
  }

  Future<WidgetSnapshotEntry> refreshTodaySnapshot({
    DateTime? today,
    int maxTaskTitles = defaultMaxTaskTitles,
  }) async {
    final summary = await generateTodaySummary(
      today: today,
      maxTaskTitles: maxTaskTitles,
    );

    await _db
        .into(_db.widgetSnapshotEntries)
        .insertOnConflictUpdate(
          WidgetSnapshotEntriesCompanion.insert(
            id: todaySnapshotId,
            dueTodayCount: summary.dueTodayCount,
            generatedAt: summary.generatedAt,
            timeZone: summary.timeZone,
            nextDueTodayTasksJson: summary.nextDueTodayTasksJson,
          ),
        );

    final snapshot = (await readTodaySnapshot())!;
    await _publishNativeSnapshot(WidgetDataSummary.fromSnapshot(snapshot));
    return snapshot;
  }

  Future<WidgetSnapshotEntry?> readTodaySnapshot() {
    final query = _db.select(_db.widgetSnapshotEntries)
      ..where((snapshot) => snapshot.id.equals(todaySnapshotId));
    return query.getSingleOrNull();
  }

  Future<int> _dueTodayCount(DateTime day) async {
    final count = _db.taskItems.id.count();
    final query = _db.selectOnly(_db.taskItems)
      ..addColumns([count])
      ..where(_dueTodayWidgetExpression(_db.taskItems, day));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Future<List<String>> _nextDueTodayTaskTitles(
    DateTime day, {
    required int limit,
  }) async {
    if (limit <= 0) {
      return const [];
    }

    final query = _db.select(_db.taskItems)
      ..where((task) => _dueTodayWidgetExpression(task, day))
      ..orderBy([
        (task) => OrderingTerm.asc(task.dueTime),
        (task) => OrderingTerm.asc(task.sortOrder),
        (task) => OrderingTerm.asc(task.createdAt),
      ])
      ..limit(limit);
    final tasks = await query.get();
    return tasks.map((task) => task.title).toList(growable: false);
  }

  Expression<bool> _dueTodayWidgetExpression(TaskItems task, DateTime day) {
    return task.status.equals(TaskStatus.open.value) &
        task.completedAt.isNull() &
        task.deletedAt.isNull() &
        task.dueDate.equals(day);
  }

  Future<void> _publishNativeSnapshot(WidgetDataSummary summary) async {
    final bridge = _nativeBridge;
    if (bridge == null) {
      return;
    }
    final settings = await _readWidgetSettings();
    await bridge.publishTodaySnapshot(
      summary,
      displayMode: settings.widgetDisplayMode,
      lockScreenTitlesEnabled: settings.widgetShowsLockScreenTitles,
      tapDestination: settings.widgetTapDestination,
    );
  }

  Future<FlowTaskSettings> _readWidgetSettings() async {
    final entries = await _db.select(_db.settingsEntries).get();
    return FlowTaskSettings.fromEntries(entries);
  }
}
