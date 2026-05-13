import 'dart:async';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/time/flow_date_utils.dart';
import '../../../data/local/app_database.dart';
import '../../tasks/domain/task_enums.dart';

enum ListTaskGroupingMode {
  manualGroups,
  none,
  dueDate,
  priority,
  status,
  persistent,
}

enum ListTaskSortMode { manual, dueDate, priority, createdDate, title }

enum DeleteGroupTaskDisposition { moveToUngrouped, deleteTasks, moveToGroup }

class TaskListSummary {
  const TaskListSummary({required this.list, required this.openTaskCount});

  final TaskList list;
  final int openTaskCount;
}

class ListTaskSection {
  const ListTaskSection({
    required this.id,
    required this.title,
    required this.tasks,
    this.groupId,
    this.sortOrder = 0,
    this.isCollapsed = false,
    this.isUngrouped = false,
  });

  final String id;
  final String title;
  final String? groupId;
  final int sortOrder;
  final bool isCollapsed;
  final bool isUngrouped;
  final List<TaskItem> tasks;
}

class ListGroupRepository {
  ListGroupRepository(this._db, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final AppDatabase _db;
  final DateTime Function() _now;
  final Uuid _uuid = const Uuid();

  Stream<List<TaskListSummary>> watchListSummaries() {
    final openCount = _db.taskItems.id.count();
    final query =
        _db.select(_db.taskLists).join([
            leftOuterJoin(
              _db.taskItems,
              _db.taskItems.listId.equalsExp(_db.taskLists.id) &
                  _db.taskItems.status.equals(TaskStatus.open.value) &
                  _db.taskItems.deletedAt.isNull(),
              useColumns: false,
            ),
          ])
          ..where(_db.taskLists.isArchived.equals(false))
          ..addColumns([openCount])
          ..groupBy([_db.taskLists.id])
          ..orderBy([
            OrderingTerm.asc(_db.taskLists.sortOrder),
            OrderingTerm.asc(_db.taskLists.name),
          ]);

    return query.watch().map((rows) {
      return [
        for (final row in rows)
          TaskListSummary(
            list: row.readTable(_db.taskLists),
            openTaskCount: row.read(openCount) ?? 0,
          ),
      ];
    });
  }

  Stream<List<ListGroup>> watchGroups(String listId) {
    final query = _db.select(_db.listGroups)
      ..where((group) => group.listId.equals(listId))
      ..orderBy([
        (group) => OrderingTerm.asc(group.sortOrder),
        (group) => OrderingTerm.asc(group.name),
      ]);
    return query.watch();
  }

  Stream<List<ListTaskSection>> watchListTaskSections({
    required String listId,
    ListTaskGroupingMode groupingMode = ListTaskGroupingMode.manualGroups,
    ListTaskSortMode sortMode = ListTaskSortMode.manual,
  }) {
    final groupsStream = watchGroups(listId);
    final tasksQuery = _db.select(_db.taskItems)
      ..where(
        (task) =>
            task.listId.equals(listId) &
            task.status.equals(TaskStatus.open.value) &
            task.deletedAt.isNull(),
      );
    final tasksStream = tasksQuery.watch();

    return _combineLatest2<
      List<ListGroup>,
      List<TaskItem>,
      List<ListTaskSection>
    >(
      groupsStream,
      tasksStream,
      (groups, tasks) => _buildSections(
        groups: groups,
        tasks: tasks,
        groupingMode: groupingMode,
        sortMode: sortMode,
      ),
    );
  }

  Future<TaskList> createList({
    required String name,
    String color = '#4774FA',
    String? icon,
  }) async {
    final now = _now();
    final id = _uuid.v4();
    await _db
        .into(_db.taskLists)
        .insert(
          TaskListsCompanion.insert(
            id: id,
            name: _requiredName(name),
            color: Value(_normalizeColor(color)),
            icon: Value(_nullableText(icon)),
            sortOrder: Value(await _nextListSortOrder()),
            createdAt: now,
            updatedAt: now,
          ),
        );
    return (_db.select(
      _db.taskLists,
    )..where((list) => list.id.equals(id))).getSingle();
  }

  Future<void> renameList({required String id, required String name}) async {
    await _requireEditableList(id);
    await (_db.update(
      _db.taskLists,
    )..where((list) => list.id.equals(id))).write(
      TaskListsCompanion(
        name: Value(_requiredName(name)),
        updatedAt: Value(_now()),
      ),
    );
  }

  Future<void> updateListStyle({
    required String id,
    required String color,
    String? icon,
  }) async {
    await _requireList(id);
    await (_db.update(
      _db.taskLists,
    )..where((list) => list.id.equals(id))).write(
      TaskListsCompanion(
        color: Value(_normalizeColor(color)),
        icon: Value(_nullableText(icon)),
        updatedAt: Value(_now()),
      ),
    );
  }

  Future<void> deleteList(String id) async {
    final list = await _requireEditableList(id);
    await _db.transaction(() async {
      final now = _now();
      await (_db.update(
        _db.taskItems,
      )..where((task) => task.listId.equals(list.id))).write(
        TaskItemsCompanion(
          listId: const Value(AppDatabase.inboxListId),
          groupId: const Value(null),
          updatedAt: Value(now),
        ),
      );
      await (_db.delete(
        _db.listGroups,
      )..where((group) => group.listId.equals(list.id))).go();
      await (_db.delete(
        _db.taskLists,
      )..where((taskList) => taskList.id.equals(list.id))).go();
    });
  }

  Future<void> reorderLists(List<String> orderedIds) async {
    final now = _now();
    await _db.transaction(() async {
      for (var index = 0; index < orderedIds.length; index += 1) {
        await (_db.update(
          _db.taskLists,
        )..where((list) => list.id.equals(orderedIds[index]))).write(
          TaskListsCompanion(sortOrder: Value(index), updatedAt: Value(now)),
        );
      }
    });
  }

  Future<ListGroup> createGroup({
    required String listId,
    required String name,
  }) async {
    await _requireList(listId);
    final now = _now();
    final id = _uuid.v4();
    await _db
        .into(_db.listGroups)
        .insert(
          ListGroupsCompanion.insert(
            id: id,
            listId: listId,
            name: _requiredName(name),
            sortOrder: Value(await _nextGroupSortOrder(listId)),
            createdAt: now,
            updatedAt: now,
          ),
        );
    return (_db.select(
      _db.listGroups,
    )..where((group) => group.id.equals(id))).getSingle();
  }

  Future<void> renameGroup({required String id, required String name}) async {
    await _requireGroup(id);
    await (_db.update(
      _db.listGroups,
    )..where((group) => group.id.equals(id))).write(
      ListGroupsCompanion(
        name: Value(_requiredName(name)),
        updatedAt: Value(_now()),
      ),
    );
  }

  Future<void> setGroupCollapsed({
    required String id,
    required bool isCollapsed,
  }) async {
    await _requireGroup(id);
    await (_db.update(
      _db.listGroups,
    )..where((group) => group.id.equals(id))).write(
      ListGroupsCompanion(
        isCollapsed: Value(isCollapsed),
        updatedAt: Value(_now()),
      ),
    );
  }

  Future<void> deleteGroup(
    String id, {
    DeleteGroupTaskDisposition taskDisposition =
        DeleteGroupTaskDisposition.moveToUngrouped,
    String? targetGroupId,
  }) async {
    final group = await _requireGroup(id);
    ListGroup? targetGroup;
    if (taskDisposition == DeleteGroupTaskDisposition.moveToGroup) {
      if (targetGroupId == null || targetGroupId == group.id) {
        throw StateError('Choose another group before deleting this group.');
      }
      targetGroup = await _requireGroup(targetGroupId);
      if (targetGroup.listId != group.listId) {
        throw StateError('Target group must belong to the same list.');
      }
    }

    await _db.transaction(() async {
      final now = _now();
      final taskUpdate = switch (taskDisposition) {
        DeleteGroupTaskDisposition.moveToUngrouped => TaskItemsCompanion(
          groupId: const Value(null),
          updatedAt: Value(now),
        ),
        DeleteGroupTaskDisposition.moveToGroup => TaskItemsCompanion(
          groupId: Value(targetGroup!.id),
          updatedAt: Value(now),
        ),
        DeleteGroupTaskDisposition.deleteTasks => TaskItemsCompanion(
          status: Value(TaskStatus.deleted.value),
          deletedAt: Value(now),
          completedAt: const Value(null),
          persistentCompletedAt: const Value(null),
          updatedAt: Value(now),
        ),
      };
      await (_db.update(
        _db.taskItems,
      )..where((task) => task.groupId.equals(group.id))).write(taskUpdate);
      await (_db.delete(
        _db.listGroups,
      )..where((item) => item.id.equals(group.id))).go();
    });
  }

  Future<void> reorderGroups({
    required String listId,
    required List<String> orderedIds,
  }) async {
    await _requireList(listId);
    final now = _now();
    await _db.transaction(() async {
      for (var index = 0; index < orderedIds.length; index += 1) {
        await (_db.update(_db.listGroups)..where(
              (group) =>
                  group.id.equals(orderedIds[index]) &
                  group.listId.equals(listId),
            ))
            .write(
              ListGroupsCompanion(
                sortOrder: Value(index),
                updatedAt: Value(now),
              ),
            );
      }
    });
  }

  Future<void> moveTaskToGroup({
    required String taskId,
    required String listId,
    String? groupId,
  }) async {
    await _requireList(listId);
    if (groupId != null) {
      final group = await _requireGroup(groupId);
      if (group.listId != listId) {
        throw StateError('Group does not belong to the target list.');
      }
    }
    await (_db.update(
      _db.taskItems,
    )..where((task) => task.id.equals(taskId))).write(
      TaskItemsCompanion(
        listId: Value(listId),
        groupId: Value(groupId),
        updatedAt: Value(_now()),
      ),
    );
  }

  List<ListTaskSection> _buildSections({
    required List<ListGroup> groups,
    required List<TaskItem> tasks,
    required ListTaskGroupingMode groupingMode,
    required ListTaskSortMode sortMode,
  }) {
    final sortedTasks = [...tasks]..sort(_taskComparator(sortMode));
    return switch (groupingMode) {
      ListTaskGroupingMode.manualGroups => _manualSections(
        groups: groups,
        tasks: sortedTasks,
      ),
      ListTaskGroupingMode.none => [
        ListTaskSection(id: 'all', title: 'All Tasks', tasks: sortedTasks),
      ],
      ListTaskGroupingMode.dueDate => _dueDateSections(sortedTasks),
      ListTaskGroupingMode.priority => _fixedBucketSections(sortedTasks, [
        _TaskBucket('priority-high', 'High', (task) {
          return TaskPriority.fromValue(task.priority) == TaskPriority.high;
        }),
        _TaskBucket('priority-medium', 'Medium', (task) {
          return TaskPriority.fromValue(task.priority) == TaskPriority.medium;
        }),
        _TaskBucket('priority-low', 'Low', (task) {
          return TaskPriority.fromValue(task.priority) == TaskPriority.low;
        }),
        _TaskBucket('priority-none', 'No Priority', (task) {
          return TaskPriority.fromValue(task.priority) == TaskPriority.none;
        }),
      ]),
      ListTaskGroupingMode.status => _bucketSections(sortedTasks, (task) {
        final status = TaskStatus.fromValue(task.status);
        return _TaskBucket('status-${status.value}', status.name, (_) => true);
      }),
      ListTaskGroupingMode.persistent => _fixedBucketSections(sortedTasks, [
        _TaskBucket(
          'persistent',
          'Persistent',
          (task) => task.isPersistent || task.showInTodayUntilComplete,
        ),
        _TaskBucket(
          'normal',
          'Normal',
          (task) => !task.isPersistent && !task.showInTodayUntilComplete,
        ),
      ]),
    };
  }

  List<ListTaskSection> _manualSections({
    required List<ListGroup> groups,
    required List<TaskItem> tasks,
  }) {
    final knownGroupIds = groups.map((group) => group.id).toSet();
    final ungroupedTasks = tasks.where((task) {
      return task.groupId == null || !knownGroupIds.contains(task.groupId);
    }).toList();

    return [
      ListTaskSection(
        id: 'ungrouped',
        title: 'Ungrouped',
        sortOrder: -1,
        isUngrouped: true,
        tasks: ungroupedTasks,
      ),
      for (final group in groups)
        ListTaskSection(
          id: group.id,
          groupId: group.id,
          title: group.name,
          sortOrder: group.sortOrder,
          isCollapsed: group.isCollapsed,
          tasks: tasks.where((task) => task.groupId == group.id).toList(),
        ),
    ];
  }

  List<ListTaskSection> _bucketSections(
    List<TaskItem> tasks,
    _TaskBucket Function(TaskItem task) bucketFor,
  ) {
    final buckets = <String, _TaskBucket>{};
    final tasksByBucket = <String, List<TaskItem>>{};
    for (final task in tasks) {
      final bucket = bucketFor(task);
      buckets[bucket.id] = bucket;
      tasksByBucket.putIfAbsent(bucket.id, () => []).add(task);
    }

    return [
      for (final bucket in buckets.values)
        ListTaskSection(
          id: bucket.id,
          title: bucket.title,
          tasks: tasksByBucket[bucket.id] ?? const [],
        ),
    ];
  }

  List<ListTaskSection> _fixedBucketSections(
    List<TaskItem> tasks,
    List<_TaskBucket> buckets,
  ) {
    return [
      for (final bucket in buckets)
        ListTaskSection(
          id: bucket.id,
          title: bucket.title,
          tasks: tasks.where(bucket.matches).toList(),
        ),
    ];
  }

  List<ListTaskSection> _dueDateSections(List<TaskItem> tasks) {
    final today = dateOnly(_now());
    final buckets = [
      _TaskBucket('overdue', 'Overdue', (task) {
        final dueDate = task.dueDate;
        return dueDate != null && dateOnly(dueDate).isBefore(today);
      }),
      _TaskBucket('today', 'Today', (task) {
        final dueDate = task.dueDate;
        return dueDate != null && dateOnly(dueDate) == today;
      }),
      _TaskBucket('later', 'Later', (task) {
        final dueDate = task.dueDate;
        return dueDate != null && dateOnly(dueDate).isAfter(today);
      }),
      _TaskBucket('no-date', 'No Date', (task) => task.dueDate == null),
    ];

    return [
      for (final bucket in buckets)
        if (tasks.any(bucket.matches))
          ListTaskSection(
            id: bucket.id,
            title: bucket.title,
            tasks: tasks.where(bucket.matches).toList(),
          ),
    ];
  }

  Comparator<TaskItem> _taskComparator(ListTaskSortMode sortMode) {
    return (left, right) {
      final primary = switch (sortMode) {
        ListTaskSortMode.manual => 0,
        ListTaskSortMode.dueDate => _compareNullableDate(
          left.dueDate,
          right.dueDate,
        ),
        ListTaskSortMode.priority => _priorityRank(
          right.priority,
        ).compareTo(_priorityRank(left.priority)),
        ListTaskSortMode.createdDate => right.createdAt.compareTo(
          left.createdAt,
        ),
        ListTaskSortMode.title => left.title.toLowerCase().compareTo(
          right.title.toLowerCase(),
        ),
      };
      if (primary != 0) {
        return primary;
      }
      return _compareManual(left, right);
    };
  }

  int _compareManual(TaskItem left, TaskItem right) {
    final sortCompare = left.sortOrder.compareTo(right.sortOrder);
    if (sortCompare != 0) {
      return sortCompare;
    }
    return left.createdAt.compareTo(right.createdAt);
  }

  int _compareNullableDate(DateTime? left, DateTime? right) {
    if (left == null && right == null) {
      return 0;
    }
    if (left == null) {
      return 1;
    }
    if (right == null) {
      return -1;
    }
    return left.compareTo(right);
  }

  int _priorityRank(String value) {
    return switch (TaskPriority.fromValue(value)) {
      TaskPriority.high => 3,
      TaskPriority.medium => 2,
      TaskPriority.low => 1,
      TaskPriority.none => 0,
    };
  }

  Future<int> _nextListSortOrder() async {
    final maxSortOrder = _db.taskLists.sortOrder.max();
    final query = _db.selectOnly(_db.taskLists)
      ..addColumns([maxSortOrder])
      ..where(_db.taskLists.isArchived.equals(false));
    final row = await query.getSingle();
    return (row.read(maxSortOrder) ?? -1) + 1;
  }

  Future<int> _nextGroupSortOrder(String listId) async {
    final maxSortOrder = _db.listGroups.sortOrder.max();
    final query = _db.selectOnly(_db.listGroups)
      ..addColumns([maxSortOrder])
      ..where(_db.listGroups.listId.equals(listId));
    final row = await query.getSingle();
    return (row.read(maxSortOrder) ?? -1) + 1;
  }

  Future<TaskList> _requireList(String id) async {
    final list =
        await (_db.select(_db.taskLists)..where(
              (item) => item.id.equals(id) & item.isArchived.equals(false),
            ))
            .getSingleOrNull();
    if (list == null) {
      throw StateError('List does not exist.');
    }
    return list;
  }

  Future<TaskList> _requireEditableList(String id) async {
    final list = await _requireList(id);
    if (list.isSystemList) {
      throw StateError('System lists cannot be renamed or deleted.');
    }
    return list;
  }

  Future<ListGroup> _requireGroup(String id) async {
    final group = await (_db.select(
      _db.listGroups,
    )..where((item) => item.id.equals(id))).getSingleOrNull();
    if (group == null) {
      throw StateError('Group does not exist.');
    }
    return group;
  }

  String _requiredName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(value, 'name', 'Name is required');
    }
    return trimmed;
  }

  String _normalizeColor(String value) {
    final normalized = value.trim().toUpperCase();
    if (RegExp(r'^#[0-9A-F]{6}$').hasMatch(normalized)) {
      return normalized;
    }
    throw ArgumentError.value(value, 'color', 'Use a #RRGGBB color value');
  }

  String? _nullableText(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}

class _TaskBucket {
  const _TaskBucket(this.id, this.title, this.matches);

  final String id;
  final String title;
  final bool Function(TaskItem task) matches;
}

Stream<R> _combineLatest2<A, B, R>(
  Stream<A> first,
  Stream<B> second,
  R Function(A first, B second) combine,
) {
  late StreamController<R> controller;
  StreamSubscription<A>? firstSubscription;
  StreamSubscription<B>? secondSubscription;
  A? latestFirst;
  B? latestSecond;
  var hasFirst = false;
  var hasSecond = false;

  void emitIfReady() {
    if (hasFirst && hasSecond) {
      controller.add(combine(latestFirst as A, latestSecond as B));
    }
  }

  controller = StreamController<R>(
    onListen: () {
      firstSubscription = first.listen((value) {
        latestFirst = value;
        hasFirst = true;
        emitIfReady();
      }, onError: controller.addError);
      secondSubscription = second.listen((value) {
        latestSecond = value;
        hasSecond = true;
        emitIfReady();
      }, onError: controller.addError);
    },
    onCancel: () async {
      await firstSubscription?.cancel();
      await secondSubscription?.cancel();
    },
  );

  return controller.stream;
}
