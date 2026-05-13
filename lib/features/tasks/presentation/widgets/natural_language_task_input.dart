import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../core/time/flow_date_utils.dart';
import '../../../../data/local/app_database.dart';
import '../../../../shared/presentation/flow_bottom_sheet.dart';
import '../../domain/natural_language_task_parser.dart';
import '../../domain/task_draft.dart';
import '../../domain/task_enums.dart';

enum TaskInputMetadataKind {
  date,
  time,
  repeat,
  reminder,
  priority,
  list,
  group,
  persistent,
}

enum TaskInputDateChoice { none, today, tomorrow, pick }

enum TaskInputReminderChoice {
  none,
  morning,
  atDueTime,
  tenMinutesBefore,
  oneHourBefore,
}

enum TaskInputRepeatChoice { none, daily, weekdays, weekly, monthly }

class NaturalLanguageTaskFormState {
  NaturalLanguageTaskFormState({
    DateTime Function()? now,
    DateTime? fallbackDueDate,
  }) : _now = now ?? DateTime.now,
       fallbackDueDate = fallbackDueDate == null
           ? null
           : dateOnly(fallbackDueDate) {
    parsed = NaturalLanguageTaskParser.parse('', _now());
    _lastSignatures = taskInputMetadataSignatures(parsed);
  }

  final DateTime Function() _now;
  DateTime? fallbackDueDate;
  late ParsedTaskInput parsed;
  late Map<TaskInputMetadataKind, Object?> _lastSignatures;
  final Set<TaskInputMetadataKind> _removed = {};
  final Set<TaskInputMetadataKind> _overridden = {};

  DateTime? _dueDateOverride;
  String? _dueTimeOverride;
  TaskRepeatDraft? _repeatOverride;
  List<TaskReminderDraft> _remindersOverride = const [];
  TaskPriority? _priorityOverride;
  String? _listIdOverride;
  String? _groupIdOverride;
  bool? _persistentOverride;

  void parse(String input) {
    final next = NaturalLanguageTaskParser.parse(input, _now());
    final nextSignatures = taskInputMetadataSignatures(next);
    _removed.removeWhere((kind) {
      return _lastSignatures[kind] != nextSignatures[kind];
    });
    parsed = next;
    _lastSignatures = nextSignatures;
  }

  bool hasParsedMetadata(TaskInputMetadataKind kind) {
    return taskInputMetadataSignature(parsed, kind) != null;
  }

  bool isRemoved(TaskInputMetadataKind kind) => _removed.contains(kind);

  bool shouldShowChip(
    TaskInputMetadataKind kind, {
    required List<TaskList> lists,
    required List<ListGroup> groups,
    bool includeInactive = true,
    bool listsLoaded = true,
    bool groupsLoaded = true,
  }) {
    if (includeInactive) {
      return true;
    }
    if (isWarning(
      kind,
      lists: lists,
      groups: groups,
      listsLoaded: listsLoaded,
      groupsLoaded: groupsLoaded,
    )) {
      return true;
    }
    return _overridden.contains(kind) ||
        (hasParsedMetadata(kind) && !_removed.contains(kind));
  }

  bool isWarning(
    TaskInputMetadataKind kind, {
    required List<TaskList> lists,
    required List<ListGroup> groups,
    bool listsLoaded = true,
    bool groupsLoaded = true,
  }) {
    if (kind == TaskInputMetadataKind.list) {
      return parsed.listName != null &&
          !_removed.contains(TaskInputMetadataKind.list) &&
          listsLoaded &&
          parsedListMatch(lists) == null;
    }
    if (kind == TaskInputMetadataKind.group) {
      if (parsed.groupName == null ||
          _removed.contains(TaskInputMetadataKind.group)) {
        return false;
      }
      final listMissing =
          parsed.listName != null &&
          !_removed.contains(TaskInputMetadataKind.list) &&
          listsLoaded &&
          parsedListMatch(lists) == null;
      return listMissing ||
          (groupsLoaded && parsedGroupMatch(lists, groups) == null);
    }
    return false;
  }

  DateTime? get dueDate {
    if (_removed.contains(TaskInputMetadataKind.date)) {
      return null;
    }
    if (_overridden.contains(TaskInputMetadataKind.date)) {
      return _dueDateOverride;
    }
    return parsed.dueDate ?? fallbackDueDate;
  }

  String? get dueTime {
    if (_removed.contains(TaskInputMetadataKind.time)) {
      return null;
    }
    if (_overridden.contains(TaskInputMetadataKind.time)) {
      return _dueTimeOverride;
    }
    return parsed.dueTime;
  }

  TaskRepeatDraft? get repeatRule {
    if (_removed.contains(TaskInputMetadataKind.repeat)) {
      return null;
    }
    if (_overridden.contains(TaskInputMetadataKind.repeat)) {
      return _repeatOverride;
    }
    return parsed.recurrence?.toTaskRepeatDraft(dueDate: dueDate);
  }

  List<TaskReminderDraft> get reminders {
    if (_removed.contains(TaskInputMetadataKind.reminder)) {
      return const [];
    }
    if (_overridden.contains(TaskInputMetadataKind.reminder)) {
      return _remindersOverride;
    }
    final reminder = parsed.reminder?.toTaskReminderDraft(
      dueDate: dueDate,
      dueTime: dueTime,
    );
    return reminder == null ? const [] : [reminder];
  }

  TaskPriority get priority {
    if (_removed.contains(TaskInputMetadataKind.priority)) {
      return TaskPriority.none;
    }
    if (_overridden.contains(TaskInputMetadataKind.priority)) {
      return _priorityOverride ?? TaskPriority.none;
    }
    return parsed.priority;
  }

  bool get isPersistent {
    if (_removed.contains(TaskInputMetadataKind.persistent)) {
      return false;
    }
    if (_overridden.contains(TaskInputMetadataKind.persistent)) {
      return _persistentOverride ?? false;
    }
    return parsed.isPersistent;
  }

  String effectiveListId(List<TaskList> lists) {
    if (_removed.contains(TaskInputMetadataKind.list)) {
      return AppDatabase.inboxListId;
    }
    if (_overridden.contains(TaskInputMetadataKind.list)) {
      return _listIdOverride ?? AppDatabase.inboxListId;
    }
    final parsedMatch = parsedListMatch(lists);
    return parsedMatch?.id ?? AppDatabase.inboxListId;
  }

  String? effectiveGroupId(List<TaskList> lists, List<ListGroup> groups) {
    if (_removed.contains(TaskInputMetadataKind.group)) {
      return null;
    }
    if (_overridden.contains(TaskInputMetadataKind.group)) {
      return _groupIdOverride;
    }
    return parsedGroupMatch(lists, groups)?.id;
  }

  TaskList? parsedListMatch(List<TaskList> lists) {
    final name = parsed.listName;
    if (name == null || _removed.contains(TaskInputMetadataKind.list)) {
      return null;
    }
    return taskInputFindListByName(lists, name);
  }

  ListGroup? parsedGroupMatch(List<TaskList> lists, List<ListGroup> groups) {
    final name = parsed.groupName;
    if (name == null || _removed.contains(TaskInputMetadataKind.group)) {
      return null;
    }
    if (parsed.listName != null &&
        !_removed.contains(TaskInputMetadataKind.list) &&
        parsedListMatch(lists) == null) {
      return null;
    }
    return taskInputFindGroupByName(groups, name);
  }

  String titleForSave(String rawInput) {
    final cleaned = parsed.title.trim();
    final raw = rawInput.trim();
    return cleaned.isEmpty ? raw : cleaned;
  }

  TaskDraft toDraft({
    required String rawInput,
    required String? description,
    required List<TaskList> lists,
    required List<ListGroup> groups,
  }) {
    final date = dueDate;
    final time = dueTime;
    final persistent = isPersistent;
    return TaskDraft(
      title: titleForSave(rawInput),
      description: description,
      priority: priority,
      listId: effectiveListId(lists),
      groupId: effectiveGroupId(lists, groups),
      dueDate: date,
      dueTime: time,
      startDate: parsed.startDate,
      startTime: parsed.startTime,
      timeZone: parsed.timeZone,
      isAllDay: time == null,
      isPersistent: persistent,
      showInTodayUntilComplete: persistent,
      reminders: reminders,
      repeatRule: repeatRule,
      originalInput: rawInput.trim(),
    );
  }

  List<String> warningMessages({
    required List<TaskList> lists,
    required List<ListGroup> groups,
    bool listsLoaded = true,
    bool groupsLoaded = true,
  }) {
    final messages = [for (final warning in parsed.warnings) warning.message];
    final listName = parsed.listName;
    final groupName = parsed.groupName;
    final listMissing =
        listName != null &&
        !_removed.contains(TaskInputMetadataKind.list) &&
        listsLoaded &&
        parsedListMatch(lists) == null;
    if (listMissing) {
      messages.add('List "$listName" does not exist. Saving will use Inbox.');
    }
    if (groupName != null && !_removed.contains(TaskInputMetadataKind.group)) {
      if (listMissing) {
        messages.add(
          'Group "$groupName" needs a matching list before it can be saved.',
        );
      } else if (groupsLoaded && parsedGroupMatch(lists, groups) == null) {
        final listLabel = taskInputListLabel(lists, effectiveListId(lists));
        messages.add(
          'Group "$groupName" does not exist in $listLabel. Saving without a group.',
        );
      }
    }
    return messages;
  }

  void setDate(DateTime? value) {
    _removed.remove(TaskInputMetadataKind.date);
    _overridden.add(TaskInputMetadataKind.date);
    _dueDateOverride = value == null ? null : dateOnly(value);
  }

  void setTime(String? value) {
    _removed.remove(TaskInputMetadataKind.time);
    _overridden.add(TaskInputMetadataKind.time);
    _dueTimeOverride = _nullableText(value);
  }

  void setRepeat(TaskRepeatDraft? value) {
    _removed.remove(TaskInputMetadataKind.repeat);
    _overridden.add(TaskInputMetadataKind.repeat);
    _repeatOverride = value;
  }

  void setReminders(List<TaskReminderDraft> value) {
    _removed.remove(TaskInputMetadataKind.reminder);
    _overridden.add(TaskInputMetadataKind.reminder);
    _remindersOverride = value;
  }

  void setPriority(TaskPriority value) {
    _removed.remove(TaskInputMetadataKind.priority);
    _overridden.add(TaskInputMetadataKind.priority);
    _priorityOverride = value;
  }

  void setListId(String value) {
    _removed.remove(TaskInputMetadataKind.list);
    _overridden.add(TaskInputMetadataKind.list);
    _listIdOverride = value;
    remove(TaskInputMetadataKind.group);
  }

  void setGroupId(String? value) {
    _removed.remove(TaskInputMetadataKind.group);
    _overridden.add(TaskInputMetadataKind.group);
    _groupIdOverride = value;
  }

  void setPersistent(bool value) {
    _removed.remove(TaskInputMetadataKind.persistent);
    _overridden.add(TaskInputMetadataKind.persistent);
    _persistentOverride = value;
  }

  void remove(TaskInputMetadataKind kind) {
    _removed.add(kind);
    _overridden.remove(kind);
    switch (kind) {
      case TaskInputMetadataKind.date:
        _dueDateOverride = null;
      case TaskInputMetadataKind.time:
        _dueTimeOverride = null;
      case TaskInputMetadataKind.repeat:
        _repeatOverride = null;
      case TaskInputMetadataKind.reminder:
        _remindersOverride = const [];
      case TaskInputMetadataKind.priority:
        _priorityOverride = null;
      case TaskInputMetadataKind.list:
        _listIdOverride = null;
        remove(TaskInputMetadataKind.group);
      case TaskInputMetadataKind.group:
        _groupIdOverride = null;
      case TaskInputMetadataKind.persistent:
        _persistentOverride = null;
    }
  }

  String? _nullableText(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}

class NaturalLanguageMetadataChip extends StatelessWidget {
  const NaturalLanguageMetadataChip({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    required this.deleteTooltip,
    this.onDeleted,
    this.warning = false,
    super.key,
  });

  final IconData icon;
  final String label;
  final bool active;
  final bool warning;
  final VoidCallback onTap;
  final VoidCallback? onDeleted;
  final String deleteTooltip;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = warning
        ? colors.danger
        : active
        ? colors.primary
        : colors.textMuted;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 36,
        padding: EdgeInsets.only(left: 11, right: onDeleted == null ? 11 : 5),
        decoration: BoxDecoration(
          color: active || warning
              ? colors.surfaceSelected
              : colors.surfaceRaised,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: foreground, size: 17),
            const SizedBox(width: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 138),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: foreground,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (onDeleted != null) ...[
              const SizedBox(width: 2),
              Tooltip(
                message: deleteTooltip,
                child: InkResponse(
                  onTap: onDeleted,
                  radius: 16,
                  child: SizedBox.square(
                    dimension: 28,
                    child: Icon(
                      Icons.close_rounded,
                      color: foreground,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class NaturalLanguageWarnings extends StatelessWidget {
  const NaturalLanguageWarnings({required this.messages, super.key});

  final List<String> messages;

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const SizedBox.shrink();
    }
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final message in messages)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: colors.danger,
                    size: 16,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: colors.textMuted,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

Map<TaskInputMetadataKind, Object?> taskInputMetadataSignatures(
  ParsedTaskInput parsed,
) {
  return {
    for (final kind in TaskInputMetadataKind.values)
      kind: taskInputMetadataSignature(parsed, kind),
  };
}

Object? taskInputMetadataSignature(
  ParsedTaskInput parsed,
  TaskInputMetadataKind kind,
) {
  return switch (kind) {
    TaskInputMetadataKind.date => parsed.dueDate,
    TaskInputMetadataKind.time => parsed.dueTime,
    TaskInputMetadataKind.repeat =>
      parsed.recurrence == null
          ? null
          : '${parsed.recurrence!.frequency.name}:'
                '${parsed.recurrence!.interval}:'
                '${parsed.recurrence!.weekdays.join(',')}',
    TaskInputMetadataKind.reminder =>
      parsed.reminder == null
          ? null
          : '${parsed.reminder!.kind.name}:'
                '${parsed.reminder!.remindAt?.toIso8601String()}:'
                '${parsed.reminder!.offsetMinutes}',
    TaskInputMetadataKind.priority =>
      parsed.priority == TaskPriority.none ? null : parsed.priority,
    TaskInputMetadataKind.list => parsed.listName?.toLowerCase(),
    TaskInputMetadataKind.group => parsed.groupName?.toLowerCase(),
    TaskInputMetadataKind.persistent => parsed.isPersistent ? true : null,
  };
}

List<TaskList> taskInputListsOrInbox(List<TaskList> lists) {
  if (lists.isNotEmpty) {
    return lists;
  }
  final now = DateTime.now();
  return [
    TaskList(
      id: AppDatabase.inboxListId,
      name: 'Inbox',
      color: '#4774FA',
      icon: null,
      sortOrder: 0,
      createdAt: now,
      updatedAt: now,
      isArchived: false,
      isSystemList: true,
    ),
  ];
}

TaskList? taskInputFindListByName(List<TaskList> lists, String name) {
  final normalized = name.trim().toLowerCase();
  for (final list in lists) {
    if (list.name.trim().toLowerCase() == normalized ||
        list.id.trim().toLowerCase() == normalized) {
      return list;
    }
  }
  return null;
}

ListGroup? taskInputFindGroupByName(List<ListGroup> groups, String name) {
  final normalized = name.trim().toLowerCase();
  for (final group in groups) {
    if (group.name.trim().toLowerCase() == normalized ||
        group.id.trim().toLowerCase() == normalized) {
      return group;
    }
  }
  return null;
}

String taskInputListLabel(List<TaskList> lists, String selectedId) {
  for (final list in lists) {
    if (list.id == selectedId) {
      return list.name;
    }
  }
  return selectedId == AppDatabase.inboxListId ? 'Inbox' : 'List';
}

String taskInputGroupLabel(List<ListGroup> groups, String? selectedId) {
  if (selectedId == null) {
    return 'No group';
  }
  for (final group in groups) {
    if (group.id == selectedId) {
      return group.name;
    }
  }
  return 'Group';
}

String taskInputDateLabel(DateTime? date) {
  return date == null ? 'No date' : compactDateLabel(date, DateTime.now());
}

String taskInputTimeLabel(String? value) {
  return value == null ? 'All day' : timeLabel(value);
}

String taskInputReminderLabel(List<TaskReminderDraft> reminders) {
  if (reminders.isEmpty) {
    return 'No reminder';
  }
  final reminder = reminders.first;
  if (reminder.offsetMinutes == -10) {
    return '10 min before';
  }
  if (reminder.offsetMinutes == -60) {
    return '1 hour before';
  }
  if (reminder.offsetMinutes == 0) {
    return 'At due time';
  }
  final hour = reminder.remindAt.hour.toString().padLeft(2, '0');
  final minute = reminder.remindAt.minute.toString().padLeft(2, '0');
  return '${compactDateLabel(reminder.remindAt, DateTime.now())} '
      '${timeLabel('$hour:$minute')}';
}

String taskInputRepeatLabel(TaskRepeatDraft? draft) {
  if (draft == null) {
    return 'No repeat';
  }
  if (draft.frequency == TaskRepeatFrequency.weekly &&
      draft.weekdays == '1,2,3,4,5') {
    return 'Weekdays';
  }
  return draft.frequency.label;
}

List<TaskReminderDraft> taskInputRemindersForChoice(
  TaskInputReminderChoice choice, {
  required DateTime? dueDate,
  required String? dueTime,
}) {
  if (choice == TaskInputReminderChoice.none) {
    return const [];
  }

  final date = dueDate ?? dateOnly(DateTime.now());
  final dueAt = taskInputCombineDateAndTime(date, dueTime ?? '09:00');
  return switch (choice) {
    TaskInputReminderChoice.none => const [],
    TaskInputReminderChoice.morning => [
      TaskReminderDraft(
        reminderType: 'due_date_morning',
        remindAt: taskInputCombineDateAndTime(date, '09:00'),
      ),
    ],
    TaskInputReminderChoice.atDueTime => [
      TaskReminderDraft(
        reminderType: 'relative',
        remindAt: dueAt,
        offsetMinutes: 0,
      ),
    ],
    TaskInputReminderChoice.tenMinutesBefore => [
      TaskReminderDraft(
        reminderType: 'relative',
        remindAt: dueAt.subtract(const Duration(minutes: 10)),
        offsetMinutes: -10,
      ),
    ],
    TaskInputReminderChoice.oneHourBefore => [
      TaskReminderDraft(
        reminderType: 'relative',
        remindAt: dueAt.subtract(const Duration(hours: 1)),
        offsetMinutes: -60,
      ),
    ],
  };
}

TaskRepeatDraft? taskInputRepeatForChoice(
  TaskInputRepeatChoice choice, {
  required DateTime? dueDate,
}) {
  return switch (choice) {
    TaskInputRepeatChoice.none => null,
    TaskInputRepeatChoice.daily => const TaskRepeatDraft(
      frequency: TaskRepeatFrequency.daily,
    ),
    TaskInputRepeatChoice.weekdays => const TaskRepeatDraft(
      frequency: TaskRepeatFrequency.weekly,
      weekdays: '1,2,3,4,5',
    ),
    TaskInputRepeatChoice.weekly => const TaskRepeatDraft(
      frequency: TaskRepeatFrequency.weekly,
    ),
    TaskInputRepeatChoice.monthly => TaskRepeatDraft(
      frequency: TaskRepeatFrequency.monthly,
      monthDay: (dueDate ?? DateTime.now()).day,
    ),
  };
}

DateTime taskInputCombineDateAndTime(DateTime date, String time) {
  final parts = time.split(':');
  return DateTime(
    date.year,
    date.month,
    date.day,
    int.parse(parts[0]),
    int.parse(parts[1]),
  );
}

Future<TaskInputDateChoice?> showTaskInputDateChoiceSheet(
  BuildContext context,
) {
  return showFlowBottomSheet<TaskInputDateChoice>(
    context: context,
    builder: (context) => const _DateChoiceSheet(),
  );
}

Future<String?> showTaskInputTimeChoiceSheet(BuildContext context) {
  return showFlowBottomSheet<String>(
    context: context,
    builder: (context) => const _TimeChoiceSheet(),
  );
}

Future<TaskInputReminderChoice?> showTaskInputReminderChoiceSheet(
  BuildContext context,
) {
  return showFlowBottomSheet<TaskInputReminderChoice>(
    context: context,
    builder: (context) => const _ReminderChoiceSheet(),
  );
}

Future<TaskInputRepeatChoice?> showTaskInputRepeatChoiceSheet(
  BuildContext context,
) {
  return showFlowBottomSheet<TaskInputRepeatChoice>(
    context: context,
    builder: (context) => const _RepeatChoiceSheet(),
  );
}

Future<String?> showTaskInputListChoiceSheet(
  BuildContext context, {
  required List<TaskList> lists,
  required String selectedId,
}) {
  return showFlowBottomSheet<String>(
    context: context,
    builder: (context) =>
        _ListChoiceSheet(lists: lists, selectedId: selectedId),
  );
}

Future<String?> showTaskInputGroupChoiceSheet(
  BuildContext context, {
  required List<ListGroup> groups,
  required String? selectedId,
}) {
  return showFlowBottomSheet<String>(
    context: context,
    builder: (context) =>
        _GroupChoiceSheet(groups: groups, selectedId: selectedId),
  );
}

class _DateChoiceSheet extends StatelessWidget {
  const _DateChoiceSheet();

  @override
  Widget build(BuildContext context) {
    return _ChoiceSheet(
      title: 'Due date',
      children: [
        _ChoiceRow(
          icon: Icons.event_busy_outlined,
          label: 'No date',
          onTap: () => Navigator.of(context).pop(TaskInputDateChoice.none),
        ),
        _ChoiceRow(
          icon: Icons.today_outlined,
          label: 'Today',
          onTap: () => Navigator.of(context).pop(TaskInputDateChoice.today),
        ),
        _ChoiceRow(
          icon: Icons.event_outlined,
          label: 'Tomorrow',
          onTap: () => Navigator.of(context).pop(TaskInputDateChoice.tomorrow),
        ),
        _ChoiceRow(
          icon: Icons.calendar_month_outlined,
          label: 'Pick date',
          onTap: () => Navigator.of(context).pop(TaskInputDateChoice.pick),
        ),
      ],
    );
  }
}

class _TimeChoiceSheet extends StatelessWidget {
  const _TimeChoiceSheet();

  @override
  Widget build(BuildContext context) {
    return _ChoiceSheet(
      title: 'Due time',
      children: [
        _ChoiceRow(
          icon: Icons.access_time_filled_rounded,
          label: 'All day',
          onTap: () => Navigator.of(context).pop(''),
        ),
        for (final entry in const [
          ('09:00', '9:00 a.m.'),
          ('12:00', '12:00 p.m.'),
          ('17:00', '5:00 p.m.'),
          ('20:00', '8:00 p.m.'),
        ])
          _ChoiceRow(
            icon: Icons.access_time_rounded,
            label: entry.$2,
            onTap: () => Navigator.of(context).pop(entry.$1),
          ),
      ],
    );
  }
}

class _ListChoiceSheet extends StatelessWidget {
  const _ListChoiceSheet({required this.lists, required this.selectedId});

  final List<TaskList> lists;
  final String selectedId;

  @override
  Widget build(BuildContext context) {
    return _ChoiceSheet(
      title: 'List',
      children: [
        for (final list in lists)
          _ChoiceRow(
            icon: Icons.inbox_outlined,
            label: list.name,
            selected: list.id == selectedId,
            onTap: () => Navigator.of(context).pop(list.id),
          ),
      ],
    );
  }
}

class _GroupChoiceSheet extends StatelessWidget {
  const _GroupChoiceSheet({required this.groups, required this.selectedId});

  final List<ListGroup> groups;
  final String? selectedId;

  @override
  Widget build(BuildContext context) {
    return _ChoiceSheet(
      title: 'Group',
      children: [
        _ChoiceRow(
          icon: Icons.layers_clear_rounded,
          label: 'No group',
          selected: selectedId == null,
          onTap: () => Navigator.of(context).pop(''),
        ),
        for (final group in groups)
          _ChoiceRow(
            icon: Icons.account_tree_outlined,
            label: group.name,
            selected: group.id == selectedId,
            onTap: () => Navigator.of(context).pop(group.id),
          ),
      ],
    );
  }
}

class _ReminderChoiceSheet extends StatelessWidget {
  const _ReminderChoiceSheet();

  @override
  Widget build(BuildContext context) {
    return _ChoiceSheet(
      title: 'Reminder',
      children: [
        _ChoiceRow(
          icon: Icons.notifications_off_outlined,
          label: 'No reminder',
          onTap: () => Navigator.of(context).pop(TaskInputReminderChoice.none),
        ),
        _ChoiceRow(
          icon: Icons.wb_sunny_outlined,
          label: 'Due date morning',
          onTap: () =>
              Navigator.of(context).pop(TaskInputReminderChoice.morning),
        ),
        _ChoiceRow(
          icon: Icons.notifications_none_rounded,
          label: 'At due time',
          onTap: () =>
              Navigator.of(context).pop(TaskInputReminderChoice.atDueTime),
        ),
        _ChoiceRow(
          icon: Icons.timer_outlined,
          label: '10 min before',
          onTap: () => Navigator.of(
            context,
          ).pop(TaskInputReminderChoice.tenMinutesBefore),
        ),
        _ChoiceRow(
          icon: Icons.timer_outlined,
          label: '1 hour before',
          onTap: () =>
              Navigator.of(context).pop(TaskInputReminderChoice.oneHourBefore),
        ),
      ],
    );
  }
}

class _RepeatChoiceSheet extends StatelessWidget {
  const _RepeatChoiceSheet();

  @override
  Widget build(BuildContext context) {
    return _ChoiceSheet(
      title: 'Repeat',
      children: [
        _ChoiceRow(
          icon: Icons.repeat_on_rounded,
          label: 'No repeat',
          onTap: () => Navigator.of(context).pop(TaskInputRepeatChoice.none),
        ),
        _ChoiceRow(
          icon: Icons.repeat_rounded,
          label: 'Daily',
          onTap: () => Navigator.of(context).pop(TaskInputRepeatChoice.daily),
        ),
        _ChoiceRow(
          icon: Icons.work_history_outlined,
          label: 'Weekdays',
          onTap: () =>
              Navigator.of(context).pop(TaskInputRepeatChoice.weekdays),
        ),
        _ChoiceRow(
          icon: Icons.calendar_view_week_outlined,
          label: 'Weekly',
          onTap: () => Navigator.of(context).pop(TaskInputRepeatChoice.weekly),
        ),
        _ChoiceRow(
          icon: Icons.calendar_month_outlined,
          label: 'Monthly',
          onTap: () => Navigator.of(context).pop(TaskInputRepeatChoice.monthly),
        ),
      ],
    );
  }
}

class _ChoiceSheet extends StatelessWidget {
  const _ChoiceSheet({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return FlowBottomSheetSurface(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colors.textStrong,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _ChoiceRow extends StatelessWidget {
  const _ChoiceRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = selected ? colors.primary : colors.text;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            Icon(icon, color: foreground, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: foreground,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check_rounded, color: colors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
