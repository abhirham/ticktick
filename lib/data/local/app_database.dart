import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('TaskItem')
class TaskItems extends Table {
  @override
  String get tableName => 'tasks';

  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 240)();
  TextColumn get description => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('open'))();
  TextColumn get priority => text().withDefault(const Constant('none'))();
  TextColumn get listId => text().named('list_id')();
  TextColumn get groupId => text().named('group_id').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  DateTimeColumn get completedAt =>
      dateTime().named('completed_at').nullable()();
  DateTimeColumn get deletedAt => dateTime().named('deleted_at').nullable()();
  DateTimeColumn get dueDate => dateTime().named('due_date').nullable()();
  TextColumn get dueTime => text().named('due_time').nullable()();
  DateTimeColumn get startDate => dateTime().named('start_date').nullable()();
  TextColumn get startTime => text().named('start_time').nullable()();
  TextColumn get timeZone => text().named('time_zone')();
  BoolColumn get isAllDay =>
      boolean().named('is_all_day').withDefault(const Constant(true))();
  BoolColumn get isPersistent =>
      boolean().named('is_persistent').withDefault(const Constant(false))();
  BoolColumn get showInTodayUntilComplete => boolean()
      .named('show_in_today_until_complete')
      .withDefault(const Constant(false))();
  DateTimeColumn get persistentStartedAt =>
      dateTime().named('persistent_started_at').nullable()();
  DateTimeColumn get persistentCompletedAt =>
      dateTime().named('persistent_completed_at').nullable()();
  IntColumn get todayCarryForwardCount => integer()
      .named('today_carry_forward_count')
      .withDefault(const Constant(0))();
  DateTimeColumn get lastCarriedForwardAt =>
      dateTime().named('last_carried_forward_at').nullable()();
  TextColumn get recurrenceRuleId =>
      text().named('recurrence_rule_id').nullable()();
  TextColumn get recurrenceParentTaskId =>
      text().named('recurrence_parent_task_id').nullable()();
  DateTimeColumn get recurrenceOccurrenceDate =>
      dateTime().named('recurrence_occurrence_date').nullable()();
  TextColumn get originalInput => text().named('original_input').nullable()();
  IntColumn get sortOrder =>
      integer().named('sort_order').withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('TaskList')
class TaskLists extends Table {
  @override
  String get tableName => 'lists';

  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  TextColumn get color => text().withDefault(const Constant('#4774FA'))();
  TextColumn get icon => text().nullable()();
  IntColumn get sortOrder =>
      integer().named('sort_order').withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  BoolColumn get isArchived =>
      boolean().named('is_archived').withDefault(const Constant(false))();
  BoolColumn get isSystemList =>
      boolean().named('is_system_list').withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ListGroup')
class ListGroups extends Table {
  @override
  String get tableName => 'list_groups';

  TextColumn get id => text()();
  TextColumn get listId => text().named('list_id')();
  TextColumn get name => text().withLength(min: 1, max: 80)();
  IntColumn get sortOrder =>
      integer().named('sort_order').withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  BoolColumn get isCollapsed =>
      boolean().named('is_collapsed').withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ReminderEntry')
class ReminderEntries extends Table {
  @override
  String get tableName => 'reminders';

  TextColumn get id => text()();
  TextColumn get taskId => text().named('task_id')();
  TextColumn get reminderType => text().named('reminder_type')();
  DateTimeColumn get remindAt => dateTime().named('remind_at')();
  IntColumn get offsetMinutes => integer().named('offset_minutes').nullable()();
  BoolColumn get isEnabled =>
      boolean().named('is_enabled').withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('RecurrenceRuleEntry')
class RecurrenceRuleEntries extends Table {
  @override
  String get tableName => 'recurrence_rules';

  TextColumn get id => text()();
  TextColumn get repeatFrequency => text().named('repeat_frequency')();
  IntColumn get repeatInterval =>
      integer().named('repeat_interval').withDefault(const Constant(1))();
  TextColumn get repeatWeekdays => text().named('repeat_weekdays').nullable()();
  IntColumn get repeatMonthDay =>
      integer().named('repeat_month_day').nullable()();
  IntColumn get repeatMonthOrdinal =>
      integer().named('repeat_month_ordinal').nullable()();
  IntColumn get repeatMonthWeekday =>
      integer().named('repeat_month_weekday').nullable()();
  TextColumn get repeatEndType =>
      text().named('repeat_end_type').withDefault(const Constant('never'))();
  DateTimeColumn get repeatEndDate =>
      dateTime().named('repeat_end_date').nullable()();
  IntColumn get repeatOccurrenceCount =>
      integer().named('repeat_occurrence_count').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('SettingsEntry')
class SettingsEntries extends Table {
  @override
  String get tableName => 'settings';

  TextColumn get key => text()();
  TextColumn get value => text()();
  TextColumn get valueType => text().named('value_type')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DataClassName('ActivityLogEntry')
class ActivityLogEntries extends Table {
  @override
  String get tableName => 'activity_logs';

  TextColumn get id => text()();
  TextColumn get entityType => text().named('entity_type')();
  TextColumn get entityId => text().named('entity_id')();
  TextColumn get action => text()();
  TextColumn get metadataJson => text().named('metadata_json').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('WidgetSnapshotEntry')
class WidgetSnapshotEntries extends Table {
  @override
  String get tableName => 'widget_snapshots';

  TextColumn get id => text()();
  IntColumn get dueTodayCount => integer().named('due_today_count')();
  DateTimeColumn get generatedAt => dateTime().named('generated_at')();
  TextColumn get timeZone => text().named('time_zone')();
  TextColumn get nextDueTodayTasksJson =>
      text().named('next_due_today_tasks_json')();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    TaskItems,
    TaskLists,
    ListGroups,
    ReminderEntries,
    RecurrenceRuleEntries,
    SettingsEntries,
    ActivityLogEntries,
    WidgetSnapshotEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'flowtask'));

  static const inboxListId = 'inbox';
  static const settingsDefaults = <String, (String, String)>{
    'themeMode': ('system', 'string'),
    'remindersEnabled': ('true', 'bool'),
    'defaultReminderOffsetMinutes': ('0', 'int'),
    'showOverdueTasksInToday': ('false', 'bool'),
    'showPersistentTasksInToday': ('true', 'bool'),
    'showCarriedForwardCount': ('true', 'bool'),
    'persistentTaskPosition': ('afterScheduledTasks', 'string'),
    'defaultListId': (inboxListId, 'string'),
    'defaultGrouping': ('manualGroups', 'string'),
    'defaultCalendarView': ('month', 'string'),
    'firstDayOfWeek': ('system', 'string'),
    'showCompletedTasksInCalendar': ('false', 'bool'),
    'widgetDisplayMode': ('countOnly', 'string'),
    'widgetShowsLockScreenTitles': ('false', 'bool'),
    'widgetTapDestination': ('today', 'string'),
    'repeatingOverdueBehavior': ('completeOverdueAndGenerateNext', 'string'),
  };

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (migrator) async {
        await migrator.createAll();
        await _seedDefaults();
      },
      onUpgrade: (migrator, from, to) async {
        if (from < 2) {
          await migrator.addColumn(
            recurrenceRuleEntries,
            recurrenceRuleEntries.repeatMonthOrdinal,
          );
          await migrator.addColumn(
            recurrenceRuleEntries,
            recurrenceRuleEntries.repeatMonthWeekday,
          );
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
        await _seedDefaults();
      },
    );
  }

  Future<void> _seedDefaults() async {
    final now = DateTime.now();
    await into(taskLists).insertOnConflictUpdate(
      TaskListsCompanion.insert(
        id: inboxListId,
        name: 'Inbox',
        color: const Value('#4774FA'),
        sortOrder: const Value(0),
        createdAt: now,
        updatedAt: now,
        isSystemList: const Value(true),
      ),
    );

    for (final entry in settingsDefaults.entries) {
      await into(settingsEntries).insert(
        SettingsEntriesCompanion.insert(
          key: entry.key,
          value: entry.value.$1,
          valueType: entry.value.$2,
          updatedAt: now,
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }
  }
}
