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
  }) async* {
    await refreshPersistentCarryForwardCounts(today);

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

    yield* query.watch();
  }

  Stream<List<TaskItem>> watchOverdueTasks({required DateTime today}) {
    final day = dateOnly(today);
    final query = _db.select(_db.taskItems)
      ..where(
        (task) =>
            task.status.equals(TaskStatus.open.value) &
            task.deletedAt.isNull() &
            task.dueDate.isSmallerThanValue(day),
      )
      ..orderBy([
        (task) => OrderingTerm.asc(task.dueDate),
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
            _calendarDateExpression(task, day);
      })
      ..orderBy([
        (task) => OrderingTerm.asc(task.recurrenceOccurrenceDate),
        (task) => OrderingTerm.asc(task.dueDate),
        (task) => OrderingTerm.asc(task.dueTime),
        (task) => OrderingTerm.asc(task.sortOrder),
        (task) => OrderingTerm.asc(task.createdAt),
      ]);
    return query.watch();
  }

  Stream<List<TaskItem>> watchCalendarTasksForRange({
    required DateTime start,
    required DateTime end,
    bool includeCompleted = false,
  }) {
    final rangeStart = dateOnly(start);
    final rangeEnd = dateOnly(end);
    final query = _db.select(_db.taskItems)
      ..where((task) {
        final statusExpression = includeCompleted
            ? task.status.isIn([
                TaskStatus.open.value,
                TaskStatus.completed.value,
              ])
            : task.status.equals(TaskStatus.open.value);
        final dueInRange =
            task.recurrenceOccurrenceDate.isNull() &
            task.dueDate.isBetweenValues(rangeStart, rangeEnd);
        final occurrenceInRange = task.recurrenceOccurrenceDate.isBetweenValues(
          rangeStart,
          rangeEnd,
        );
        return statusExpression &
            task.deletedAt.isNull() &
            (dueInRange | occurrenceInRange);
      })
      ..orderBy([
        (task) => OrderingTerm.asc(task.recurrenceOccurrenceDate),
        (task) => OrderingTerm.asc(task.dueDate),
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

  Stream<List<ListGroup>> watchGroupsForList(String listId) {
    final query = _db.select(_db.listGroups)
      ..where((group) => group.listId.equals(listId))
      ..orderBy([
        (group) => OrderingTerm.asc(group.sortOrder),
        (group) => OrderingTerm.asc(group.name),
      ]);
    return query.watch();
  }

  Stream<List<ReminderEntry>> watchRemindersForTask(String taskId) {
    final query = _db.select(_db.reminderEntries)
      ..where((reminder) => reminder.taskId.equals(taskId))
      ..orderBy([(reminder) => OrderingTerm.asc(reminder.remindAt)]);
    return query.watch();
  }

  Stream<RecurrenceRuleEntry?> watchRecurrenceRule(String id) {
    final query = _db.select(_db.recurrenceRuleEntries)
      ..where((rule) => rule.id.equals(id));
    return query.watchSingleOrNull();
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
    final isPersistent =
        draft.isPersistent ||
        draft.showInTodayUntilComplete ||
        _hasPersistentTrigger(draft.originalInput);
    final recurrenceRuleId = draft.repeatRule == null ? null : _uuid.v4();

    await _db.transaction(() async {
      if (recurrenceRuleId != null) {
        await _upsertRepeatRule(recurrenceRuleId, draft.repeatRule!, now);
      }

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
              dueTime: Value(_nullableText(draft.dueTime)),
              startDate: Value(startDate),
              startTime: Value(_nullableText(draft.startTime)),
              timeZone: draft.timeZone,
              isAllDay: Value(draft.isAllDay),
              isPersistent: Value(isPersistent),
              showInTodayUntilComplete: Value(isPersistent),
              persistentStartedAt: Value(isPersistent ? now : null),
              recurrenceRuleId: Value(recurrenceRuleId),
              originalInput: Value(draft.originalInput),
              sortOrder: Value(draft.sortOrder),
            ),
          );

      if (draft.reminders.isNotEmpty) {
        await _replaceReminders(id, draft.reminders, now);
      }
    });

    return (_db.select(
      _db.taskItems,
    )..where((task) => task.id.equals(id))).getSingle();
  }

  Future<void> updateTask({
    required String id,
    required String title,
    String? description,
    TaskPriority priority = TaskPriority.none,
    String? listId,
    bool updateGroup = false,
    String? groupId,
    DateTime? dueDate,
    String? dueTime,
    bool isAllDay = true,
    bool? isPersistent,
    bool? showInTodayUntilComplete,
    bool updateReminders = false,
    List<TaskReminderDraft> reminders = const [],
    bool updateRepeatRule = false,
    TaskRepeatDraft? repeatRule,
  }) async {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      throw ArgumentError.value(title, 'title', 'Task title is required');
    }

    final now = _now();
    final existing = await _taskById(id);
    final existingRuleId = existing?.recurrenceRuleId;
    final nextRuleId = updateRepeatRule && repeatRule != null
        ? existingRuleId ?? _uuid.v4()
        : null;

    final persistentChanged =
        isPersistent != null || showInTodayUntilComplete != null;
    final nextPersistent = isPersistent ?? existing?.isPersistent ?? false;
    final nextShowInToday =
        showInTodayUntilComplete ??
        existing?.showInTodayUntilComplete ??
        nextPersistent;
    final keepPersistent = nextPersistent || nextShowInToday;

    await _db.transaction(() async {
      if (updateRepeatRule && repeatRule != null) {
        await _upsertRepeatRule(nextRuleId!, repeatRule, now);
      }

      await (_db.update(
        _db.taskItems,
      )..where((task) => task.id.equals(id))).write(
        TaskItemsCompanion(
          title: Value(trimmedTitle),
          description: Value(_nullableText(description)),
          priority: Value(priority.value),
          listId: listId == null ? const Value.absent() : Value(listId),
          groupId: updateGroup ? Value(groupId) : const Value.absent(),
          dueDate: Value(dueDate == null ? null : dateOnly(dueDate)),
          dueTime: Value(_nullableText(dueTime)),
          isAllDay: Value(isAllDay),
          isPersistent: persistentChanged
              ? Value(keepPersistent)
              : const Value.absent(),
          showInTodayUntilComplete: persistentChanged
              ? Value(keepPersistent)
              : const Value.absent(),
          persistentStartedAt: persistentChanged
              ? Value(
                  keepPersistent ? existing?.persistentStartedAt ?? now : null,
                )
              : const Value.absent(),
          persistentCompletedAt: persistentChanged && !keepPersistent
              ? const Value(null)
              : const Value.absent(),
          todayCarryForwardCount: persistentChanged && !keepPersistent
              ? const Value(0)
              : const Value.absent(),
          lastCarriedForwardAt: persistentChanged && !keepPersistent
              ? const Value(null)
              : const Value.absent(),
          recurrenceRuleId: updateRepeatRule
              ? Value(nextRuleId)
              : const Value.absent(),
          updatedAt: Value(now),
        ),
      );

      if (updateReminders) {
        await _replaceReminders(id, reminders, now);
      }

      if (updateRepeatRule && repeatRule == null && existingRuleId != null) {
        await _deleteRepeatRuleIfUnused(existingRuleId);
      }
    });
  }

  Future<void> moveTaskToDate({
    required String id,
    required DateTime date,
  }) async {
    final now = _now();
    final targetDate = dateOnly(date);
    final task = await (_db.select(
      _db.taskItems,
    )..where((task) => task.id.equals(id))).getSingleOrNull();
    if (task == null) {
      return;
    }

    await (_db.update(
      _db.taskItems,
    )..where((task) => task.id.equals(id))).write(
      TaskItemsCompanion(
        dueDate: Value(targetDate),
        recurrenceOccurrenceDate: task.recurrenceOccurrenceDate == null
            ? const Value.absent()
            : Value(targetDate),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> clearTaskDate(String id) async {
    final now = _now();
    await (_db.update(
      _db.taskItems,
    )..where((task) => task.id.equals(id))).write(
      TaskItemsCompanion(
        dueDate: const Value(null),
        dueTime: const Value(null),
        recurrenceOccurrenceDate: const Value(null),
        isAllDay: const Value(true),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> completeTask(String id) async {
    final now = _now();
    await _db.transaction(() async {
      final task = await _taskById(id);
      if (task == null) {
        return;
      }

      final wasCompleted =
          TaskStatus.fromValue(task.status) == TaskStatus.completed;

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

      if (!wasCompleted) {
        await _createOrReuseNextOccurrence(task, now);
      }
    });
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
        completedAt: const Value(null),
        persistentCompletedAt: const Value(null),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> permanentlyDeleteTask(String id) async {
    final task = await _taskById(id);
    await _db.transaction(() async {
      await (_db.delete(
        _db.reminderEntries,
      )..where((reminder) => reminder.taskId.equals(id))).go();
      await (_db.delete(
        _db.taskItems,
      )..where((task) => task.id.equals(id))).go();
      final recurrenceRuleId = task?.recurrenceRuleId;
      if (recurrenceRuleId != null) {
        await _deleteRepeatRuleIfUnused(recurrenceRuleId);
      }
    });
  }

  Future<void> refreshPersistentCarryForwardCounts(DateTime today) async {
    final day = dateOnly(today);
    final query = _db.select(_db.taskItems)
      ..where(
        (task) =>
            task.status.equals(TaskStatus.open.value) &
            task.deletedAt.isNull() &
            task.isPersistent.equals(true) &
            task.showInTodayUntilComplete.equals(true),
      );
    final tasks = await query.get();

    await _db.transaction(() async {
      for (final task in tasks) {
        final startedOn = dateOnly(task.persistentStartedAt ?? task.createdAt);
        final carriedDays = day.difference(startedOn).inDays;
        final nextCount = carriedDays < 0 ? 0 : carriedDays;
        final nextLastCarried = nextCount > 0 ? day : null;
        final currentLastCarried = task.lastCarriedForwardAt == null
            ? null
            : dateOnly(task.lastCarriedForwardAt!);
        final lastCarriedChanged =
            (currentLastCarried == null && nextLastCarried != null) ||
            (currentLastCarried != null && nextLastCarried == null) ||
            (currentLastCarried != null &&
                nextLastCarried != null &&
                !isSameLocalDate(currentLastCarried, nextLastCarried));

        if (task.todayCarryForwardCount == nextCount && !lastCarriedChanged) {
          continue;
        }

        await (_db.update(
          _db.taskItems,
        )..where((row) => row.id.equals(task.id))).write(
          TaskItemsCompanion(
            todayCarryForwardCount: Value(nextCount),
            lastCarriedForwardAt: Value(nextLastCarried),
          ),
        );
      }
    });
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

  Future<TaskItem?> _taskById(String id) {
    final query = _db.select(_db.taskItems)
      ..where((task) => task.id.equals(id));
    return query.getSingleOrNull();
  }

  Future<RecurrenceRuleEntry?> _repeatRuleById(String id) {
    final query = _db.select(_db.recurrenceRuleEntries)
      ..where((rule) => rule.id.equals(id));
    return query.getSingleOrNull();
  }

  Future<void> _createOrReuseNextOccurrence(
    TaskItem completedTask,
    DateTime now,
  ) async {
    final recurrenceRuleId = completedTask.recurrenceRuleId;
    if (recurrenceRuleId == null) {
      return;
    }

    final rule = await _repeatRuleById(recurrenceRuleId);
    if (rule == null) {
      return;
    }

    final parentTaskId =
        completedTask.recurrenceParentTaskId ?? completedTask.id;
    final rootTask = completedTask.recurrenceParentTaskId == null
        ? completedTask
        : await _taskById(parentTaskId);
    final anchorDate = _taskOccurrenceDate(rootTask ?? completedTask, now);
    final currentDate = _taskOccurrenceDate(completedTask, now);
    final nextDate = _nextOccurrenceDate(
      rule,
      currentDate: currentDate,
      anchorDate: anchorDate,
    );
    if (nextDate == null || !_allowsOccurrenceDate(rule, nextDate)) {
      return;
    }

    final existingOccurrence = await _openOccurrenceForDate(
      recurrenceRuleId: recurrenceRuleId,
      parentTaskId: parentTaskId,
      occurrenceDate: nextDate,
    );
    if (existingOccurrence != null) {
      return;
    }

    final occurrenceCount = await _seriesOccurrenceCount(
      recurrenceRuleId: recurrenceRuleId,
      parentTaskId: parentTaskId,
    );
    if (!_allowsOccurrenceCount(rule, occurrenceCount)) {
      return;
    }

    await _insertNextOccurrence(
      source: completedTask,
      parentTaskId: parentTaskId,
      recurrenceRuleId: recurrenceRuleId,
      currentDate: currentDate,
      nextDate: nextDate,
      now: now,
    );
  }

  Future<TaskItem?> _openOccurrenceForDate({
    required String recurrenceRuleId,
    required String parentTaskId,
    required DateTime occurrenceDate,
  }) async {
    final query = _db.select(_db.taskItems)
      ..where(
        (task) =>
            task.status.equals(TaskStatus.open.value) &
            task.deletedAt.isNull() &
            task.recurrenceRuleId.equals(recurrenceRuleId) &
            task.recurrenceParentTaskId.equals(parentTaskId) &
            task.recurrenceOccurrenceDate.equals(occurrenceDate),
      )
      ..orderBy([(task) => OrderingTerm.asc(task.createdAt)])
      ..limit(1);
    final occurrences = await query.get();
    return occurrences.firstOrNull;
  }

  Future<int> _seriesOccurrenceCount({
    required String recurrenceRuleId,
    required String parentTaskId,
  }) async {
    final count = _db.taskItems.id.count();
    final sameSeries =
        _db.taskItems.id.equals(parentTaskId) |
        _db.taskItems.recurrenceParentTaskId.equals(parentTaskId);
    final query = _db.selectOnly(_db.taskItems)
      ..addColumns([count])
      ..where(
        _db.taskItems.recurrenceRuleId.equals(recurrenceRuleId) & sameSeries,
      );
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  Future<void> _insertNextOccurrence({
    required TaskItem source,
    required String parentTaskId,
    required String recurrenceRuleId,
    required DateTime currentDate,
    required DateTime nextDate,
    required DateTime now,
  }) async {
    final id = _uuid.v4();
    final keepPersistent =
        source.isPersistent || source.showInTodayUntilComplete;
    final dayDelta = nextDate.difference(currentDate).inDays;

    await _db
        .into(_db.taskItems)
        .insert(
          TaskItemsCompanion.insert(
            id: id,
            title: source.title,
            description: Value(source.description),
            status: Value(TaskStatus.open.value),
            priority: Value(source.priority),
            listId: source.listId,
            groupId: Value(source.groupId),
            createdAt: now,
            updatedAt: now,
            dueDate: Value(nextDate),
            dueTime: Value(source.dueTime),
            startDate: Value(_shiftDate(source.startDate, dayDelta)),
            startTime: Value(source.startTime),
            timeZone: source.timeZone,
            isAllDay: Value(source.isAllDay),
            isPersistent: Value(keepPersistent),
            showInTodayUntilComplete: Value(keepPersistent),
            persistentStartedAt: Value(keepPersistent ? now : null),
            recurrenceRuleId: Value(recurrenceRuleId),
            recurrenceParentTaskId: Value(parentTaskId),
            recurrenceOccurrenceDate: Value(nextDate),
            originalInput: Value(source.originalInput),
            sortOrder: Value(source.sortOrder),
          ),
        );

    await _copyRemindersToOccurrence(
      sourceTaskId: source.id,
      targetTaskId: id,
      dayDelta: dayDelta,
      now: now,
    );
  }

  Future<void> _copyRemindersToOccurrence({
    required String sourceTaskId,
    required String targetTaskId,
    required int dayDelta,
    required DateTime now,
  }) async {
    final query = _db.select(_db.reminderEntries)
      ..where((reminder) => reminder.taskId.equals(sourceTaskId));
    final reminders = await query.get();
    if (reminders.isEmpty) {
      return;
    }

    await _replaceReminders(targetTaskId, [
      for (final reminder in reminders)
        TaskReminderDraft(
          remindAt: reminder.remindAt.add(Duration(days: dayDelta)),
          reminderType: reminder.reminderType,
          offsetMinutes: reminder.offsetMinutes,
          isEnabled: reminder.isEnabled,
        ),
    ], now);
  }

  DateTime _taskOccurrenceDate(TaskItem task, DateTime fallback) {
    return dateOnly(
      task.recurrenceOccurrenceDate ??
          task.dueDate ??
          task.startDate ??
          fallback,
    );
  }

  DateTime? _nextOccurrenceDate(
    RecurrenceRuleEntry rule, {
    required DateTime currentDate,
    required DateTime anchorDate,
  }) {
    final interval = rule.repeatInterval < 1 ? 1 : rule.repeatInterval;
    final frequency = TaskRepeatFrequency.fromValue(rule.repeatFrequency);

    return switch (frequency) {
      TaskRepeatFrequency.daily => dateOnly(
        currentDate.add(Duration(days: interval)),
      ),
      TaskRepeatFrequency.weekly => _nextWeeklyOccurrenceDate(
        rule,
        currentDate: currentDate,
        anchorDate: anchorDate,
        interval: interval,
      ),
      TaskRepeatFrequency.monthly => _nextMonthlyOccurrenceDate(
        rule,
        currentDate: currentDate,
        anchorDate: anchorDate,
        interval: interval,
      ),
      TaskRepeatFrequency.yearly => _dateInMonth(
        currentDate.year + interval,
        anchorDate.month,
        anchorDate.day,
      ),
    };
  }

  DateTime? _nextWeeklyOccurrenceDate(
    RecurrenceRuleEntry rule, {
    required DateTime currentDate,
    required DateTime anchorDate,
    required int interval,
  }) {
    final weekdays = _repeatWeekdays(rule, fallback: currentDate.weekday);
    final anchorWeekStart = _weekStart(anchorDate);
    final searchLimit = Duration(days: (interval * 7) + 7);
    var candidate = dateOnly(currentDate).add(const Duration(days: 1));
    final endSearch = dateOnly(currentDate).add(searchLimit);

    while (!candidate.isAfter(endSearch)) {
      final candidateWeekStart = _weekStart(candidate);
      final weeksSinceAnchor =
          candidateWeekStart.difference(anchorWeekStart).inDays ~/ 7;
      if (weeksSinceAnchor >= 0 &&
          weeksSinceAnchor % interval == 0 &&
          weekdays.contains(candidate.weekday)) {
        return candidate;
      }
      candidate = candidate.add(const Duration(days: 1));
    }

    return null;
  }

  DateTime _nextMonthlyOccurrenceDate(
    RecurrenceRuleEntry rule, {
    required DateTime currentDate,
    required DateTime anchorDate,
    required int interval,
  }) {
    final ordinal = rule.repeatMonthOrdinal;
    final weekday = rule.repeatMonthWeekday;
    if (ordinal != null &&
        weekday != null &&
        weekday >= DateTime.monday &&
        weekday <= DateTime.sunday) {
      return _ordinalWeekdayInMonthAfter(
        currentDate,
        interval: interval,
        ordinal: ordinal,
        weekday: weekday,
      );
    }
    return _addMonths(
      currentDate,
      interval,
      day: rule.repeatMonthDay ?? anchorDate.day,
    );
  }

  List<int> _repeatWeekdays(RecurrenceRuleEntry rule, {required int fallback}) {
    final parsed =
        rule.repeatWeekdays
            ?.split(',')
            .map((weekday) => int.tryParse(weekday.trim()))
            .whereType<int>()
            .where(
              (weekday) =>
                  weekday >= DateTime.monday && weekday <= DateTime.sunday,
            )
            .toSet()
            .toList()
          ?..sort();
    if (parsed == null || parsed.isEmpty) {
      return [fallback];
    }
    return parsed;
  }

  bool _allowsOccurrenceDate(
    RecurrenceRuleEntry rule,
    DateTime occurrenceDate,
  ) {
    final endType = rule.repeatEndType.toLowerCase();
    final endDate = rule.repeatEndDate == null
        ? null
        : dateOnly(rule.repeatEndDate!);
    final usesEndDate =
        endType == 'date' ||
        endType == 'enddate' ||
        endType == 'on' ||
        endType == 'ondate' ||
        endType == 'until';
    if (usesEndDate && endDate != null && occurrenceDate.isAfter(endDate)) {
      return false;
    }
    return true;
  }

  bool _allowsOccurrenceCount(RecurrenceRuleEntry rule, int existingCount) {
    final endType = rule.repeatEndType.toLowerCase();
    final usesCount =
        endType == 'count' ||
        endType == 'after' ||
        endType == 'occurrences' ||
        endType == 'afteroccurrences';
    final occurrenceCount = rule.repeatOccurrenceCount;
    if (usesCount &&
        occurrenceCount != null &&
        existingCount >= occurrenceCount) {
      return false;
    }
    return true;
  }

  DateTime? _shiftDate(DateTime? date, int days) {
    if (date == null) {
      return null;
    }
    return dateOnly(date.add(Duration(days: days)));
  }

  DateTime _weekStart(DateTime date) {
    return dateOnly(
      date,
    ).subtract(Duration(days: date.weekday - DateTime.monday));
  }

  DateTime _addMonths(DateTime date, int months, {required int day}) {
    final monthIndex = (date.year * 12) + (date.month - 1) + months;
    final year = monthIndex ~/ 12;
    final month = (monthIndex % 12) + 1;
    return _dateInMonth(year, month, day);
  }

  DateTime _ordinalWeekdayInMonthAfter(
    DateTime date, {
    required int interval,
    required int ordinal,
    required int weekday,
  }) {
    var monthIndex = (date.year * 12) + (date.month - 1) + interval;
    while (true) {
      final candidate = _ordinalWeekdayInMonth(
        monthIndex ~/ 12,
        (monthIndex % 12) + 1,
        ordinal: ordinal,
        weekday: weekday,
      );
      if (candidate.isAfter(date)) {
        return candidate;
      }
      monthIndex += interval;
    }
  }

  DateTime _ordinalWeekdayInMonth(
    int year,
    int month, {
    required int ordinal,
    required int weekday,
  }) {
    if (ordinal < 0) {
      var candidate = DateTime(year, month + 1, 0);
      while (candidate.weekday != weekday) {
        candidate = candidate.subtract(const Duration(days: 1));
      }
      return candidate;
    }

    final safeOrdinal = ordinal < 1 ? 1 : ordinal;
    var candidate = DateTime(year, month, 1);
    while (candidate.weekday != weekday) {
      candidate = candidate.add(const Duration(days: 1));
    }
    candidate = candidate.add(Duration(days: (safeOrdinal - 1) * 7));
    if (candidate.month != month) {
      return _ordinalWeekdayInMonth(year, month, ordinal: -1, weekday: weekday);
    }
    return candidate;
  }

  DateTime _dateInMonth(int year, int month, int day) {
    final lastDay = DateTime(year, month + 1, 0).day;
    final clampedDay = day < 1 ? 1 : (day > lastDay ? lastDay : day);
    return DateTime(year, month, clampedDay);
  }

  Future<void> _replaceReminders(
    String taskId,
    List<TaskReminderDraft> reminders,
    DateTime now,
  ) async {
    await (_db.delete(
      _db.reminderEntries,
    )..where((reminder) => reminder.taskId.equals(taskId))).go();

    for (final reminder in reminders) {
      await _db
          .into(_db.reminderEntries)
          .insert(
            ReminderEntriesCompanion.insert(
              id: _uuid.v4(),
              taskId: taskId,
              reminderType: reminder.reminderType,
              remindAt: reminder.remindAt,
              offsetMinutes: Value(reminder.offsetMinutes),
              isEnabled: Value(reminder.isEnabled),
              createdAt: now,
              updatedAt: now,
            ),
          );
    }
  }

  Future<void> _upsertRepeatRule(
    String id,
    TaskRepeatDraft draft,
    DateTime now,
  ) {
    return _db
        .into(_db.recurrenceRuleEntries)
        .insertOnConflictUpdate(
          RecurrenceRuleEntriesCompanion.insert(
            id: id,
            repeatFrequency: draft.frequency.value,
            repeatInterval: Value(draft.interval),
            repeatWeekdays: Value(_nullableText(draft.weekdays)),
            repeatMonthDay: Value(draft.monthDay),
            repeatMonthOrdinal: Value(draft.monthOrdinal),
            repeatMonthWeekday: Value(draft.monthWeekday),
            repeatEndType: Value(draft.endType),
            repeatEndDate: Value(
              draft.endDate == null ? null : dateOnly(draft.endDate!),
            ),
            repeatOccurrenceCount: Value(draft.occurrenceCount),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<void> _deleteRepeatRuleIfUnused(String recurrenceRuleId) async {
    final count = _db.taskItems.id.count();
    final query = _db.selectOnly(_db.taskItems)
      ..addColumns([count])
      ..where(_db.taskItems.recurrenceRuleId.equals(recurrenceRuleId));
    final row = await query.getSingle();
    if ((row.read(count) ?? 0) == 0) {
      await (_db.delete(
        _db.recurrenceRuleEntries,
      )..where((rule) => rule.id.equals(recurrenceRuleId))).go();
    }
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

  Expression<bool> _calendarDateExpression(TaskItems task, DateTime day) {
    final normalDueDate =
        task.recurrenceOccurrenceDate.isNull() & task.dueDate.equals(day);
    final recurrenceOccurrence = task.recurrenceOccurrenceDate.equals(day);
    return normalDueDate | recurrenceOccurrence;
  }

  String? _nullableText(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  bool _hasPersistentTrigger(String? value) {
    final input = value?.toLowerCase();
    if (input == null || input.trim().isEmpty) {
      return false;
    }
    const triggers = [
      'keep in today',
      'until complete',
      'until done',
      'carry forward',
      'persistent task',
      'keep showing',
      'stay in today',
    ];
    return triggers.any(input.contains);
  }
}
