// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TaskItemsTable extends TaskItems
    with TableInfo<$TaskItemsTable, TaskItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 240,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('open'),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<String> listId = GeneratedColumn<String>(
    'list_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dueTimeMeta = const VerificationMeta(
    'dueTime',
  );
  @override
  late final GeneratedColumn<String> dueTime = GeneratedColumn<String>(
    'due_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<String> startTime = GeneratedColumn<String>(
    'start_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeZoneMeta = const VerificationMeta(
    'timeZone',
  );
  @override
  late final GeneratedColumn<String> timeZone = GeneratedColumn<String>(
    'time_zone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isAllDayMeta = const VerificationMeta(
    'isAllDay',
  );
  @override
  late final GeneratedColumn<bool> isAllDay = GeneratedColumn<bool>(
    'is_all_day',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_all_day" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isPersistentMeta = const VerificationMeta(
    'isPersistent',
  );
  @override
  late final GeneratedColumn<bool> isPersistent = GeneratedColumn<bool>(
    'is_persistent',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_persistent" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _showInTodayUntilCompleteMeta =
      const VerificationMeta('showInTodayUntilComplete');
  @override
  late final GeneratedColumn<bool> showInTodayUntilComplete =
      GeneratedColumn<bool>(
        'show_in_today_until_complete',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("show_in_today_until_complete" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  static const VerificationMeta _persistentStartedAtMeta =
      const VerificationMeta('persistentStartedAt');
  @override
  late final GeneratedColumn<DateTime> persistentStartedAt =
      GeneratedColumn<DateTime>(
        'persistent_started_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _persistentCompletedAtMeta =
      const VerificationMeta('persistentCompletedAt');
  @override
  late final GeneratedColumn<DateTime> persistentCompletedAt =
      GeneratedColumn<DateTime>(
        'persistent_completed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _todayCarryForwardCountMeta =
      const VerificationMeta('todayCarryForwardCount');
  @override
  late final GeneratedColumn<int> todayCarryForwardCount = GeneratedColumn<int>(
    'today_carry_forward_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastCarriedForwardAtMeta =
      const VerificationMeta('lastCarriedForwardAt');
  @override
  late final GeneratedColumn<DateTime> lastCarriedForwardAt =
      GeneratedColumn<DateTime>(
        'last_carried_forward_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _recurrenceRuleIdMeta = const VerificationMeta(
    'recurrenceRuleId',
  );
  @override
  late final GeneratedColumn<String> recurrenceRuleId = GeneratedColumn<String>(
    'recurrence_rule_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recurrenceParentTaskIdMeta =
      const VerificationMeta('recurrenceParentTaskId');
  @override
  late final GeneratedColumn<String> recurrenceParentTaskId =
      GeneratedColumn<String>(
        'recurrence_parent_task_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _recurrenceOccurrenceDateMeta =
      const VerificationMeta('recurrenceOccurrenceDate');
  @override
  late final GeneratedColumn<DateTime> recurrenceOccurrenceDate =
      GeneratedColumn<DateTime>(
        'recurrence_occurrence_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _originalInputMeta = const VerificationMeta(
    'originalInput',
  );
  @override
  late final GeneratedColumn<String> originalInput = GeneratedColumn<String>(
    'original_input',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    status,
    priority,
    listId,
    groupId,
    createdAt,
    updatedAt,
    completedAt,
    deletedAt,
    dueDate,
    dueTime,
    startDate,
    startTime,
    timeZone,
    isAllDay,
    isPersistent,
    showInTodayUntilComplete,
    persistentStartedAt,
    persistentCompletedAt,
    todayCarryForwardCount,
    lastCarriedForwardAt,
    recurrenceRuleId,
    recurrenceParentTaskId,
    recurrenceOccurrenceDate,
    originalInput,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('list_id')) {
      context.handle(
        _listIdMeta,
        listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta),
      );
    } else if (isInserting) {
      context.missing(_listIdMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('due_time')) {
      context.handle(
        _dueTimeMeta,
        dueTime.isAcceptableOrUnknown(data['due_time']!, _dueTimeMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    }
    if (data.containsKey('time_zone')) {
      context.handle(
        _timeZoneMeta,
        timeZone.isAcceptableOrUnknown(data['time_zone']!, _timeZoneMeta),
      );
    } else if (isInserting) {
      context.missing(_timeZoneMeta);
    }
    if (data.containsKey('is_all_day')) {
      context.handle(
        _isAllDayMeta,
        isAllDay.isAcceptableOrUnknown(data['is_all_day']!, _isAllDayMeta),
      );
    }
    if (data.containsKey('is_persistent')) {
      context.handle(
        _isPersistentMeta,
        isPersistent.isAcceptableOrUnknown(
          data['is_persistent']!,
          _isPersistentMeta,
        ),
      );
    }
    if (data.containsKey('show_in_today_until_complete')) {
      context.handle(
        _showInTodayUntilCompleteMeta,
        showInTodayUntilComplete.isAcceptableOrUnknown(
          data['show_in_today_until_complete']!,
          _showInTodayUntilCompleteMeta,
        ),
      );
    }
    if (data.containsKey('persistent_started_at')) {
      context.handle(
        _persistentStartedAtMeta,
        persistentStartedAt.isAcceptableOrUnknown(
          data['persistent_started_at']!,
          _persistentStartedAtMeta,
        ),
      );
    }
    if (data.containsKey('persistent_completed_at')) {
      context.handle(
        _persistentCompletedAtMeta,
        persistentCompletedAt.isAcceptableOrUnknown(
          data['persistent_completed_at']!,
          _persistentCompletedAtMeta,
        ),
      );
    }
    if (data.containsKey('today_carry_forward_count')) {
      context.handle(
        _todayCarryForwardCountMeta,
        todayCarryForwardCount.isAcceptableOrUnknown(
          data['today_carry_forward_count']!,
          _todayCarryForwardCountMeta,
        ),
      );
    }
    if (data.containsKey('last_carried_forward_at')) {
      context.handle(
        _lastCarriedForwardAtMeta,
        lastCarriedForwardAt.isAcceptableOrUnknown(
          data['last_carried_forward_at']!,
          _lastCarriedForwardAtMeta,
        ),
      );
    }
    if (data.containsKey('recurrence_rule_id')) {
      context.handle(
        _recurrenceRuleIdMeta,
        recurrenceRuleId.isAcceptableOrUnknown(
          data['recurrence_rule_id']!,
          _recurrenceRuleIdMeta,
        ),
      );
    }
    if (data.containsKey('recurrence_parent_task_id')) {
      context.handle(
        _recurrenceParentTaskIdMeta,
        recurrenceParentTaskId.isAcceptableOrUnknown(
          data['recurrence_parent_task_id']!,
          _recurrenceParentTaskIdMeta,
        ),
      );
    }
    if (data.containsKey('recurrence_occurrence_date')) {
      context.handle(
        _recurrenceOccurrenceDateMeta,
        recurrenceOccurrenceDate.isAcceptableOrUnknown(
          data['recurrence_occurrence_date']!,
          _recurrenceOccurrenceDateMeta,
        ),
      );
    }
    if (data.containsKey('original_input')) {
      context.handle(
        _originalInputMeta,
        originalInput.isAcceptableOrUnknown(
          data['original_input']!,
          _originalInputMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}list_id'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      ),
      dueTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_time'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      ),
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_time'],
      ),
      timeZone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_zone'],
      )!,
      isAllDay: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_all_day'],
      )!,
      isPersistent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_persistent'],
      )!,
      showInTodayUntilComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_in_today_until_complete'],
      )!,
      persistentStartedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}persistent_started_at'],
      ),
      persistentCompletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}persistent_completed_at'],
      ),
      todayCarryForwardCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}today_carry_forward_count'],
      )!,
      lastCarriedForwardAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_carried_forward_at'],
      ),
      recurrenceRuleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurrence_rule_id'],
      ),
      recurrenceParentTaskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurrence_parent_task_id'],
      ),
      recurrenceOccurrenceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recurrence_occurrence_date'],
      ),
      originalInput: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_input'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $TaskItemsTable createAlias(String alias) {
    return $TaskItemsTable(attachedDatabase, alias);
  }
}

class TaskItem extends DataClass implements Insertable<TaskItem> {
  final String id;
  final String title;
  final String? description;
  final String status;
  final String priority;
  final String listId;
  final String? groupId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  final DateTime? deletedAt;
  final DateTime? dueDate;
  final String? dueTime;
  final DateTime? startDate;
  final String? startTime;
  final String timeZone;
  final bool isAllDay;
  final bool isPersistent;
  final bool showInTodayUntilComplete;
  final DateTime? persistentStartedAt;
  final DateTime? persistentCompletedAt;
  final int todayCarryForwardCount;
  final DateTime? lastCarriedForwardAt;
  final String? recurrenceRuleId;
  final String? recurrenceParentTaskId;
  final DateTime? recurrenceOccurrenceDate;
  final String? originalInput;
  final int sortOrder;
  const TaskItem({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    required this.listId,
    this.groupId,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    this.deletedAt,
    this.dueDate,
    this.dueTime,
    this.startDate,
    this.startTime,
    required this.timeZone,
    required this.isAllDay,
    required this.isPersistent,
    required this.showInTodayUntilComplete,
    this.persistentStartedAt,
    this.persistentCompletedAt,
    required this.todayCarryForwardCount,
    this.lastCarriedForwardAt,
    this.recurrenceRuleId,
    this.recurrenceParentTaskId,
    this.recurrenceOccurrenceDate,
    this.originalInput,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['status'] = Variable<String>(status);
    map['priority'] = Variable<String>(priority);
    map['list_id'] = Variable<String>(listId);
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<String>(groupId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<DateTime>(dueDate);
    }
    if (!nullToAbsent || dueTime != null) {
      map['due_time'] = Variable<String>(dueTime);
    }
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || startTime != null) {
      map['start_time'] = Variable<String>(startTime);
    }
    map['time_zone'] = Variable<String>(timeZone);
    map['is_all_day'] = Variable<bool>(isAllDay);
    map['is_persistent'] = Variable<bool>(isPersistent);
    map['show_in_today_until_complete'] = Variable<bool>(
      showInTodayUntilComplete,
    );
    if (!nullToAbsent || persistentStartedAt != null) {
      map['persistent_started_at'] = Variable<DateTime>(persistentStartedAt);
    }
    if (!nullToAbsent || persistentCompletedAt != null) {
      map['persistent_completed_at'] = Variable<DateTime>(
        persistentCompletedAt,
      );
    }
    map['today_carry_forward_count'] = Variable<int>(todayCarryForwardCount);
    if (!nullToAbsent || lastCarriedForwardAt != null) {
      map['last_carried_forward_at'] = Variable<DateTime>(lastCarriedForwardAt);
    }
    if (!nullToAbsent || recurrenceRuleId != null) {
      map['recurrence_rule_id'] = Variable<String>(recurrenceRuleId);
    }
    if (!nullToAbsent || recurrenceParentTaskId != null) {
      map['recurrence_parent_task_id'] = Variable<String>(
        recurrenceParentTaskId,
      );
    }
    if (!nullToAbsent || recurrenceOccurrenceDate != null) {
      map['recurrence_occurrence_date'] = Variable<DateTime>(
        recurrenceOccurrenceDate,
      );
    }
    if (!nullToAbsent || originalInput != null) {
      map['original_input'] = Variable<String>(originalInput);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  TaskItemsCompanion toCompanion(bool nullToAbsent) {
    return TaskItemsCompanion(
      id: Value(id),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      status: Value(status),
      priority: Value(priority),
      listId: Value(listId),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      dueTime: dueTime == null && nullToAbsent
          ? const Value.absent()
          : Value(dueTime),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      startTime: startTime == null && nullToAbsent
          ? const Value.absent()
          : Value(startTime),
      timeZone: Value(timeZone),
      isAllDay: Value(isAllDay),
      isPersistent: Value(isPersistent),
      showInTodayUntilComplete: Value(showInTodayUntilComplete),
      persistentStartedAt: persistentStartedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(persistentStartedAt),
      persistentCompletedAt: persistentCompletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(persistentCompletedAt),
      todayCarryForwardCount: Value(todayCarryForwardCount),
      lastCarriedForwardAt: lastCarriedForwardAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCarriedForwardAt),
      recurrenceRuleId: recurrenceRuleId == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceRuleId),
      recurrenceParentTaskId: recurrenceParentTaskId == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceParentTaskId),
      recurrenceOccurrenceDate: recurrenceOccurrenceDate == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceOccurrenceDate),
      originalInput: originalInput == null && nullToAbsent
          ? const Value.absent()
          : Value(originalInput),
      sortOrder: Value(sortOrder),
    );
  }

  factory TaskItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskItem(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      status: serializer.fromJson<String>(json['status']),
      priority: serializer.fromJson<String>(json['priority']),
      listId: serializer.fromJson<String>(json['listId']),
      groupId: serializer.fromJson<String?>(json['groupId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      dueDate: serializer.fromJson<DateTime?>(json['dueDate']),
      dueTime: serializer.fromJson<String?>(json['dueTime']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      startTime: serializer.fromJson<String?>(json['startTime']),
      timeZone: serializer.fromJson<String>(json['timeZone']),
      isAllDay: serializer.fromJson<bool>(json['isAllDay']),
      isPersistent: serializer.fromJson<bool>(json['isPersistent']),
      showInTodayUntilComplete: serializer.fromJson<bool>(
        json['showInTodayUntilComplete'],
      ),
      persistentStartedAt: serializer.fromJson<DateTime?>(
        json['persistentStartedAt'],
      ),
      persistentCompletedAt: serializer.fromJson<DateTime?>(
        json['persistentCompletedAt'],
      ),
      todayCarryForwardCount: serializer.fromJson<int>(
        json['todayCarryForwardCount'],
      ),
      lastCarriedForwardAt: serializer.fromJson<DateTime?>(
        json['lastCarriedForwardAt'],
      ),
      recurrenceRuleId: serializer.fromJson<String?>(json['recurrenceRuleId']),
      recurrenceParentTaskId: serializer.fromJson<String?>(
        json['recurrenceParentTaskId'],
      ),
      recurrenceOccurrenceDate: serializer.fromJson<DateTime?>(
        json['recurrenceOccurrenceDate'],
      ),
      originalInput: serializer.fromJson<String?>(json['originalInput']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'status': serializer.toJson<String>(status),
      'priority': serializer.toJson<String>(priority),
      'listId': serializer.toJson<String>(listId),
      'groupId': serializer.toJson<String?>(groupId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'dueDate': serializer.toJson<DateTime?>(dueDate),
      'dueTime': serializer.toJson<String?>(dueTime),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'startTime': serializer.toJson<String?>(startTime),
      'timeZone': serializer.toJson<String>(timeZone),
      'isAllDay': serializer.toJson<bool>(isAllDay),
      'isPersistent': serializer.toJson<bool>(isPersistent),
      'showInTodayUntilComplete': serializer.toJson<bool>(
        showInTodayUntilComplete,
      ),
      'persistentStartedAt': serializer.toJson<DateTime?>(persistentStartedAt),
      'persistentCompletedAt': serializer.toJson<DateTime?>(
        persistentCompletedAt,
      ),
      'todayCarryForwardCount': serializer.toJson<int>(todayCarryForwardCount),
      'lastCarriedForwardAt': serializer.toJson<DateTime?>(
        lastCarriedForwardAt,
      ),
      'recurrenceRuleId': serializer.toJson<String?>(recurrenceRuleId),
      'recurrenceParentTaskId': serializer.toJson<String?>(
        recurrenceParentTaskId,
      ),
      'recurrenceOccurrenceDate': serializer.toJson<DateTime?>(
        recurrenceOccurrenceDate,
      ),
      'originalInput': serializer.toJson<String?>(originalInput),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  TaskItem copyWith({
    String? id,
    String? title,
    Value<String?> description = const Value.absent(),
    String? status,
    String? priority,
    String? listId,
    Value<String?> groupId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<DateTime?> deletedAt = const Value.absent(),
    Value<DateTime?> dueDate = const Value.absent(),
    Value<String?> dueTime = const Value.absent(),
    Value<DateTime?> startDate = const Value.absent(),
    Value<String?> startTime = const Value.absent(),
    String? timeZone,
    bool? isAllDay,
    bool? isPersistent,
    bool? showInTodayUntilComplete,
    Value<DateTime?> persistentStartedAt = const Value.absent(),
    Value<DateTime?> persistentCompletedAt = const Value.absent(),
    int? todayCarryForwardCount,
    Value<DateTime?> lastCarriedForwardAt = const Value.absent(),
    Value<String?> recurrenceRuleId = const Value.absent(),
    Value<String?> recurrenceParentTaskId = const Value.absent(),
    Value<DateTime?> recurrenceOccurrenceDate = const Value.absent(),
    Value<String?> originalInput = const Value.absent(),
    int? sortOrder,
  }) => TaskItem(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    status: status ?? this.status,
    priority: priority ?? this.priority,
    listId: listId ?? this.listId,
    groupId: groupId.present ? groupId.value : this.groupId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    dueTime: dueTime.present ? dueTime.value : this.dueTime,
    startDate: startDate.present ? startDate.value : this.startDate,
    startTime: startTime.present ? startTime.value : this.startTime,
    timeZone: timeZone ?? this.timeZone,
    isAllDay: isAllDay ?? this.isAllDay,
    isPersistent: isPersistent ?? this.isPersistent,
    showInTodayUntilComplete:
        showInTodayUntilComplete ?? this.showInTodayUntilComplete,
    persistentStartedAt: persistentStartedAt.present
        ? persistentStartedAt.value
        : this.persistentStartedAt,
    persistentCompletedAt: persistentCompletedAt.present
        ? persistentCompletedAt.value
        : this.persistentCompletedAt,
    todayCarryForwardCount:
        todayCarryForwardCount ?? this.todayCarryForwardCount,
    lastCarriedForwardAt: lastCarriedForwardAt.present
        ? lastCarriedForwardAt.value
        : this.lastCarriedForwardAt,
    recurrenceRuleId: recurrenceRuleId.present
        ? recurrenceRuleId.value
        : this.recurrenceRuleId,
    recurrenceParentTaskId: recurrenceParentTaskId.present
        ? recurrenceParentTaskId.value
        : this.recurrenceParentTaskId,
    recurrenceOccurrenceDate: recurrenceOccurrenceDate.present
        ? recurrenceOccurrenceDate.value
        : this.recurrenceOccurrenceDate,
    originalInput: originalInput.present
        ? originalInput.value
        : this.originalInput,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  TaskItem copyWithCompanion(TaskItemsCompanion data) {
    return TaskItem(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      status: data.status.present ? data.status.value : this.status,
      priority: data.priority.present ? data.priority.value : this.priority,
      listId: data.listId.present ? data.listId.value : this.listId,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      dueTime: data.dueTime.present ? data.dueTime.value : this.dueTime,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      timeZone: data.timeZone.present ? data.timeZone.value : this.timeZone,
      isAllDay: data.isAllDay.present ? data.isAllDay.value : this.isAllDay,
      isPersistent: data.isPersistent.present
          ? data.isPersistent.value
          : this.isPersistent,
      showInTodayUntilComplete: data.showInTodayUntilComplete.present
          ? data.showInTodayUntilComplete.value
          : this.showInTodayUntilComplete,
      persistentStartedAt: data.persistentStartedAt.present
          ? data.persistentStartedAt.value
          : this.persistentStartedAt,
      persistentCompletedAt: data.persistentCompletedAt.present
          ? data.persistentCompletedAt.value
          : this.persistentCompletedAt,
      todayCarryForwardCount: data.todayCarryForwardCount.present
          ? data.todayCarryForwardCount.value
          : this.todayCarryForwardCount,
      lastCarriedForwardAt: data.lastCarriedForwardAt.present
          ? data.lastCarriedForwardAt.value
          : this.lastCarriedForwardAt,
      recurrenceRuleId: data.recurrenceRuleId.present
          ? data.recurrenceRuleId.value
          : this.recurrenceRuleId,
      recurrenceParentTaskId: data.recurrenceParentTaskId.present
          ? data.recurrenceParentTaskId.value
          : this.recurrenceParentTaskId,
      recurrenceOccurrenceDate: data.recurrenceOccurrenceDate.present
          ? data.recurrenceOccurrenceDate.value
          : this.recurrenceOccurrenceDate,
      originalInput: data.originalInput.present
          ? data.originalInput.value
          : this.originalInput,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskItem(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('listId: $listId, ')
          ..write('groupId: $groupId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueTime: $dueTime, ')
          ..write('startDate: $startDate, ')
          ..write('startTime: $startTime, ')
          ..write('timeZone: $timeZone, ')
          ..write('isAllDay: $isAllDay, ')
          ..write('isPersistent: $isPersistent, ')
          ..write('showInTodayUntilComplete: $showInTodayUntilComplete, ')
          ..write('persistentStartedAt: $persistentStartedAt, ')
          ..write('persistentCompletedAt: $persistentCompletedAt, ')
          ..write('todayCarryForwardCount: $todayCarryForwardCount, ')
          ..write('lastCarriedForwardAt: $lastCarriedForwardAt, ')
          ..write('recurrenceRuleId: $recurrenceRuleId, ')
          ..write('recurrenceParentTaskId: $recurrenceParentTaskId, ')
          ..write('recurrenceOccurrenceDate: $recurrenceOccurrenceDate, ')
          ..write('originalInput: $originalInput, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    title,
    description,
    status,
    priority,
    listId,
    groupId,
    createdAt,
    updatedAt,
    completedAt,
    deletedAt,
    dueDate,
    dueTime,
    startDate,
    startTime,
    timeZone,
    isAllDay,
    isPersistent,
    showInTodayUntilComplete,
    persistentStartedAt,
    persistentCompletedAt,
    todayCarryForwardCount,
    lastCarriedForwardAt,
    recurrenceRuleId,
    recurrenceParentTaskId,
    recurrenceOccurrenceDate,
    originalInput,
    sortOrder,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskItem &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.status == this.status &&
          other.priority == this.priority &&
          other.listId == this.listId &&
          other.groupId == this.groupId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.completedAt == this.completedAt &&
          other.deletedAt == this.deletedAt &&
          other.dueDate == this.dueDate &&
          other.dueTime == this.dueTime &&
          other.startDate == this.startDate &&
          other.startTime == this.startTime &&
          other.timeZone == this.timeZone &&
          other.isAllDay == this.isAllDay &&
          other.isPersistent == this.isPersistent &&
          other.showInTodayUntilComplete == this.showInTodayUntilComplete &&
          other.persistentStartedAt == this.persistentStartedAt &&
          other.persistentCompletedAt == this.persistentCompletedAt &&
          other.todayCarryForwardCount == this.todayCarryForwardCount &&
          other.lastCarriedForwardAt == this.lastCarriedForwardAt &&
          other.recurrenceRuleId == this.recurrenceRuleId &&
          other.recurrenceParentTaskId == this.recurrenceParentTaskId &&
          other.recurrenceOccurrenceDate == this.recurrenceOccurrenceDate &&
          other.originalInput == this.originalInput &&
          other.sortOrder == this.sortOrder);
}

class TaskItemsCompanion extends UpdateCompanion<TaskItem> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> status;
  final Value<String> priority;
  final Value<String> listId;
  final Value<String?> groupId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> completedAt;
  final Value<DateTime?> deletedAt;
  final Value<DateTime?> dueDate;
  final Value<String?> dueTime;
  final Value<DateTime?> startDate;
  final Value<String?> startTime;
  final Value<String> timeZone;
  final Value<bool> isAllDay;
  final Value<bool> isPersistent;
  final Value<bool> showInTodayUntilComplete;
  final Value<DateTime?> persistentStartedAt;
  final Value<DateTime?> persistentCompletedAt;
  final Value<int> todayCarryForwardCount;
  final Value<DateTime?> lastCarriedForwardAt;
  final Value<String?> recurrenceRuleId;
  final Value<String?> recurrenceParentTaskId;
  final Value<DateTime?> recurrenceOccurrenceDate;
  final Value<String?> originalInput;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const TaskItemsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    this.listId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueTime = const Value.absent(),
    this.startDate = const Value.absent(),
    this.startTime = const Value.absent(),
    this.timeZone = const Value.absent(),
    this.isAllDay = const Value.absent(),
    this.isPersistent = const Value.absent(),
    this.showInTodayUntilComplete = const Value.absent(),
    this.persistentStartedAt = const Value.absent(),
    this.persistentCompletedAt = const Value.absent(),
    this.todayCarryForwardCount = const Value.absent(),
    this.lastCarriedForwardAt = const Value.absent(),
    this.recurrenceRuleId = const Value.absent(),
    this.recurrenceParentTaskId = const Value.absent(),
    this.recurrenceOccurrenceDate = const Value.absent(),
    this.originalInput = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskItemsCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.priority = const Value.absent(),
    required String listId,
    this.groupId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.completedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.dueTime = const Value.absent(),
    this.startDate = const Value.absent(),
    this.startTime = const Value.absent(),
    required String timeZone,
    this.isAllDay = const Value.absent(),
    this.isPersistent = const Value.absent(),
    this.showInTodayUntilComplete = const Value.absent(),
    this.persistentStartedAt = const Value.absent(),
    this.persistentCompletedAt = const Value.absent(),
    this.todayCarryForwardCount = const Value.absent(),
    this.lastCarriedForwardAt = const Value.absent(),
    this.recurrenceRuleId = const Value.absent(),
    this.recurrenceParentTaskId = const Value.absent(),
    this.recurrenceOccurrenceDate = const Value.absent(),
    this.originalInput = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       listId = Value(listId),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt),
       timeZone = Value(timeZone);
  static Insertable<TaskItem> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? status,
    Expression<String>? priority,
    Expression<String>? listId,
    Expression<String>? groupId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? completedAt,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? dueDate,
    Expression<String>? dueTime,
    Expression<DateTime>? startDate,
    Expression<String>? startTime,
    Expression<String>? timeZone,
    Expression<bool>? isAllDay,
    Expression<bool>? isPersistent,
    Expression<bool>? showInTodayUntilComplete,
    Expression<DateTime>? persistentStartedAt,
    Expression<DateTime>? persistentCompletedAt,
    Expression<int>? todayCarryForwardCount,
    Expression<DateTime>? lastCarriedForwardAt,
    Expression<String>? recurrenceRuleId,
    Expression<String>? recurrenceParentTaskId,
    Expression<DateTime>? recurrenceOccurrenceDate,
    Expression<String>? originalInput,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (priority != null) 'priority': priority,
      if (listId != null) 'list_id': listId,
      if (groupId != null) 'group_id': groupId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (dueDate != null) 'due_date': dueDate,
      if (dueTime != null) 'due_time': dueTime,
      if (startDate != null) 'start_date': startDate,
      if (startTime != null) 'start_time': startTime,
      if (timeZone != null) 'time_zone': timeZone,
      if (isAllDay != null) 'is_all_day': isAllDay,
      if (isPersistent != null) 'is_persistent': isPersistent,
      if (showInTodayUntilComplete != null)
        'show_in_today_until_complete': showInTodayUntilComplete,
      if (persistentStartedAt != null)
        'persistent_started_at': persistentStartedAt,
      if (persistentCompletedAt != null)
        'persistent_completed_at': persistentCompletedAt,
      if (todayCarryForwardCount != null)
        'today_carry_forward_count': todayCarryForwardCount,
      if (lastCarriedForwardAt != null)
        'last_carried_forward_at': lastCarriedForwardAt,
      if (recurrenceRuleId != null) 'recurrence_rule_id': recurrenceRuleId,
      if (recurrenceParentTaskId != null)
        'recurrence_parent_task_id': recurrenceParentTaskId,
      if (recurrenceOccurrenceDate != null)
        'recurrence_occurrence_date': recurrenceOccurrenceDate,
      if (originalInput != null) 'original_input': originalInput,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? description,
    Value<String>? status,
    Value<String>? priority,
    Value<String>? listId,
    Value<String?>? groupId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? completedAt,
    Value<DateTime?>? deletedAt,
    Value<DateTime?>? dueDate,
    Value<String?>? dueTime,
    Value<DateTime?>? startDate,
    Value<String?>? startTime,
    Value<String>? timeZone,
    Value<bool>? isAllDay,
    Value<bool>? isPersistent,
    Value<bool>? showInTodayUntilComplete,
    Value<DateTime?>? persistentStartedAt,
    Value<DateTime?>? persistentCompletedAt,
    Value<int>? todayCarryForwardCount,
    Value<DateTime?>? lastCarriedForwardAt,
    Value<String?>? recurrenceRuleId,
    Value<String?>? recurrenceParentTaskId,
    Value<DateTime?>? recurrenceOccurrenceDate,
    Value<String?>? originalInput,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return TaskItemsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      listId: listId ?? this.listId,
      groupId: groupId ?? this.groupId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      startDate: startDate ?? this.startDate,
      startTime: startTime ?? this.startTime,
      timeZone: timeZone ?? this.timeZone,
      isAllDay: isAllDay ?? this.isAllDay,
      isPersistent: isPersistent ?? this.isPersistent,
      showInTodayUntilComplete:
          showInTodayUntilComplete ?? this.showInTodayUntilComplete,
      persistentStartedAt: persistentStartedAt ?? this.persistentStartedAt,
      persistentCompletedAt:
          persistentCompletedAt ?? this.persistentCompletedAt,
      todayCarryForwardCount:
          todayCarryForwardCount ?? this.todayCarryForwardCount,
      lastCarriedForwardAt: lastCarriedForwardAt ?? this.lastCarriedForwardAt,
      recurrenceRuleId: recurrenceRuleId ?? this.recurrenceRuleId,
      recurrenceParentTaskId:
          recurrenceParentTaskId ?? this.recurrenceParentTaskId,
      recurrenceOccurrenceDate:
          recurrenceOccurrenceDate ?? this.recurrenceOccurrenceDate,
      originalInput: originalInput ?? this.originalInput,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<String>(listId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (dueTime.present) {
      map['due_time'] = Variable<String>(dueTime.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<String>(startTime.value);
    }
    if (timeZone.present) {
      map['time_zone'] = Variable<String>(timeZone.value);
    }
    if (isAllDay.present) {
      map['is_all_day'] = Variable<bool>(isAllDay.value);
    }
    if (isPersistent.present) {
      map['is_persistent'] = Variable<bool>(isPersistent.value);
    }
    if (showInTodayUntilComplete.present) {
      map['show_in_today_until_complete'] = Variable<bool>(
        showInTodayUntilComplete.value,
      );
    }
    if (persistentStartedAt.present) {
      map['persistent_started_at'] = Variable<DateTime>(
        persistentStartedAt.value,
      );
    }
    if (persistentCompletedAt.present) {
      map['persistent_completed_at'] = Variable<DateTime>(
        persistentCompletedAt.value,
      );
    }
    if (todayCarryForwardCount.present) {
      map['today_carry_forward_count'] = Variable<int>(
        todayCarryForwardCount.value,
      );
    }
    if (lastCarriedForwardAt.present) {
      map['last_carried_forward_at'] = Variable<DateTime>(
        lastCarriedForwardAt.value,
      );
    }
    if (recurrenceRuleId.present) {
      map['recurrence_rule_id'] = Variable<String>(recurrenceRuleId.value);
    }
    if (recurrenceParentTaskId.present) {
      map['recurrence_parent_task_id'] = Variable<String>(
        recurrenceParentTaskId.value,
      );
    }
    if (recurrenceOccurrenceDate.present) {
      map['recurrence_occurrence_date'] = Variable<DateTime>(
        recurrenceOccurrenceDate.value,
      );
    }
    if (originalInput.present) {
      map['original_input'] = Variable<String>(originalInput.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskItemsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('priority: $priority, ')
          ..write('listId: $listId, ')
          ..write('groupId: $groupId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dueDate: $dueDate, ')
          ..write('dueTime: $dueTime, ')
          ..write('startDate: $startDate, ')
          ..write('startTime: $startTime, ')
          ..write('timeZone: $timeZone, ')
          ..write('isAllDay: $isAllDay, ')
          ..write('isPersistent: $isPersistent, ')
          ..write('showInTodayUntilComplete: $showInTodayUntilComplete, ')
          ..write('persistentStartedAt: $persistentStartedAt, ')
          ..write('persistentCompletedAt: $persistentCompletedAt, ')
          ..write('todayCarryForwardCount: $todayCarryForwardCount, ')
          ..write('lastCarriedForwardAt: $lastCarriedForwardAt, ')
          ..write('recurrenceRuleId: $recurrenceRuleId, ')
          ..write('recurrenceParentTaskId: $recurrenceParentTaskId, ')
          ..write('recurrenceOccurrenceDate: $recurrenceOccurrenceDate, ')
          ..write('originalInput: $originalInput, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskListsTable extends TaskLists
    with TableInfo<$TaskListsTable, TaskList> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskListsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#4774FA'),
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isSystemListMeta = const VerificationMeta(
    'isSystemList',
  );
  @override
  late final GeneratedColumn<bool> isSystemList = GeneratedColumn<bool>(
    'is_system_list',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system_list" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    color,
    icon,
    sortOrder,
    createdAt,
    updatedAt,
    isArchived,
    isSystemList,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lists';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskList> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('is_system_list')) {
      context.handle(
        _isSystemListMeta,
        isSystemList.isAcceptableOrUnknown(
          data['is_system_list']!,
          _isSystemListMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskList map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskList(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      isSystemList: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system_list'],
      )!,
    );
  }

  @override
  $TaskListsTable createAlias(String alias) {
    return $TaskListsTable(attachedDatabase, alias);
  }
}

class TaskList extends DataClass implements Insertable<TaskList> {
  final String id;
  final String name;
  final String color;
  final String? icon;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isArchived;
  final bool isSystemList;
  const TaskList({
    required this.id,
    required this.name,
    required this.color,
    this.icon,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    required this.isArchived,
    required this.isSystemList,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<String>(color);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_archived'] = Variable<bool>(isArchived);
    map['is_system_list'] = Variable<bool>(isSystemList);
    return map;
  }

  TaskListsCompanion toCompanion(bool nullToAbsent) {
    return TaskListsCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isArchived: Value(isArchived),
      isSystemList: Value(isSystemList),
    );
  }

  factory TaskList.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskList(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String>(json['color']),
      icon: serializer.fromJson<String?>(json['icon']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      isSystemList: serializer.fromJson<bool>(json['isSystemList']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String>(color),
      'icon': serializer.toJson<String?>(icon),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isArchived': serializer.toJson<bool>(isArchived),
      'isSystemList': serializer.toJson<bool>(isSystemList),
    };
  }

  TaskList copyWith({
    String? id,
    String? name,
    String? color,
    Value<String?> icon = const Value.absent(),
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isArchived,
    bool? isSystemList,
  }) => TaskList(
    id: id ?? this.id,
    name: name ?? this.name,
    color: color ?? this.color,
    icon: icon.present ? icon.value : this.icon,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isArchived: isArchived ?? this.isArchived,
    isSystemList: isSystemList ?? this.isSystemList,
  );
  TaskList copyWithCompanion(TaskListsCompanion data) {
    return TaskList(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      icon: data.icon.present ? data.icon.value : this.icon,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      isSystemList: data.isSystemList.present
          ? data.isSystemList.value
          : this.isSystemList,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskList(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isArchived: $isArchived, ')
          ..write('isSystemList: $isSystemList')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    color,
    icon,
    sortOrder,
    createdAt,
    updatedAt,
    isArchived,
    isSystemList,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskList &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.icon == this.icon &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isArchived == this.isArchived &&
          other.isSystemList == this.isSystemList);
}

class TaskListsCompanion extends UpdateCompanion<TaskList> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> color;
  final Value<String?> icon;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isArchived;
  final Value<bool> isSystemList;
  final Value<int> rowid;
  const TaskListsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.isSystemList = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskListsCompanion.insert({
    required String id,
    required String name,
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isArchived = const Value.absent(),
    this.isSystemList = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TaskList> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? color,
    Expression<String>? icon,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isArchived,
    Expression<bool>? isSystemList,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isArchived != null) 'is_archived': isArchived,
      if (isSystemList != null) 'is_system_list': isSystemList,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskListsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? color,
    Value<String?>? icon,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isArchived,
    Value<bool>? isSystemList,
    Value<int>? rowid,
  }) {
    return TaskListsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
      isSystemList: isSystemList ?? this.isSystemList,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (isSystemList.present) {
      map['is_system_list'] = Variable<bool>(isSystemList.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskListsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isArchived: $isArchived, ')
          ..write('isSystemList: $isSystemList, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ListGroupsTable extends ListGroups
    with TableInfo<$ListGroupsTable, ListGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ListGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<String> listId = GeneratedColumn<String>(
    'list_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCollapsedMeta = const VerificationMeta(
    'isCollapsed',
  );
  @override
  late final GeneratedColumn<bool> isCollapsed = GeneratedColumn<bool>(
    'is_collapsed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_collapsed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    listId,
    name,
    sortOrder,
    createdAt,
    updatedAt,
    isCollapsed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'list_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<ListGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('list_id')) {
      context.handle(
        _listIdMeta,
        listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta),
      );
    } else if (isInserting) {
      context.missing(_listIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_collapsed')) {
      context.handle(
        _isCollapsedMeta,
        isCollapsed.isAcceptableOrUnknown(
          data['is_collapsed']!,
          _isCollapsedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ListGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ListGroup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}list_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isCollapsed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_collapsed'],
      )!,
    );
  }

  @override
  $ListGroupsTable createAlias(String alias) {
    return $ListGroupsTable(attachedDatabase, alias);
  }
}

class ListGroup extends DataClass implements Insertable<ListGroup> {
  final String id;
  final String listId;
  final String name;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isCollapsed;
  const ListGroup({
    required this.id,
    required this.listId,
    required this.name,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    required this.isCollapsed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['list_id'] = Variable<String>(listId);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_collapsed'] = Variable<bool>(isCollapsed);
    return map;
  }

  ListGroupsCompanion toCompanion(bool nullToAbsent) {
    return ListGroupsCompanion(
      id: Value(id),
      listId: Value(listId),
      name: Value(name),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isCollapsed: Value(isCollapsed),
    );
  }

  factory ListGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ListGroup(
      id: serializer.fromJson<String>(json['id']),
      listId: serializer.fromJson<String>(json['listId']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isCollapsed: serializer.fromJson<bool>(json['isCollapsed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'listId': serializer.toJson<String>(listId),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isCollapsed': serializer.toJson<bool>(isCollapsed),
    };
  }

  ListGroup copyWith({
    String? id,
    String? listId,
    String? name,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isCollapsed,
  }) => ListGroup(
    id: id ?? this.id,
    listId: listId ?? this.listId,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isCollapsed: isCollapsed ?? this.isCollapsed,
  );
  ListGroup copyWithCompanion(ListGroupsCompanion data) {
    return ListGroup(
      id: data.id.present ? data.id.value : this.id,
      listId: data.listId.present ? data.listId.value : this.listId,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isCollapsed: data.isCollapsed.present
          ? data.isCollapsed.value
          : this.isCollapsed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ListGroup(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isCollapsed: $isCollapsed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    listId,
    name,
    sortOrder,
    createdAt,
    updatedAt,
    isCollapsed,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ListGroup &&
          other.id == this.id &&
          other.listId == this.listId &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isCollapsed == this.isCollapsed);
}

class ListGroupsCompanion extends UpdateCompanion<ListGroup> {
  final Value<String> id;
  final Value<String> listId;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isCollapsed;
  final Value<int> rowid;
  const ListGroupsCompanion({
    this.id = const Value.absent(),
    this.listId = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isCollapsed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ListGroupsCompanion.insert({
    required String id,
    required String listId,
    required String name,
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isCollapsed = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       listId = Value(listId),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ListGroup> custom({
    Expression<String>? id,
    Expression<String>? listId,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isCollapsed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (listId != null) 'list_id': listId,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isCollapsed != null) 'is_collapsed': isCollapsed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ListGroupsCompanion copyWith({
    Value<String>? id,
    Value<String>? listId,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isCollapsed,
    Value<int>? rowid,
  }) {
    return ListGroupsCompanion(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isCollapsed: isCollapsed ?? this.isCollapsed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<String>(listId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isCollapsed.present) {
      map['is_collapsed'] = Variable<bool>(isCollapsed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ListGroupsCompanion(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isCollapsed: $isCollapsed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReminderEntriesTable extends ReminderEntries
    with TableInfo<$ReminderEntriesTable, ReminderEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReminderEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reminderTypeMeta = const VerificationMeta(
    'reminderType',
  );
  @override
  late final GeneratedColumn<String> reminderType = GeneratedColumn<String>(
    'reminder_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remindAtMeta = const VerificationMeta(
    'remindAt',
  );
  @override
  late final GeneratedColumn<DateTime> remindAt = GeneratedColumn<DateTime>(
    'remind_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _offsetMinutesMeta = const VerificationMeta(
    'offsetMinutes',
  );
  @override
  late final GeneratedColumn<int> offsetMinutes = GeneratedColumn<int>(
    'offset_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    reminderType,
    remindAt,
    offsetMinutes,
    isEnabled,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReminderEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('reminder_type')) {
      context.handle(
        _reminderTypeMeta,
        reminderType.isAcceptableOrUnknown(
          data['reminder_type']!,
          _reminderTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reminderTypeMeta);
    }
    if (data.containsKey('remind_at')) {
      context.handle(
        _remindAtMeta,
        remindAt.isAcceptableOrUnknown(data['remind_at']!, _remindAtMeta),
      );
    } else if (isInserting) {
      context.missing(_remindAtMeta);
    }
    if (data.containsKey('offset_minutes')) {
      context.handle(
        _offsetMinutesMeta,
        offsetMinutes.isAcceptableOrUnknown(
          data['offset_minutes']!,
          _offsetMinutesMeta,
        ),
      );
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReminderEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      reminderType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_type'],
      )!,
      remindAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}remind_at'],
      )!,
      offsetMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}offset_minutes'],
      ),
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ReminderEntriesTable createAlias(String alias) {
    return $ReminderEntriesTable(attachedDatabase, alias);
  }
}

class ReminderEntry extends DataClass implements Insertable<ReminderEntry> {
  final String id;
  final String taskId;
  final String reminderType;
  final DateTime remindAt;
  final int? offsetMinutes;
  final bool isEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ReminderEntry({
    required this.id,
    required this.taskId,
    required this.reminderType,
    required this.remindAt,
    this.offsetMinutes,
    required this.isEnabled,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['reminder_type'] = Variable<String>(reminderType);
    map['remind_at'] = Variable<DateTime>(remindAt);
    if (!nullToAbsent || offsetMinutes != null) {
      map['offset_minutes'] = Variable<int>(offsetMinutes);
    }
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ReminderEntriesCompanion toCompanion(bool nullToAbsent) {
    return ReminderEntriesCompanion(
      id: Value(id),
      taskId: Value(taskId),
      reminderType: Value(reminderType),
      remindAt: Value(remindAt),
      offsetMinutes: offsetMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(offsetMinutes),
      isEnabled: Value(isEnabled),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReminderEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderEntry(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      reminderType: serializer.fromJson<String>(json['reminderType']),
      remindAt: serializer.fromJson<DateTime>(json['remindAt']),
      offsetMinutes: serializer.fromJson<int?>(json['offsetMinutes']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'reminderType': serializer.toJson<String>(reminderType),
      'remindAt': serializer.toJson<DateTime>(remindAt),
      'offsetMinutes': serializer.toJson<int?>(offsetMinutes),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ReminderEntry copyWith({
    String? id,
    String? taskId,
    String? reminderType,
    DateTime? remindAt,
    Value<int?> offsetMinutes = const Value.absent(),
    bool? isEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ReminderEntry(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    reminderType: reminderType ?? this.reminderType,
    remindAt: remindAt ?? this.remindAt,
    offsetMinutes: offsetMinutes.present
        ? offsetMinutes.value
        : this.offsetMinutes,
    isEnabled: isEnabled ?? this.isEnabled,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReminderEntry copyWithCompanion(ReminderEntriesCompanion data) {
    return ReminderEntry(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      reminderType: data.reminderType.present
          ? data.reminderType.value
          : this.reminderType,
      remindAt: data.remindAt.present ? data.remindAt.value : this.remindAt,
      offsetMinutes: data.offsetMinutes.present
          ? data.offsetMinutes.value
          : this.offsetMinutes,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderEntry(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('reminderType: $reminderType, ')
          ..write('remindAt: $remindAt, ')
          ..write('offsetMinutes: $offsetMinutes, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taskId,
    reminderType,
    remindAt,
    offsetMinutes,
    isEnabled,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderEntry &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.reminderType == this.reminderType &&
          other.remindAt == this.remindAt &&
          other.offsetMinutes == this.offsetMinutes &&
          other.isEnabled == this.isEnabled &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ReminderEntriesCompanion extends UpdateCompanion<ReminderEntry> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<String> reminderType;
  final Value<DateTime> remindAt;
  final Value<int?> offsetMinutes;
  final Value<bool> isEnabled;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ReminderEntriesCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.reminderType = const Value.absent(),
    this.remindAt = const Value.absent(),
    this.offsetMinutes = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReminderEntriesCompanion.insert({
    required String id,
    required String taskId,
    required String reminderType,
    required DateTime remindAt,
    this.offsetMinutes = const Value.absent(),
    this.isEnabled = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskId = Value(taskId),
       reminderType = Value(reminderType),
       remindAt = Value(remindAt),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ReminderEntry> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? reminderType,
    Expression<DateTime>? remindAt,
    Expression<int>? offsetMinutes,
    Expression<bool>? isEnabled,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (reminderType != null) 'reminder_type': reminderType,
      if (remindAt != null) 'remind_at': remindAt,
      if (offsetMinutes != null) 'offset_minutes': offsetMinutes,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReminderEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? taskId,
    Value<String>? reminderType,
    Value<DateTime>? remindAt,
    Value<int?>? offsetMinutes,
    Value<bool>? isEnabled,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ReminderEntriesCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      reminderType: reminderType ?? this.reminderType,
      remindAt: remindAt ?? this.remindAt,
      offsetMinutes: offsetMinutes ?? this.offsetMinutes,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (reminderType.present) {
      map['reminder_type'] = Variable<String>(reminderType.value);
    }
    if (remindAt.present) {
      map['remind_at'] = Variable<DateTime>(remindAt.value);
    }
    if (offsetMinutes.present) {
      map['offset_minutes'] = Variable<int>(offsetMinutes.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReminderEntriesCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('reminderType: $reminderType, ')
          ..write('remindAt: $remindAt, ')
          ..write('offsetMinutes: $offsetMinutes, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurrenceRuleEntriesTable extends RecurrenceRuleEntries
    with TableInfo<$RecurrenceRuleEntriesTable, RecurrenceRuleEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurrenceRuleEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repeatFrequencyMeta = const VerificationMeta(
    'repeatFrequency',
  );
  @override
  late final GeneratedColumn<String> repeatFrequency = GeneratedColumn<String>(
    'repeat_frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repeatIntervalMeta = const VerificationMeta(
    'repeatInterval',
  );
  @override
  late final GeneratedColumn<int> repeatInterval = GeneratedColumn<int>(
    'repeat_interval',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _repeatWeekdaysMeta = const VerificationMeta(
    'repeatWeekdays',
  );
  @override
  late final GeneratedColumn<String> repeatWeekdays = GeneratedColumn<String>(
    'repeat_weekdays',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repeatMonthDayMeta = const VerificationMeta(
    'repeatMonthDay',
  );
  @override
  late final GeneratedColumn<int> repeatMonthDay = GeneratedColumn<int>(
    'repeat_month_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repeatEndTypeMeta = const VerificationMeta(
    'repeatEndType',
  );
  @override
  late final GeneratedColumn<String> repeatEndType = GeneratedColumn<String>(
    'repeat_end_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('never'),
  );
  static const VerificationMeta _repeatEndDateMeta = const VerificationMeta(
    'repeatEndDate',
  );
  @override
  late final GeneratedColumn<DateTime> repeatEndDate =
      GeneratedColumn<DateTime>(
        'repeat_end_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _repeatOccurrenceCountMeta =
      const VerificationMeta('repeatOccurrenceCount');
  @override
  late final GeneratedColumn<int> repeatOccurrenceCount = GeneratedColumn<int>(
    'repeat_occurrence_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    repeatFrequency,
    repeatInterval,
    repeatWeekdays,
    repeatMonthDay,
    repeatEndType,
    repeatEndDate,
    repeatOccurrenceCount,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurrence_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurrenceRuleEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('repeat_frequency')) {
      context.handle(
        _repeatFrequencyMeta,
        repeatFrequency.isAcceptableOrUnknown(
          data['repeat_frequency']!,
          _repeatFrequencyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_repeatFrequencyMeta);
    }
    if (data.containsKey('repeat_interval')) {
      context.handle(
        _repeatIntervalMeta,
        repeatInterval.isAcceptableOrUnknown(
          data['repeat_interval']!,
          _repeatIntervalMeta,
        ),
      );
    }
    if (data.containsKey('repeat_weekdays')) {
      context.handle(
        _repeatWeekdaysMeta,
        repeatWeekdays.isAcceptableOrUnknown(
          data['repeat_weekdays']!,
          _repeatWeekdaysMeta,
        ),
      );
    }
    if (data.containsKey('repeat_month_day')) {
      context.handle(
        _repeatMonthDayMeta,
        repeatMonthDay.isAcceptableOrUnknown(
          data['repeat_month_day']!,
          _repeatMonthDayMeta,
        ),
      );
    }
    if (data.containsKey('repeat_end_type')) {
      context.handle(
        _repeatEndTypeMeta,
        repeatEndType.isAcceptableOrUnknown(
          data['repeat_end_type']!,
          _repeatEndTypeMeta,
        ),
      );
    }
    if (data.containsKey('repeat_end_date')) {
      context.handle(
        _repeatEndDateMeta,
        repeatEndDate.isAcceptableOrUnknown(
          data['repeat_end_date']!,
          _repeatEndDateMeta,
        ),
      );
    }
    if (data.containsKey('repeat_occurrence_count')) {
      context.handle(
        _repeatOccurrenceCountMeta,
        repeatOccurrenceCount.isAcceptableOrUnknown(
          data['repeat_occurrence_count']!,
          _repeatOccurrenceCountMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurrenceRuleEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurrenceRuleEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      repeatFrequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat_frequency'],
      )!,
      repeatInterval: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repeat_interval'],
      )!,
      repeatWeekdays: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat_weekdays'],
      ),
      repeatMonthDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repeat_month_day'],
      ),
      repeatEndType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}repeat_end_type'],
      )!,
      repeatEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}repeat_end_date'],
      ),
      repeatOccurrenceCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repeat_occurrence_count'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RecurrenceRuleEntriesTable createAlias(String alias) {
    return $RecurrenceRuleEntriesTable(attachedDatabase, alias);
  }
}

class RecurrenceRuleEntry extends DataClass
    implements Insertable<RecurrenceRuleEntry> {
  final String id;
  final String repeatFrequency;
  final int repeatInterval;
  final String? repeatWeekdays;
  final int? repeatMonthDay;
  final String repeatEndType;
  final DateTime? repeatEndDate;
  final int? repeatOccurrenceCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RecurrenceRuleEntry({
    required this.id,
    required this.repeatFrequency,
    required this.repeatInterval,
    this.repeatWeekdays,
    this.repeatMonthDay,
    required this.repeatEndType,
    this.repeatEndDate,
    this.repeatOccurrenceCount,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['repeat_frequency'] = Variable<String>(repeatFrequency);
    map['repeat_interval'] = Variable<int>(repeatInterval);
    if (!nullToAbsent || repeatWeekdays != null) {
      map['repeat_weekdays'] = Variable<String>(repeatWeekdays);
    }
    if (!nullToAbsent || repeatMonthDay != null) {
      map['repeat_month_day'] = Variable<int>(repeatMonthDay);
    }
    map['repeat_end_type'] = Variable<String>(repeatEndType);
    if (!nullToAbsent || repeatEndDate != null) {
      map['repeat_end_date'] = Variable<DateTime>(repeatEndDate);
    }
    if (!nullToAbsent || repeatOccurrenceCount != null) {
      map['repeat_occurrence_count'] = Variable<int>(repeatOccurrenceCount);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RecurrenceRuleEntriesCompanion toCompanion(bool nullToAbsent) {
    return RecurrenceRuleEntriesCompanion(
      id: Value(id),
      repeatFrequency: Value(repeatFrequency),
      repeatInterval: Value(repeatInterval),
      repeatWeekdays: repeatWeekdays == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatWeekdays),
      repeatMonthDay: repeatMonthDay == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatMonthDay),
      repeatEndType: Value(repeatEndType),
      repeatEndDate: repeatEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatEndDate),
      repeatOccurrenceCount: repeatOccurrenceCount == null && nullToAbsent
          ? const Value.absent()
          : Value(repeatOccurrenceCount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RecurrenceRuleEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurrenceRuleEntry(
      id: serializer.fromJson<String>(json['id']),
      repeatFrequency: serializer.fromJson<String>(json['repeatFrequency']),
      repeatInterval: serializer.fromJson<int>(json['repeatInterval']),
      repeatWeekdays: serializer.fromJson<String?>(json['repeatWeekdays']),
      repeatMonthDay: serializer.fromJson<int?>(json['repeatMonthDay']),
      repeatEndType: serializer.fromJson<String>(json['repeatEndType']),
      repeatEndDate: serializer.fromJson<DateTime?>(json['repeatEndDate']),
      repeatOccurrenceCount: serializer.fromJson<int?>(
        json['repeatOccurrenceCount'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'repeatFrequency': serializer.toJson<String>(repeatFrequency),
      'repeatInterval': serializer.toJson<int>(repeatInterval),
      'repeatWeekdays': serializer.toJson<String?>(repeatWeekdays),
      'repeatMonthDay': serializer.toJson<int?>(repeatMonthDay),
      'repeatEndType': serializer.toJson<String>(repeatEndType),
      'repeatEndDate': serializer.toJson<DateTime?>(repeatEndDate),
      'repeatOccurrenceCount': serializer.toJson<int?>(repeatOccurrenceCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RecurrenceRuleEntry copyWith({
    String? id,
    String? repeatFrequency,
    int? repeatInterval,
    Value<String?> repeatWeekdays = const Value.absent(),
    Value<int?> repeatMonthDay = const Value.absent(),
    String? repeatEndType,
    Value<DateTime?> repeatEndDate = const Value.absent(),
    Value<int?> repeatOccurrenceCount = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RecurrenceRuleEntry(
    id: id ?? this.id,
    repeatFrequency: repeatFrequency ?? this.repeatFrequency,
    repeatInterval: repeatInterval ?? this.repeatInterval,
    repeatWeekdays: repeatWeekdays.present
        ? repeatWeekdays.value
        : this.repeatWeekdays,
    repeatMonthDay: repeatMonthDay.present
        ? repeatMonthDay.value
        : this.repeatMonthDay,
    repeatEndType: repeatEndType ?? this.repeatEndType,
    repeatEndDate: repeatEndDate.present
        ? repeatEndDate.value
        : this.repeatEndDate,
    repeatOccurrenceCount: repeatOccurrenceCount.present
        ? repeatOccurrenceCount.value
        : this.repeatOccurrenceCount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RecurrenceRuleEntry copyWithCompanion(RecurrenceRuleEntriesCompanion data) {
    return RecurrenceRuleEntry(
      id: data.id.present ? data.id.value : this.id,
      repeatFrequency: data.repeatFrequency.present
          ? data.repeatFrequency.value
          : this.repeatFrequency,
      repeatInterval: data.repeatInterval.present
          ? data.repeatInterval.value
          : this.repeatInterval,
      repeatWeekdays: data.repeatWeekdays.present
          ? data.repeatWeekdays.value
          : this.repeatWeekdays,
      repeatMonthDay: data.repeatMonthDay.present
          ? data.repeatMonthDay.value
          : this.repeatMonthDay,
      repeatEndType: data.repeatEndType.present
          ? data.repeatEndType.value
          : this.repeatEndType,
      repeatEndDate: data.repeatEndDate.present
          ? data.repeatEndDate.value
          : this.repeatEndDate,
      repeatOccurrenceCount: data.repeatOccurrenceCount.present
          ? data.repeatOccurrenceCount.value
          : this.repeatOccurrenceCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurrenceRuleEntry(')
          ..write('id: $id, ')
          ..write('repeatFrequency: $repeatFrequency, ')
          ..write('repeatInterval: $repeatInterval, ')
          ..write('repeatWeekdays: $repeatWeekdays, ')
          ..write('repeatMonthDay: $repeatMonthDay, ')
          ..write('repeatEndType: $repeatEndType, ')
          ..write('repeatEndDate: $repeatEndDate, ')
          ..write('repeatOccurrenceCount: $repeatOccurrenceCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    repeatFrequency,
    repeatInterval,
    repeatWeekdays,
    repeatMonthDay,
    repeatEndType,
    repeatEndDate,
    repeatOccurrenceCount,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurrenceRuleEntry &&
          other.id == this.id &&
          other.repeatFrequency == this.repeatFrequency &&
          other.repeatInterval == this.repeatInterval &&
          other.repeatWeekdays == this.repeatWeekdays &&
          other.repeatMonthDay == this.repeatMonthDay &&
          other.repeatEndType == this.repeatEndType &&
          other.repeatEndDate == this.repeatEndDate &&
          other.repeatOccurrenceCount == this.repeatOccurrenceCount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RecurrenceRuleEntriesCompanion
    extends UpdateCompanion<RecurrenceRuleEntry> {
  final Value<String> id;
  final Value<String> repeatFrequency;
  final Value<int> repeatInterval;
  final Value<String?> repeatWeekdays;
  final Value<int?> repeatMonthDay;
  final Value<String> repeatEndType;
  final Value<DateTime?> repeatEndDate;
  final Value<int?> repeatOccurrenceCount;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RecurrenceRuleEntriesCompanion({
    this.id = const Value.absent(),
    this.repeatFrequency = const Value.absent(),
    this.repeatInterval = const Value.absent(),
    this.repeatWeekdays = const Value.absent(),
    this.repeatMonthDay = const Value.absent(),
    this.repeatEndType = const Value.absent(),
    this.repeatEndDate = const Value.absent(),
    this.repeatOccurrenceCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurrenceRuleEntriesCompanion.insert({
    required String id,
    required String repeatFrequency,
    this.repeatInterval = const Value.absent(),
    this.repeatWeekdays = const Value.absent(),
    this.repeatMonthDay = const Value.absent(),
    this.repeatEndType = const Value.absent(),
    this.repeatEndDate = const Value.absent(),
    this.repeatOccurrenceCount = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       repeatFrequency = Value(repeatFrequency),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RecurrenceRuleEntry> custom({
    Expression<String>? id,
    Expression<String>? repeatFrequency,
    Expression<int>? repeatInterval,
    Expression<String>? repeatWeekdays,
    Expression<int>? repeatMonthDay,
    Expression<String>? repeatEndType,
    Expression<DateTime>? repeatEndDate,
    Expression<int>? repeatOccurrenceCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (repeatFrequency != null) 'repeat_frequency': repeatFrequency,
      if (repeatInterval != null) 'repeat_interval': repeatInterval,
      if (repeatWeekdays != null) 'repeat_weekdays': repeatWeekdays,
      if (repeatMonthDay != null) 'repeat_month_day': repeatMonthDay,
      if (repeatEndType != null) 'repeat_end_type': repeatEndType,
      if (repeatEndDate != null) 'repeat_end_date': repeatEndDate,
      if (repeatOccurrenceCount != null)
        'repeat_occurrence_count': repeatOccurrenceCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurrenceRuleEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? repeatFrequency,
    Value<int>? repeatInterval,
    Value<String?>? repeatWeekdays,
    Value<int?>? repeatMonthDay,
    Value<String>? repeatEndType,
    Value<DateTime?>? repeatEndDate,
    Value<int?>? repeatOccurrenceCount,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RecurrenceRuleEntriesCompanion(
      id: id ?? this.id,
      repeatFrequency: repeatFrequency ?? this.repeatFrequency,
      repeatInterval: repeatInterval ?? this.repeatInterval,
      repeatWeekdays: repeatWeekdays ?? this.repeatWeekdays,
      repeatMonthDay: repeatMonthDay ?? this.repeatMonthDay,
      repeatEndType: repeatEndType ?? this.repeatEndType,
      repeatEndDate: repeatEndDate ?? this.repeatEndDate,
      repeatOccurrenceCount:
          repeatOccurrenceCount ?? this.repeatOccurrenceCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (repeatFrequency.present) {
      map['repeat_frequency'] = Variable<String>(repeatFrequency.value);
    }
    if (repeatInterval.present) {
      map['repeat_interval'] = Variable<int>(repeatInterval.value);
    }
    if (repeatWeekdays.present) {
      map['repeat_weekdays'] = Variable<String>(repeatWeekdays.value);
    }
    if (repeatMonthDay.present) {
      map['repeat_month_day'] = Variable<int>(repeatMonthDay.value);
    }
    if (repeatEndType.present) {
      map['repeat_end_type'] = Variable<String>(repeatEndType.value);
    }
    if (repeatEndDate.present) {
      map['repeat_end_date'] = Variable<DateTime>(repeatEndDate.value);
    }
    if (repeatOccurrenceCount.present) {
      map['repeat_occurrence_count'] = Variable<int>(
        repeatOccurrenceCount.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurrenceRuleEntriesCompanion(')
          ..write('id: $id, ')
          ..write('repeatFrequency: $repeatFrequency, ')
          ..write('repeatInterval: $repeatInterval, ')
          ..write('repeatWeekdays: $repeatWeekdays, ')
          ..write('repeatMonthDay: $repeatMonthDay, ')
          ..write('repeatEndType: $repeatEndType, ')
          ..write('repeatEndDate: $repeatEndDate, ')
          ..write('repeatOccurrenceCount: $repeatOccurrenceCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsEntriesTable extends SettingsEntries
    with TableInfo<$SettingsEntriesTable, SettingsEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueTypeMeta = const VerificationMeta(
    'valueType',
  );
  @override
  late final GeneratedColumn<String> valueType = GeneratedColumn<String>(
    'value_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, valueType, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('value_type')) {
      context.handle(
        _valueTypeMeta,
        valueType.isAcceptableOrUnknown(data['value_type']!, _valueTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_valueTypeMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingsEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsEntry(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      valueType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_type'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SettingsEntriesTable createAlias(String alias) {
    return $SettingsEntriesTable(attachedDatabase, alias);
  }
}

class SettingsEntry extends DataClass implements Insertable<SettingsEntry> {
  final String key;
  final String value;
  final String valueType;
  final DateTime updatedAt;
  const SettingsEntry({
    required this.key,
    required this.value,
    required this.valueType,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['value_type'] = Variable<String>(valueType);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SettingsEntriesCompanion toCompanion(bool nullToAbsent) {
    return SettingsEntriesCompanion(
      key: Value(key),
      value: Value(value),
      valueType: Value(valueType),
      updatedAt: Value(updatedAt),
    );
  }

  factory SettingsEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsEntry(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      valueType: serializer.fromJson<String>(json['valueType']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'valueType': serializer.toJson<String>(valueType),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SettingsEntry copyWith({
    String? key,
    String? value,
    String? valueType,
    DateTime? updatedAt,
  }) => SettingsEntry(
    key: key ?? this.key,
    value: value ?? this.value,
    valueType: valueType ?? this.valueType,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SettingsEntry copyWithCompanion(SettingsEntriesCompanion data) {
    return SettingsEntry(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      valueType: data.valueType.present ? data.valueType.value : this.valueType,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsEntry(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('valueType: $valueType, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, valueType, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsEntry &&
          other.key == this.key &&
          other.value == this.value &&
          other.valueType == this.valueType &&
          other.updatedAt == this.updatedAt);
}

class SettingsEntriesCompanion extends UpdateCompanion<SettingsEntry> {
  final Value<String> key;
  final Value<String> value;
  final Value<String> valueType;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SettingsEntriesCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.valueType = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsEntriesCompanion.insert({
    required String key,
    required String value,
    required String valueType,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       valueType = Value(valueType),
       updatedAt = Value(updatedAt);
  static Insertable<SettingsEntry> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<String>? valueType,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (valueType != null) 'value_type': valueType,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsEntriesCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<String>? valueType,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SettingsEntriesCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      valueType: valueType ?? this.valueType,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (valueType.present) {
      map['value_type'] = Variable<String>(valueType.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsEntriesCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('valueType: $valueType, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityLogEntriesTable extends ActivityLogEntries
    with TableInfo<$ActivityLogEntriesTable, ActivityLogEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityLogEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metadataJsonMeta = const VerificationMeta(
    'metadataJson',
  );
  @override
  late final GeneratedColumn<String> metadataJson = GeneratedColumn<String>(
    'metadata_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    action,
    metadataJson,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityLogEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('metadata_json')) {
      context.handle(
        _metadataJsonMeta,
        metadataJson.isAcceptableOrUnknown(
          data['metadata_json']!,
          _metadataJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityLogEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityLogEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      metadataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata_json'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ActivityLogEntriesTable createAlias(String alias) {
    return $ActivityLogEntriesTable(attachedDatabase, alias);
  }
}

class ActivityLogEntry extends DataClass
    implements Insertable<ActivityLogEntry> {
  final String id;
  final String entityType;
  final String entityId;
  final String action;
  final String? metadataJson;
  final DateTime createdAt;
  const ActivityLogEntry({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.action,
    this.metadataJson,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['action'] = Variable<String>(action);
    if (!nullToAbsent || metadataJson != null) {
      map['metadata_json'] = Variable<String>(metadataJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ActivityLogEntriesCompanion toCompanion(bool nullToAbsent) {
    return ActivityLogEntriesCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      action: Value(action),
      metadataJson: metadataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(metadataJson),
      createdAt: Value(createdAt),
    );
  }

  factory ActivityLogEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityLogEntry(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      action: serializer.fromJson<String>(json['action']),
      metadataJson: serializer.fromJson<String?>(json['metadataJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'action': serializer.toJson<String>(action),
      'metadataJson': serializer.toJson<String?>(metadataJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ActivityLogEntry copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? action,
    Value<String?> metadataJson = const Value.absent(),
    DateTime? createdAt,
  }) => ActivityLogEntry(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    action: action ?? this.action,
    metadataJson: metadataJson.present ? metadataJson.value : this.metadataJson,
    createdAt: createdAt ?? this.createdAt,
  );
  ActivityLogEntry copyWithCompanion(ActivityLogEntriesCompanion data) {
    return ActivityLogEntry(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      action: data.action.present ? data.action.value : this.action,
      metadataJson: data.metadataJson.present
          ? data.metadataJson.value
          : this.metadataJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityLogEntry(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, entityType, entityId, action, metadataJson, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityLogEntry &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.action == this.action &&
          other.metadataJson == this.metadataJson &&
          other.createdAt == this.createdAt);
}

class ActivityLogEntriesCompanion extends UpdateCompanion<ActivityLogEntry> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> action;
  final Value<String?> metadataJson;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ActivityLogEntriesCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.action = const Value.absent(),
    this.metadataJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityLogEntriesCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    required String action,
    this.metadataJson = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityType = Value(entityType),
       entityId = Value(entityId),
       action = Value(action),
       createdAt = Value(createdAt);
  static Insertable<ActivityLogEntry> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? action,
    Expression<String>? metadataJson,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (action != null) 'action': action,
      if (metadataJson != null) 'metadata_json': metadataJson,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityLogEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? action,
    Value<String?>? metadataJson,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ActivityLogEntriesCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      action: action ?? this.action,
      metadataJson: metadataJson ?? this.metadataJson,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (metadataJson.present) {
      map['metadata_json'] = Variable<String>(metadataJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityLogEntriesCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('action: $action, ')
          ..write('metadataJson: $metadataJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WidgetSnapshotEntriesTable extends WidgetSnapshotEntries
    with TableInfo<$WidgetSnapshotEntriesTable, WidgetSnapshotEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WidgetSnapshotEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueTodayCountMeta = const VerificationMeta(
    'dueTodayCount',
  );
  @override
  late final GeneratedColumn<int> dueTodayCount = GeneratedColumn<int>(
    'due_today_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _generatedAtMeta = const VerificationMeta(
    'generatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
    'generated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeZoneMeta = const VerificationMeta(
    'timeZone',
  );
  @override
  late final GeneratedColumn<String> timeZone = GeneratedColumn<String>(
    'time_zone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextDueTodayTasksJsonMeta =
      const VerificationMeta('nextDueTodayTasksJson');
  @override
  late final GeneratedColumn<String> nextDueTodayTasksJson =
      GeneratedColumn<String>(
        'next_due_today_tasks_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dueTodayCount,
    generatedAt,
    timeZone,
    nextDueTodayTasksJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'widget_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<WidgetSnapshotEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('due_today_count')) {
      context.handle(
        _dueTodayCountMeta,
        dueTodayCount.isAcceptableOrUnknown(
          data['due_today_count']!,
          _dueTodayCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dueTodayCountMeta);
    }
    if (data.containsKey('generated_at')) {
      context.handle(
        _generatedAtMeta,
        generatedAt.isAcceptableOrUnknown(
          data['generated_at']!,
          _generatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_generatedAtMeta);
    }
    if (data.containsKey('time_zone')) {
      context.handle(
        _timeZoneMeta,
        timeZone.isAcceptableOrUnknown(data['time_zone']!, _timeZoneMeta),
      );
    } else if (isInserting) {
      context.missing(_timeZoneMeta);
    }
    if (data.containsKey('next_due_today_tasks_json')) {
      context.handle(
        _nextDueTodayTasksJsonMeta,
        nextDueTodayTasksJson.isAcceptableOrUnknown(
          data['next_due_today_tasks_json']!,
          _nextDueTodayTasksJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextDueTodayTasksJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WidgetSnapshotEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WidgetSnapshotEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      dueTodayCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_today_count'],
      )!,
      generatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}generated_at'],
      )!,
      timeZone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_zone'],
      )!,
      nextDueTodayTasksJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}next_due_today_tasks_json'],
      )!,
    );
  }

  @override
  $WidgetSnapshotEntriesTable createAlias(String alias) {
    return $WidgetSnapshotEntriesTable(attachedDatabase, alias);
  }
}

class WidgetSnapshotEntry extends DataClass
    implements Insertable<WidgetSnapshotEntry> {
  final String id;
  final int dueTodayCount;
  final DateTime generatedAt;
  final String timeZone;
  final String nextDueTodayTasksJson;
  const WidgetSnapshotEntry({
    required this.id,
    required this.dueTodayCount,
    required this.generatedAt,
    required this.timeZone,
    required this.nextDueTodayTasksJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['due_today_count'] = Variable<int>(dueTodayCount);
    map['generated_at'] = Variable<DateTime>(generatedAt);
    map['time_zone'] = Variable<String>(timeZone);
    map['next_due_today_tasks_json'] = Variable<String>(nextDueTodayTasksJson);
    return map;
  }

  WidgetSnapshotEntriesCompanion toCompanion(bool nullToAbsent) {
    return WidgetSnapshotEntriesCompanion(
      id: Value(id),
      dueTodayCount: Value(dueTodayCount),
      generatedAt: Value(generatedAt),
      timeZone: Value(timeZone),
      nextDueTodayTasksJson: Value(nextDueTodayTasksJson),
    );
  }

  factory WidgetSnapshotEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WidgetSnapshotEntry(
      id: serializer.fromJson<String>(json['id']),
      dueTodayCount: serializer.fromJson<int>(json['dueTodayCount']),
      generatedAt: serializer.fromJson<DateTime>(json['generatedAt']),
      timeZone: serializer.fromJson<String>(json['timeZone']),
      nextDueTodayTasksJson: serializer.fromJson<String>(
        json['nextDueTodayTasksJson'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dueTodayCount': serializer.toJson<int>(dueTodayCount),
      'generatedAt': serializer.toJson<DateTime>(generatedAt),
      'timeZone': serializer.toJson<String>(timeZone),
      'nextDueTodayTasksJson': serializer.toJson<String>(nextDueTodayTasksJson),
    };
  }

  WidgetSnapshotEntry copyWith({
    String? id,
    int? dueTodayCount,
    DateTime? generatedAt,
    String? timeZone,
    String? nextDueTodayTasksJson,
  }) => WidgetSnapshotEntry(
    id: id ?? this.id,
    dueTodayCount: dueTodayCount ?? this.dueTodayCount,
    generatedAt: generatedAt ?? this.generatedAt,
    timeZone: timeZone ?? this.timeZone,
    nextDueTodayTasksJson: nextDueTodayTasksJson ?? this.nextDueTodayTasksJson,
  );
  WidgetSnapshotEntry copyWithCompanion(WidgetSnapshotEntriesCompanion data) {
    return WidgetSnapshotEntry(
      id: data.id.present ? data.id.value : this.id,
      dueTodayCount: data.dueTodayCount.present
          ? data.dueTodayCount.value
          : this.dueTodayCount,
      generatedAt: data.generatedAt.present
          ? data.generatedAt.value
          : this.generatedAt,
      timeZone: data.timeZone.present ? data.timeZone.value : this.timeZone,
      nextDueTodayTasksJson: data.nextDueTodayTasksJson.present
          ? data.nextDueTodayTasksJson.value
          : this.nextDueTodayTasksJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WidgetSnapshotEntry(')
          ..write('id: $id, ')
          ..write('dueTodayCount: $dueTodayCount, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('timeZone: $timeZone, ')
          ..write('nextDueTodayTasksJson: $nextDueTodayTasksJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dueTodayCount,
    generatedAt,
    timeZone,
    nextDueTodayTasksJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WidgetSnapshotEntry &&
          other.id == this.id &&
          other.dueTodayCount == this.dueTodayCount &&
          other.generatedAt == this.generatedAt &&
          other.timeZone == this.timeZone &&
          other.nextDueTodayTasksJson == this.nextDueTodayTasksJson);
}

class WidgetSnapshotEntriesCompanion
    extends UpdateCompanion<WidgetSnapshotEntry> {
  final Value<String> id;
  final Value<int> dueTodayCount;
  final Value<DateTime> generatedAt;
  final Value<String> timeZone;
  final Value<String> nextDueTodayTasksJson;
  final Value<int> rowid;
  const WidgetSnapshotEntriesCompanion({
    this.id = const Value.absent(),
    this.dueTodayCount = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.timeZone = const Value.absent(),
    this.nextDueTodayTasksJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WidgetSnapshotEntriesCompanion.insert({
    required String id,
    required int dueTodayCount,
    required DateTime generatedAt,
    required String timeZone,
    required String nextDueTodayTasksJson,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       dueTodayCount = Value(dueTodayCount),
       generatedAt = Value(generatedAt),
       timeZone = Value(timeZone),
       nextDueTodayTasksJson = Value(nextDueTodayTasksJson);
  static Insertable<WidgetSnapshotEntry> custom({
    Expression<String>? id,
    Expression<int>? dueTodayCount,
    Expression<DateTime>? generatedAt,
    Expression<String>? timeZone,
    Expression<String>? nextDueTodayTasksJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dueTodayCount != null) 'due_today_count': dueTodayCount,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (timeZone != null) 'time_zone': timeZone,
      if (nextDueTodayTasksJson != null)
        'next_due_today_tasks_json': nextDueTodayTasksJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WidgetSnapshotEntriesCompanion copyWith({
    Value<String>? id,
    Value<int>? dueTodayCount,
    Value<DateTime>? generatedAt,
    Value<String>? timeZone,
    Value<String>? nextDueTodayTasksJson,
    Value<int>? rowid,
  }) {
    return WidgetSnapshotEntriesCompanion(
      id: id ?? this.id,
      dueTodayCount: dueTodayCount ?? this.dueTodayCount,
      generatedAt: generatedAt ?? this.generatedAt,
      timeZone: timeZone ?? this.timeZone,
      nextDueTodayTasksJson:
          nextDueTodayTasksJson ?? this.nextDueTodayTasksJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dueTodayCount.present) {
      map['due_today_count'] = Variable<int>(dueTodayCount.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    if (timeZone.present) {
      map['time_zone'] = Variable<String>(timeZone.value);
    }
    if (nextDueTodayTasksJson.present) {
      map['next_due_today_tasks_json'] = Variable<String>(
        nextDueTodayTasksJson.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WidgetSnapshotEntriesCompanion(')
          ..write('id: $id, ')
          ..write('dueTodayCount: $dueTodayCount, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('timeZone: $timeZone, ')
          ..write('nextDueTodayTasksJson: $nextDueTodayTasksJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TaskItemsTable taskItems = $TaskItemsTable(this);
  late final $TaskListsTable taskLists = $TaskListsTable(this);
  late final $ListGroupsTable listGroups = $ListGroupsTable(this);
  late final $ReminderEntriesTable reminderEntries = $ReminderEntriesTable(
    this,
  );
  late final $RecurrenceRuleEntriesTable recurrenceRuleEntries =
      $RecurrenceRuleEntriesTable(this);
  late final $SettingsEntriesTable settingsEntries = $SettingsEntriesTable(
    this,
  );
  late final $ActivityLogEntriesTable activityLogEntries =
      $ActivityLogEntriesTable(this);
  late final $WidgetSnapshotEntriesTable widgetSnapshotEntries =
      $WidgetSnapshotEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    taskItems,
    taskLists,
    listGroups,
    reminderEntries,
    recurrenceRuleEntries,
    settingsEntries,
    activityLogEntries,
    widgetSnapshotEntries,
  ];
}

typedef $$TaskItemsTableCreateCompanionBuilder =
    TaskItemsCompanion Function({
      required String id,
      required String title,
      Value<String?> description,
      Value<String> status,
      Value<String> priority,
      required String listId,
      Value<String?> groupId,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> completedAt,
      Value<DateTime?> deletedAt,
      Value<DateTime?> dueDate,
      Value<String?> dueTime,
      Value<DateTime?> startDate,
      Value<String?> startTime,
      required String timeZone,
      Value<bool> isAllDay,
      Value<bool> isPersistent,
      Value<bool> showInTodayUntilComplete,
      Value<DateTime?> persistentStartedAt,
      Value<DateTime?> persistentCompletedAt,
      Value<int> todayCarryForwardCount,
      Value<DateTime?> lastCarriedForwardAt,
      Value<String?> recurrenceRuleId,
      Value<String?> recurrenceParentTaskId,
      Value<DateTime?> recurrenceOccurrenceDate,
      Value<String?> originalInput,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$TaskItemsTableUpdateCompanionBuilder =
    TaskItemsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> description,
      Value<String> status,
      Value<String> priority,
      Value<String> listId,
      Value<String?> groupId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> completedAt,
      Value<DateTime?> deletedAt,
      Value<DateTime?> dueDate,
      Value<String?> dueTime,
      Value<DateTime?> startDate,
      Value<String?> startTime,
      Value<String> timeZone,
      Value<bool> isAllDay,
      Value<bool> isPersistent,
      Value<bool> showInTodayUntilComplete,
      Value<DateTime?> persistentStartedAt,
      Value<DateTime?> persistentCompletedAt,
      Value<int> todayCarryForwardCount,
      Value<DateTime?> lastCarriedForwardAt,
      Value<String?> recurrenceRuleId,
      Value<String?> recurrenceParentTaskId,
      Value<DateTime?> recurrenceOccurrenceDate,
      Value<String?> originalInput,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$TaskItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskItemsTable> {
  $$TaskItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get listId => $composableBuilder(
    column: $table.listId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dueTime => $composableBuilder(
    column: $table.dueTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeZone => $composableBuilder(
    column: $table.timeZone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAllDay => $composableBuilder(
    column: $table.isAllDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPersistent => $composableBuilder(
    column: $table.isPersistent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showInTodayUntilComplete => $composableBuilder(
    column: $table.showInTodayUntilComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get persistentStartedAt => $composableBuilder(
    column: $table.persistentStartedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get persistentCompletedAt => $composableBuilder(
    column: $table.persistentCompletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get todayCarryForwardCount => $composableBuilder(
    column: $table.todayCarryForwardCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastCarriedForwardAt => $composableBuilder(
    column: $table.lastCarriedForwardAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurrenceRuleId => $composableBuilder(
    column: $table.recurrenceRuleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurrenceParentTaskId => $composableBuilder(
    column: $table.recurrenceParentTaskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recurrenceOccurrenceDate => $composableBuilder(
    column: $table.recurrenceOccurrenceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalInput => $composableBuilder(
    column: $table.originalInput,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TaskItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskItemsTable> {
  $$TaskItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get listId => $composableBuilder(
    column: $table.listId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupId => $composableBuilder(
    column: $table.groupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dueTime => $composableBuilder(
    column: $table.dueTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeZone => $composableBuilder(
    column: $table.timeZone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAllDay => $composableBuilder(
    column: $table.isAllDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPersistent => $composableBuilder(
    column: $table.isPersistent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showInTodayUntilComplete => $composableBuilder(
    column: $table.showInTodayUntilComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get persistentStartedAt => $composableBuilder(
    column: $table.persistentStartedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get persistentCompletedAt => $composableBuilder(
    column: $table.persistentCompletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get todayCarryForwardCount => $composableBuilder(
    column: $table.todayCarryForwardCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastCarriedForwardAt => $composableBuilder(
    column: $table.lastCarriedForwardAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrenceRuleId => $composableBuilder(
    column: $table.recurrenceRuleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrenceParentTaskId => $composableBuilder(
    column: $table.recurrenceParentTaskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recurrenceOccurrenceDate => $composableBuilder(
    column: $table.recurrenceOccurrenceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalInput => $composableBuilder(
    column: $table.originalInput,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskItemsTable> {
  $$TaskItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get listId =>
      $composableBuilder(column: $table.listId, builder: (column) => column);

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<String> get dueTime =>
      $composableBuilder(column: $table.dueTime, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<String> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<String> get timeZone =>
      $composableBuilder(column: $table.timeZone, builder: (column) => column);

  GeneratedColumn<bool> get isAllDay =>
      $composableBuilder(column: $table.isAllDay, builder: (column) => column);

  GeneratedColumn<bool> get isPersistent => $composableBuilder(
    column: $table.isPersistent,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showInTodayUntilComplete => $composableBuilder(
    column: $table.showInTodayUntilComplete,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get persistentStartedAt => $composableBuilder(
    column: $table.persistentStartedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get persistentCompletedAt => $composableBuilder(
    column: $table.persistentCompletedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get todayCarryForwardCount => $composableBuilder(
    column: $table.todayCarryForwardCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastCarriedForwardAt => $composableBuilder(
    column: $table.lastCarriedForwardAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recurrenceRuleId => $composableBuilder(
    column: $table.recurrenceRuleId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recurrenceParentTaskId => $composableBuilder(
    column: $table.recurrenceParentTaskId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get recurrenceOccurrenceDate => $composableBuilder(
    column: $table.recurrenceOccurrenceDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get originalInput => $composableBuilder(
    column: $table.originalInput,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$TaskItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskItemsTable,
          TaskItem,
          $$TaskItemsTableFilterComposer,
          $$TaskItemsTableOrderingComposer,
          $$TaskItemsTableAnnotationComposer,
          $$TaskItemsTableCreateCompanionBuilder,
          $$TaskItemsTableUpdateCompanionBuilder,
          (TaskItem, BaseReferences<_$AppDatabase, $TaskItemsTable, TaskItem>),
          TaskItem,
          PrefetchHooks Function()
        > {
  $$TaskItemsTableTableManager(_$AppDatabase db, $TaskItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<String> listId = const Value.absent(),
                Value<String?> groupId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<String?> dueTime = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<String?> startTime = const Value.absent(),
                Value<String> timeZone = const Value.absent(),
                Value<bool> isAllDay = const Value.absent(),
                Value<bool> isPersistent = const Value.absent(),
                Value<bool> showInTodayUntilComplete = const Value.absent(),
                Value<DateTime?> persistentStartedAt = const Value.absent(),
                Value<DateTime?> persistentCompletedAt = const Value.absent(),
                Value<int> todayCarryForwardCount = const Value.absent(),
                Value<DateTime?> lastCarriedForwardAt = const Value.absent(),
                Value<String?> recurrenceRuleId = const Value.absent(),
                Value<String?> recurrenceParentTaskId = const Value.absent(),
                Value<DateTime?> recurrenceOccurrenceDate =
                    const Value.absent(),
                Value<String?> originalInput = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskItemsCompanion(
                id: id,
                title: title,
                description: description,
                status: status,
                priority: priority,
                listId: listId,
                groupId: groupId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                completedAt: completedAt,
                deletedAt: deletedAt,
                dueDate: dueDate,
                dueTime: dueTime,
                startDate: startDate,
                startTime: startTime,
                timeZone: timeZone,
                isAllDay: isAllDay,
                isPersistent: isPersistent,
                showInTodayUntilComplete: showInTodayUntilComplete,
                persistentStartedAt: persistentStartedAt,
                persistentCompletedAt: persistentCompletedAt,
                todayCarryForwardCount: todayCarryForwardCount,
                lastCarriedForwardAt: lastCarriedForwardAt,
                recurrenceRuleId: recurrenceRuleId,
                recurrenceParentTaskId: recurrenceParentTaskId,
                recurrenceOccurrenceDate: recurrenceOccurrenceDate,
                originalInput: originalInput,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> priority = const Value.absent(),
                required String listId,
                Value<String?> groupId = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<DateTime?> dueDate = const Value.absent(),
                Value<String?> dueTime = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<String?> startTime = const Value.absent(),
                required String timeZone,
                Value<bool> isAllDay = const Value.absent(),
                Value<bool> isPersistent = const Value.absent(),
                Value<bool> showInTodayUntilComplete = const Value.absent(),
                Value<DateTime?> persistentStartedAt = const Value.absent(),
                Value<DateTime?> persistentCompletedAt = const Value.absent(),
                Value<int> todayCarryForwardCount = const Value.absent(),
                Value<DateTime?> lastCarriedForwardAt = const Value.absent(),
                Value<String?> recurrenceRuleId = const Value.absent(),
                Value<String?> recurrenceParentTaskId = const Value.absent(),
                Value<DateTime?> recurrenceOccurrenceDate =
                    const Value.absent(),
                Value<String?> originalInput = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskItemsCompanion.insert(
                id: id,
                title: title,
                description: description,
                status: status,
                priority: priority,
                listId: listId,
                groupId: groupId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                completedAt: completedAt,
                deletedAt: deletedAt,
                dueDate: dueDate,
                dueTime: dueTime,
                startDate: startDate,
                startTime: startTime,
                timeZone: timeZone,
                isAllDay: isAllDay,
                isPersistent: isPersistent,
                showInTodayUntilComplete: showInTodayUntilComplete,
                persistentStartedAt: persistentStartedAt,
                persistentCompletedAt: persistentCompletedAt,
                todayCarryForwardCount: todayCarryForwardCount,
                lastCarriedForwardAt: lastCarriedForwardAt,
                recurrenceRuleId: recurrenceRuleId,
                recurrenceParentTaskId: recurrenceParentTaskId,
                recurrenceOccurrenceDate: recurrenceOccurrenceDate,
                originalInput: originalInput,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TaskItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskItemsTable,
      TaskItem,
      $$TaskItemsTableFilterComposer,
      $$TaskItemsTableOrderingComposer,
      $$TaskItemsTableAnnotationComposer,
      $$TaskItemsTableCreateCompanionBuilder,
      $$TaskItemsTableUpdateCompanionBuilder,
      (TaskItem, BaseReferences<_$AppDatabase, $TaskItemsTable, TaskItem>),
      TaskItem,
      PrefetchHooks Function()
    >;
typedef $$TaskListsTableCreateCompanionBuilder =
    TaskListsCompanion Function({
      required String id,
      required String name,
      Value<String> color,
      Value<String?> icon,
      Value<int> sortOrder,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isArchived,
      Value<bool> isSystemList,
      Value<int> rowid,
    });
typedef $$TaskListsTableUpdateCompanionBuilder =
    TaskListsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> color,
      Value<String?> icon,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isArchived,
      Value<bool> isSystemList,
      Value<int> rowid,
    });

class $$TaskListsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskListsTable> {
  $$TaskListsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystemList => $composableBuilder(
    column: $table.isSystemList,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TaskListsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskListsTable> {
  $$TaskListsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystemList => $composableBuilder(
    column: $table.isSystemList,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskListsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskListsTable> {
  $$TaskListsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSystemList => $composableBuilder(
    column: $table.isSystemList,
    builder: (column) => column,
  );
}

class $$TaskListsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskListsTable,
          TaskList,
          $$TaskListsTableFilterComposer,
          $$TaskListsTableOrderingComposer,
          $$TaskListsTableAnnotationComposer,
          $$TaskListsTableCreateCompanionBuilder,
          $$TaskListsTableUpdateCompanionBuilder,
          (TaskList, BaseReferences<_$AppDatabase, $TaskListsTable, TaskList>),
          TaskList,
          PrefetchHooks Function()
        > {
  $$TaskListsTableTableManager(_$AppDatabase db, $TaskListsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskListsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskListsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskListsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<bool> isSystemList = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskListsCompanion(
                id: id,
                name: name,
                color: color,
                icon: icon,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isArchived: isArchived,
                isSystemList: isSystemList,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isArchived = const Value.absent(),
                Value<bool> isSystemList = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskListsCompanion.insert(
                id: id,
                name: name,
                color: color,
                icon: icon,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isArchived: isArchived,
                isSystemList: isSystemList,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TaskListsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskListsTable,
      TaskList,
      $$TaskListsTableFilterComposer,
      $$TaskListsTableOrderingComposer,
      $$TaskListsTableAnnotationComposer,
      $$TaskListsTableCreateCompanionBuilder,
      $$TaskListsTableUpdateCompanionBuilder,
      (TaskList, BaseReferences<_$AppDatabase, $TaskListsTable, TaskList>),
      TaskList,
      PrefetchHooks Function()
    >;
typedef $$ListGroupsTableCreateCompanionBuilder =
    ListGroupsCompanion Function({
      required String id,
      required String listId,
      required String name,
      Value<int> sortOrder,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isCollapsed,
      Value<int> rowid,
    });
typedef $$ListGroupsTableUpdateCompanionBuilder =
    ListGroupsCompanion Function({
      Value<String> id,
      Value<String> listId,
      Value<String> name,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isCollapsed,
      Value<int> rowid,
    });

class $$ListGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $ListGroupsTable> {
  $$ListGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get listId => $composableBuilder(
    column: $table.listId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCollapsed => $composableBuilder(
    column: $table.isCollapsed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ListGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $ListGroupsTable> {
  $$ListGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get listId => $composableBuilder(
    column: $table.listId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCollapsed => $composableBuilder(
    column: $table.isCollapsed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ListGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ListGroupsTable> {
  $$ListGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get listId =>
      $composableBuilder(column: $table.listId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isCollapsed => $composableBuilder(
    column: $table.isCollapsed,
    builder: (column) => column,
  );
}

class $$ListGroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ListGroupsTable,
          ListGroup,
          $$ListGroupsTableFilterComposer,
          $$ListGroupsTableOrderingComposer,
          $$ListGroupsTableAnnotationComposer,
          $$ListGroupsTableCreateCompanionBuilder,
          $$ListGroupsTableUpdateCompanionBuilder,
          (
            ListGroup,
            BaseReferences<_$AppDatabase, $ListGroupsTable, ListGroup>,
          ),
          ListGroup,
          PrefetchHooks Function()
        > {
  $$ListGroupsTableTableManager(_$AppDatabase db, $ListGroupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ListGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ListGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ListGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> listId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isCollapsed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ListGroupsCompanion(
                id: id,
                listId: listId,
                name: name,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isCollapsed: isCollapsed,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String listId,
                required String name,
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isCollapsed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ListGroupsCompanion.insert(
                id: id,
                listId: listId,
                name: name,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isCollapsed: isCollapsed,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ListGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ListGroupsTable,
      ListGroup,
      $$ListGroupsTableFilterComposer,
      $$ListGroupsTableOrderingComposer,
      $$ListGroupsTableAnnotationComposer,
      $$ListGroupsTableCreateCompanionBuilder,
      $$ListGroupsTableUpdateCompanionBuilder,
      (ListGroup, BaseReferences<_$AppDatabase, $ListGroupsTable, ListGroup>),
      ListGroup,
      PrefetchHooks Function()
    >;
typedef $$ReminderEntriesTableCreateCompanionBuilder =
    ReminderEntriesCompanion Function({
      required String id,
      required String taskId,
      required String reminderType,
      required DateTime remindAt,
      Value<int?> offsetMinutes,
      Value<bool> isEnabled,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ReminderEntriesTableUpdateCompanionBuilder =
    ReminderEntriesCompanion Function({
      Value<String> id,
      Value<String> taskId,
      Value<String> reminderType,
      Value<DateTime> remindAt,
      Value<int?> offsetMinutes,
      Value<bool> isEnabled,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ReminderEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ReminderEntriesTable> {
  $$ReminderEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminderType => $composableBuilder(
    column: $table.reminderType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get remindAt => $composableBuilder(
    column: $table.remindAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get offsetMinutes => $composableBuilder(
    column: $table.offsetMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReminderEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReminderEntriesTable> {
  $$ReminderEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminderType => $composableBuilder(
    column: $table.reminderType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get remindAt => $composableBuilder(
    column: $table.remindAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get offsetMinutes => $composableBuilder(
    column: $table.offsetMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReminderEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReminderEntriesTable> {
  $$ReminderEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get reminderType => $composableBuilder(
    column: $table.reminderType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get remindAt =>
      $composableBuilder(column: $table.remindAt, builder: (column) => column);

  GeneratedColumn<int> get offsetMinutes => $composableBuilder(
    column: $table.offsetMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ReminderEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReminderEntriesTable,
          ReminderEntry,
          $$ReminderEntriesTableFilterComposer,
          $$ReminderEntriesTableOrderingComposer,
          $$ReminderEntriesTableAnnotationComposer,
          $$ReminderEntriesTableCreateCompanionBuilder,
          $$ReminderEntriesTableUpdateCompanionBuilder,
          (
            ReminderEntry,
            BaseReferences<_$AppDatabase, $ReminderEntriesTable, ReminderEntry>,
          ),
          ReminderEntry,
          PrefetchHooks Function()
        > {
  $$ReminderEntriesTableTableManager(
    _$AppDatabase db,
    $ReminderEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReminderEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReminderEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReminderEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<String> reminderType = const Value.absent(),
                Value<DateTime> remindAt = const Value.absent(),
                Value<int?> offsetMinutes = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReminderEntriesCompanion(
                id: id,
                taskId: taskId,
                reminderType: reminderType,
                remindAt: remindAt,
                offsetMinutes: offsetMinutes,
                isEnabled: isEnabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskId,
                required String reminderType,
                required DateTime remindAt,
                Value<int?> offsetMinutes = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ReminderEntriesCompanion.insert(
                id: id,
                taskId: taskId,
                reminderType: reminderType,
                remindAt: remindAt,
                offsetMinutes: offsetMinutes,
                isEnabled: isEnabled,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReminderEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReminderEntriesTable,
      ReminderEntry,
      $$ReminderEntriesTableFilterComposer,
      $$ReminderEntriesTableOrderingComposer,
      $$ReminderEntriesTableAnnotationComposer,
      $$ReminderEntriesTableCreateCompanionBuilder,
      $$ReminderEntriesTableUpdateCompanionBuilder,
      (
        ReminderEntry,
        BaseReferences<_$AppDatabase, $ReminderEntriesTable, ReminderEntry>,
      ),
      ReminderEntry,
      PrefetchHooks Function()
    >;
typedef $$RecurrenceRuleEntriesTableCreateCompanionBuilder =
    RecurrenceRuleEntriesCompanion Function({
      required String id,
      required String repeatFrequency,
      Value<int> repeatInterval,
      Value<String?> repeatWeekdays,
      Value<int?> repeatMonthDay,
      Value<String> repeatEndType,
      Value<DateTime?> repeatEndDate,
      Value<int?> repeatOccurrenceCount,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$RecurrenceRuleEntriesTableUpdateCompanionBuilder =
    RecurrenceRuleEntriesCompanion Function({
      Value<String> id,
      Value<String> repeatFrequency,
      Value<int> repeatInterval,
      Value<String?> repeatWeekdays,
      Value<int?> repeatMonthDay,
      Value<String> repeatEndType,
      Value<DateTime?> repeatEndDate,
      Value<int?> repeatOccurrenceCount,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$RecurrenceRuleEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $RecurrenceRuleEntriesTable> {
  $$RecurrenceRuleEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatFrequency => $composableBuilder(
    column: $table.repeatFrequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repeatInterval => $composableBuilder(
    column: $table.repeatInterval,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatWeekdays => $composableBuilder(
    column: $table.repeatWeekdays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repeatMonthDay => $composableBuilder(
    column: $table.repeatMonthDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get repeatEndType => $composableBuilder(
    column: $table.repeatEndType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get repeatEndDate => $composableBuilder(
    column: $table.repeatEndDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repeatOccurrenceCount => $composableBuilder(
    column: $table.repeatOccurrenceCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecurrenceRuleEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurrenceRuleEntriesTable> {
  $$RecurrenceRuleEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatFrequency => $composableBuilder(
    column: $table.repeatFrequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repeatInterval => $composableBuilder(
    column: $table.repeatInterval,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatWeekdays => $composableBuilder(
    column: $table.repeatWeekdays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repeatMonthDay => $composableBuilder(
    column: $table.repeatMonthDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get repeatEndType => $composableBuilder(
    column: $table.repeatEndType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get repeatEndDate => $composableBuilder(
    column: $table.repeatEndDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repeatOccurrenceCount => $composableBuilder(
    column: $table.repeatOccurrenceCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecurrenceRuleEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurrenceRuleEntriesTable> {
  $$RecurrenceRuleEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get repeatFrequency => $composableBuilder(
    column: $table.repeatFrequency,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repeatInterval => $composableBuilder(
    column: $table.repeatInterval,
    builder: (column) => column,
  );

  GeneratedColumn<String> get repeatWeekdays => $composableBuilder(
    column: $table.repeatWeekdays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repeatMonthDay => $composableBuilder(
    column: $table.repeatMonthDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get repeatEndType => $composableBuilder(
    column: $table.repeatEndType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get repeatEndDate => $composableBuilder(
    column: $table.repeatEndDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get repeatOccurrenceCount => $composableBuilder(
    column: $table.repeatOccurrenceCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$RecurrenceRuleEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecurrenceRuleEntriesTable,
          RecurrenceRuleEntry,
          $$RecurrenceRuleEntriesTableFilterComposer,
          $$RecurrenceRuleEntriesTableOrderingComposer,
          $$RecurrenceRuleEntriesTableAnnotationComposer,
          $$RecurrenceRuleEntriesTableCreateCompanionBuilder,
          $$RecurrenceRuleEntriesTableUpdateCompanionBuilder,
          (
            RecurrenceRuleEntry,
            BaseReferences<
              _$AppDatabase,
              $RecurrenceRuleEntriesTable,
              RecurrenceRuleEntry
            >,
          ),
          RecurrenceRuleEntry,
          PrefetchHooks Function()
        > {
  $$RecurrenceRuleEntriesTableTableManager(
    _$AppDatabase db,
    $RecurrenceRuleEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurrenceRuleEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RecurrenceRuleEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RecurrenceRuleEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> repeatFrequency = const Value.absent(),
                Value<int> repeatInterval = const Value.absent(),
                Value<String?> repeatWeekdays = const Value.absent(),
                Value<int?> repeatMonthDay = const Value.absent(),
                Value<String> repeatEndType = const Value.absent(),
                Value<DateTime?> repeatEndDate = const Value.absent(),
                Value<int?> repeatOccurrenceCount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecurrenceRuleEntriesCompanion(
                id: id,
                repeatFrequency: repeatFrequency,
                repeatInterval: repeatInterval,
                repeatWeekdays: repeatWeekdays,
                repeatMonthDay: repeatMonthDay,
                repeatEndType: repeatEndType,
                repeatEndDate: repeatEndDate,
                repeatOccurrenceCount: repeatOccurrenceCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String repeatFrequency,
                Value<int> repeatInterval = const Value.absent(),
                Value<String?> repeatWeekdays = const Value.absent(),
                Value<int?> repeatMonthDay = const Value.absent(),
                Value<String> repeatEndType = const Value.absent(),
                Value<DateTime?> repeatEndDate = const Value.absent(),
                Value<int?> repeatOccurrenceCount = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RecurrenceRuleEntriesCompanion.insert(
                id: id,
                repeatFrequency: repeatFrequency,
                repeatInterval: repeatInterval,
                repeatWeekdays: repeatWeekdays,
                repeatMonthDay: repeatMonthDay,
                repeatEndType: repeatEndType,
                repeatEndDate: repeatEndDate,
                repeatOccurrenceCount: repeatOccurrenceCount,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecurrenceRuleEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecurrenceRuleEntriesTable,
      RecurrenceRuleEntry,
      $$RecurrenceRuleEntriesTableFilterComposer,
      $$RecurrenceRuleEntriesTableOrderingComposer,
      $$RecurrenceRuleEntriesTableAnnotationComposer,
      $$RecurrenceRuleEntriesTableCreateCompanionBuilder,
      $$RecurrenceRuleEntriesTableUpdateCompanionBuilder,
      (
        RecurrenceRuleEntry,
        BaseReferences<
          _$AppDatabase,
          $RecurrenceRuleEntriesTable,
          RecurrenceRuleEntry
        >,
      ),
      RecurrenceRuleEntry,
      PrefetchHooks Function()
    >;
typedef $$SettingsEntriesTableCreateCompanionBuilder =
    SettingsEntriesCompanion Function({
      required String key,
      required String value,
      required String valueType,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SettingsEntriesTableUpdateCompanionBuilder =
    SettingsEntriesCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<String> valueType,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SettingsEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsEntriesTable> {
  $$SettingsEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueType => $composableBuilder(
    column: $table.valueType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsEntriesTable> {
  $$SettingsEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueType => $composableBuilder(
    column: $table.valueType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsEntriesTable> {
  $$SettingsEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get valueType =>
      $composableBuilder(column: $table.valueType, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SettingsEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsEntriesTable,
          SettingsEntry,
          $$SettingsEntriesTableFilterComposer,
          $$SettingsEntriesTableOrderingComposer,
          $$SettingsEntriesTableAnnotationComposer,
          $$SettingsEntriesTableCreateCompanionBuilder,
          $$SettingsEntriesTableUpdateCompanionBuilder,
          (
            SettingsEntry,
            BaseReferences<_$AppDatabase, $SettingsEntriesTable, SettingsEntry>,
          ),
          SettingsEntry,
          PrefetchHooks Function()
        > {
  $$SettingsEntriesTableTableManager(
    _$AppDatabase db,
    $SettingsEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<String> valueType = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsEntriesCompanion(
                key: key,
                value: value,
                valueType: valueType,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required String valueType,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SettingsEntriesCompanion.insert(
                key: key,
                value: value,
                valueType: valueType,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsEntriesTable,
      SettingsEntry,
      $$SettingsEntriesTableFilterComposer,
      $$SettingsEntriesTableOrderingComposer,
      $$SettingsEntriesTableAnnotationComposer,
      $$SettingsEntriesTableCreateCompanionBuilder,
      $$SettingsEntriesTableUpdateCompanionBuilder,
      (
        SettingsEntry,
        BaseReferences<_$AppDatabase, $SettingsEntriesTable, SettingsEntry>,
      ),
      SettingsEntry,
      PrefetchHooks Function()
    >;
typedef $$ActivityLogEntriesTableCreateCompanionBuilder =
    ActivityLogEntriesCompanion Function({
      required String id,
      required String entityType,
      required String entityId,
      required String action,
      Value<String?> metadataJson,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ActivityLogEntriesTableUpdateCompanionBuilder =
    ActivityLogEntriesCompanion Function({
      Value<String> id,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> action,
      Value<String?> metadataJson,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ActivityLogEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityLogEntriesTable> {
  $$ActivityLogEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivityLogEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityLogEntriesTable> {
  $$ActivityLogEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivityLogEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityLogEntriesTable> {
  $$ActivityLogEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get metadataJson => $composableBuilder(
    column: $table.metadataJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ActivityLogEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityLogEntriesTable,
          ActivityLogEntry,
          $$ActivityLogEntriesTableFilterComposer,
          $$ActivityLogEntriesTableOrderingComposer,
          $$ActivityLogEntriesTableAnnotationComposer,
          $$ActivityLogEntriesTableCreateCompanionBuilder,
          $$ActivityLogEntriesTableUpdateCompanionBuilder,
          (
            ActivityLogEntry,
            BaseReferences<
              _$AppDatabase,
              $ActivityLogEntriesTable,
              ActivityLogEntry
            >,
          ),
          ActivityLogEntry,
          PrefetchHooks Function()
        > {
  $$ActivityLogEntriesTableTableManager(
    _$AppDatabase db,
    $ActivityLogEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityLogEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityLogEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityLogEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String?> metadataJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityLogEntriesCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                action: action,
                metadataJson: metadataJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityType,
                required String entityId,
                required String action,
                Value<String?> metadataJson = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ActivityLogEntriesCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                action: action,
                metadataJson: metadataJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivityLogEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityLogEntriesTable,
      ActivityLogEntry,
      $$ActivityLogEntriesTableFilterComposer,
      $$ActivityLogEntriesTableOrderingComposer,
      $$ActivityLogEntriesTableAnnotationComposer,
      $$ActivityLogEntriesTableCreateCompanionBuilder,
      $$ActivityLogEntriesTableUpdateCompanionBuilder,
      (
        ActivityLogEntry,
        BaseReferences<
          _$AppDatabase,
          $ActivityLogEntriesTable,
          ActivityLogEntry
        >,
      ),
      ActivityLogEntry,
      PrefetchHooks Function()
    >;
typedef $$WidgetSnapshotEntriesTableCreateCompanionBuilder =
    WidgetSnapshotEntriesCompanion Function({
      required String id,
      required int dueTodayCount,
      required DateTime generatedAt,
      required String timeZone,
      required String nextDueTodayTasksJson,
      Value<int> rowid,
    });
typedef $$WidgetSnapshotEntriesTableUpdateCompanionBuilder =
    WidgetSnapshotEntriesCompanion Function({
      Value<String> id,
      Value<int> dueTodayCount,
      Value<DateTime> generatedAt,
      Value<String> timeZone,
      Value<String> nextDueTodayTasksJson,
      Value<int> rowid,
    });

class $$WidgetSnapshotEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $WidgetSnapshotEntriesTable> {
  $$WidgetSnapshotEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueTodayCount => $composableBuilder(
    column: $table.dueTodayCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeZone => $composableBuilder(
    column: $table.timeZone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nextDueTodayTasksJson => $composableBuilder(
    column: $table.nextDueTodayTasksJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WidgetSnapshotEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $WidgetSnapshotEntriesTable> {
  $$WidgetSnapshotEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueTodayCount => $composableBuilder(
    column: $table.dueTodayCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeZone => $composableBuilder(
    column: $table.timeZone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nextDueTodayTasksJson => $composableBuilder(
    column: $table.nextDueTodayTasksJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WidgetSnapshotEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WidgetSnapshotEntriesTable> {
  $$WidgetSnapshotEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get dueTodayCount => $composableBuilder(
    column: $table.dueTodayCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timeZone =>
      $composableBuilder(column: $table.timeZone, builder: (column) => column);

  GeneratedColumn<String> get nextDueTodayTasksJson => $composableBuilder(
    column: $table.nextDueTodayTasksJson,
    builder: (column) => column,
  );
}

class $$WidgetSnapshotEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WidgetSnapshotEntriesTable,
          WidgetSnapshotEntry,
          $$WidgetSnapshotEntriesTableFilterComposer,
          $$WidgetSnapshotEntriesTableOrderingComposer,
          $$WidgetSnapshotEntriesTableAnnotationComposer,
          $$WidgetSnapshotEntriesTableCreateCompanionBuilder,
          $$WidgetSnapshotEntriesTableUpdateCompanionBuilder,
          (
            WidgetSnapshotEntry,
            BaseReferences<
              _$AppDatabase,
              $WidgetSnapshotEntriesTable,
              WidgetSnapshotEntry
            >,
          ),
          WidgetSnapshotEntry,
          PrefetchHooks Function()
        > {
  $$WidgetSnapshotEntriesTableTableManager(
    _$AppDatabase db,
    $WidgetSnapshotEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WidgetSnapshotEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$WidgetSnapshotEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$WidgetSnapshotEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> dueTodayCount = const Value.absent(),
                Value<DateTime> generatedAt = const Value.absent(),
                Value<String> timeZone = const Value.absent(),
                Value<String> nextDueTodayTasksJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WidgetSnapshotEntriesCompanion(
                id: id,
                dueTodayCount: dueTodayCount,
                generatedAt: generatedAt,
                timeZone: timeZone,
                nextDueTodayTasksJson: nextDueTodayTasksJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int dueTodayCount,
                required DateTime generatedAt,
                required String timeZone,
                required String nextDueTodayTasksJson,
                Value<int> rowid = const Value.absent(),
              }) => WidgetSnapshotEntriesCompanion.insert(
                id: id,
                dueTodayCount: dueTodayCount,
                generatedAt: generatedAt,
                timeZone: timeZone,
                nextDueTodayTasksJson: nextDueTodayTasksJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WidgetSnapshotEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WidgetSnapshotEntriesTable,
      WidgetSnapshotEntry,
      $$WidgetSnapshotEntriesTableFilterComposer,
      $$WidgetSnapshotEntriesTableOrderingComposer,
      $$WidgetSnapshotEntriesTableAnnotationComposer,
      $$WidgetSnapshotEntriesTableCreateCompanionBuilder,
      $$WidgetSnapshotEntriesTableUpdateCompanionBuilder,
      (
        WidgetSnapshotEntry,
        BaseReferences<
          _$AppDatabase,
          $WidgetSnapshotEntriesTable,
          WidgetSnapshotEntry
        >,
      ),
      WidgetSnapshotEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TaskItemsTableTableManager get taskItems =>
      $$TaskItemsTableTableManager(_db, _db.taskItems);
  $$TaskListsTableTableManager get taskLists =>
      $$TaskListsTableTableManager(_db, _db.taskLists);
  $$ListGroupsTableTableManager get listGroups =>
      $$ListGroupsTableTableManager(_db, _db.listGroups);
  $$ReminderEntriesTableTableManager get reminderEntries =>
      $$ReminderEntriesTableTableManager(_db, _db.reminderEntries);
  $$RecurrenceRuleEntriesTableTableManager get recurrenceRuleEntries =>
      $$RecurrenceRuleEntriesTableTableManager(_db, _db.recurrenceRuleEntries);
  $$SettingsEntriesTableTableManager get settingsEntries =>
      $$SettingsEntriesTableTableManager(_db, _db.settingsEntries);
  $$ActivityLogEntriesTableTableManager get activityLogEntries =>
      $$ActivityLogEntriesTableTableManager(_db, _db.activityLogEntries);
  $$WidgetSnapshotEntriesTableTableManager get widgetSnapshotEntries =>
      $$WidgetSnapshotEntriesTableTableManager(_db, _db.widgetSnapshotEntries);
}
