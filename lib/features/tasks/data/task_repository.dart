import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/time/flow_date_utils.dart';
import '../../../data/local/app_database.dart';
import '../domain/task_draft.dart';
import '../domain/task_enums.dart';

class TaskRepository {
  TaskRepository(this._db, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _now;
  final Uuid _uuid = const Uuid();

  Stream<List<TaskItem>> watchTodayTasks({
    required DateTime today,
    bool includeOverdue = false,
    bool includePersistent = true,
  }) {
    final day = dateOnly(today);
    final expression = _todayExpression(
      _db.taskItems,
      day: day,
      includeOverdue: includeOverdue,
      includePersistent: includePersistent,
    );

    final query = _db.select(_db.taskItems)
      ..where((task) => expression)
      ..orderBy([
        (task) => OrderingTerm.asc(task.dueTime),
        (task) => OrderingTerm.asc(task.sortOrder),
        (task) => OrderingTerm.asc(task.createdAt),
      ]);

    return query.watch();
  }

  Stream<List<TaskItem>> watchAllOpenTasks() {
    final query = _db.select(_db.taskItems)
      ..where(
        (task) =>
            task.status.equals(TaskStatus.open.value) & task.deletedAt.isNull(),
      )
      ..orderBy([
        (task) => OrderingTerm.asc(task.sortOrder),
        (task) => OrderingTerm.desc(task.createdAt),
      ]);
    return query.watch();
  }

  Stream<List<TaskItem>> watchCompletedTasks() {
    final query = _db.select(_db.taskItems)
      ..where((task) => task.status.equals(TaskStatus.completed.value))
      ..orderBy([(task) => OrderingTerm.desc(task.completedAt)]);
    return query.watch();
  }

  Stream<List<TaskItem>> watchTrashTasks() {
    final query = _db.select(_db.taskItems)
      ..where((task) => task.status.equals(TaskStatus.deleted.value))
      ..orderBy([(task) => OrderingTerm.desc(task.deletedAt)]);
    return query.watch();
  }

  Stream<List<TaskItem>> watchTasksForDate({
    required DateTime date,
    bool includeCompleted = false,
  }) {
    final day = dateOnly(date);
    final query = _db.select(_db.taskItems)
      ..where((task) {
        final statusExpression = includeCompleted
            ? task.status.isIn([
                TaskStatus.open.value,
                TaskStatus.completed.value,
              ])
            : task.status.equals(TaskStatus.open.value);
        return statusExpression &
            task.deletedAt.isNull() &
            task.dueDate.equals(day);
      })
      ..orderBy([
        (task) => OrderingTerm.asc(task.dueTime),
        (task) => OrderingTerm.asc(task.sortOrder),
        (task) => OrderingTerm.asc(task.createdAt),
      ]);
    return query.watch();
  }

  Stream<TaskItem?> watchTask(String id) {
    final query = _db.select(_db.taskItems)
      ..where((task) => task.id.equals(id));
    return query.watchSingleOrNull();
  }

  Stream<List<TaskList>> watchLists() {
    final query = _db.select(_db.taskLists)
      ..where((list) => list.isArchived.equals(false))
      ..orderBy([
        (list) => OrderingTerm.asc(list.sortOrder),
        (list) => OrderingTerm.asc(list.name),
      ]);
    return query.watch();
  }

  Stream<int> watchOpenCount() => _watchTaskCount(TaskStatus.open);

  Stream<int> watchCompletedCount() => _watchTaskCount(TaskStatus.completed);

  Stream<int> watchTrashCount() => _watchTaskCount(TaskStatus.deleted);

  Stream<int> watchInboxOpenCount() {
    final count = _db.taskItems.id.count();
    final query = _db.selectOnly(_db.taskItems)
      ..addColumns([count])
      ..where(
        _db.taskItems.status.equals(TaskStatus.open.value) &
            _db.taskItems.deletedAt.isNull() &
            _db.taskItems.listId.equals(AppDatabase.inboxListId),
      );
    return query.watchSingle().map((row) => row.read(count) ?? 0);
  }

  Future<TaskItem> createTask(TaskDraft draft) async {
    final title = draft.title.trim();
    if (title.isEmpty) {
      throw ArgumentError.value(draft.title, 'title', 'Task title is required');
    }

    final now = _now();
    final id = _uuid.v4();
    final dueDate = draft.dueDate == null ? null : dateOnly(draft.dueDate!);
    final startDate = draft.startDate == null
        ? null
        : dateOnly(draft.startDate!);
    final isPersistent = draft.isPersistent || draft.showInTodayUntilComplete;

    await _db
        .into(_db.taskItems)
        .insert(
          TaskItemsCompanion.insert(
            id: id,
            title: title,
            description: Value(_nullableText(draft.description)),
            status: Value(TaskStatus.open.value),
            priority: Value(draft.priority.value),
            listId: draft.listId ?? AppDatabase.inboxListId,
            groupId: Value(draft.groupId),
            createdAt: now,
            updatedAt: now,
            dueDate: Value(dueDate),
            dueTime: Value(draft.dueTime),
            startDate: Value(startDate),
            startTime: Value(draft.startTime),
            timeZone: draft.timeZone,
            isAllDay: Value(draft.isAllDay),
            isPersistent: Value(isPersistent),
            showInTodayUntilComplete: Value(isPersistent),
            persistentStartedAt: Value(isPersistent ? now : null),
            originalInput: Value(draft.originalInput),
            sortOrder: Value(draft.sortOrder),
          ),
        );

    return (_db.select(
      _db.taskItems,
    )..where((task) => task.id.equals(id))).getSingle();
  }

  Future<void> updateTask({
    required String id,
    required String title,
    String? description,
    TaskPriority priority = TaskPriority.none,
    DateTime? dueDate,
    String? dueTime,
    bool isAllDay = true,
  }) async {
    final now = _now();
    await (_db.update(
      _db.taskItems,
    )..where((task) => task.id.equals(id))).write(
      TaskItemsCompanion(
        title: Value(title.trim()),
        description: Value(_nullableText(description)),
        priority: Value(priority.value),
        dueDate: Value(dueDate == null ? null : dateOnly(dueDate)),
        dueTime: Value(_nullableText(dueTime)),
        isAllDay: Value(isAllDay),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> completeTask(String id) async {
    final now = _now();
    await (_db.update(
      _db.taskItems,
    )..where((task) => task.id.equals(id))).write(
      TaskItemsCompanion(
        status: Value(TaskStatus.completed.value),
        completedAt: Value(now),
        persistentCompletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> reopenTask(String id) async {
    final now = _now();
    await (_db.update(
      _db.taskItems,
    )..where((task) => task.id.equals(id))).write(
      TaskItemsCompanion(
        status: Value(TaskStatus.open.value),
        completedAt: const Value(null),
        persistentCompletedAt: const Value(null),
        deletedAt: const Value(null),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> moveTaskToTrash(String id) async {
    final now = _now();
    await (_db.update(
      _db.taskItems,
    )..where((task) => task.id.equals(id))).write(
      TaskItemsCompanion(
        status: Value(TaskStatus.deleted.value),
        deletedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> restoreTask(String id) async {
    final now = _now();
    await (_db.update(
      _db.taskItems,
    )..where((task) => task.id.equals(id))).write(
      TaskItemsCompanion(
        status: Value(TaskStatus.open.value),
        deletedAt: const Value(null),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> permanentlyDeleteTask(String id) async {
    await (_db.delete(_db.taskItems)..where((task) => task.id.equals(id))).go();
  }

  Future<int> dueTodayWidgetCount(DateTime today) async {
    final day = dateOnly(today);
    final count = _db.taskItems.id.count();
    final query = _db.selectOnly(_db.taskItems)
      ..addColumns([count])
      ..where(
        _db.taskItems.status.equals(TaskStatus.open.value) &
            _db.taskItems.completedAt.isNull() &
            _db.taskItems.deletedAt.isNull() &
            _db.taskItems.dueDate.equals(day),
      );
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Stream<int> _watchTaskCount(TaskStatus status) {
    final count = _db.taskItems.id.count();
    final query = _db.selectOnly(_db.taskItems)
      ..addColumns([count])
      ..where(_db.taskItems.status.equals(status.value));
    return query.watchSingle().map((row) => row.read(count) ?? 0);
  }

  Expression<bool> _todayExpression(
    TaskItems task, {
    required DateTime day,
    required bool includeOverdue,
    required bool includePersistent,
  }) {
    final dueToday = task.dueDate.equals(day);
    final overdue = includeOverdue
        ? task.dueDate.isSmallerThanValue(day)
        : const Constant(false);
    final persistent = includePersistent
        ? (task.isPersistent.equals(true) &
              task.showInTodayUntilComplete.equals(true))
        : const Constant(false);

    return task.status.equals(TaskStatus.open.value) &
        task.deletedAt.isNull() &
        (dueToday | overdue | persistent);
  }

  String? _nullableText(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
