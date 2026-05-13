import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers.dart';
import '../../../../app/theme.dart';
import '../../../../core/time/flow_date_utils.dart';
import '../../../../data/local/app_database.dart';
import '../../../../shared/presentation/flow_action_button.dart';
import '../../../../shared/presentation/flow_bottom_sheet.dart';
import '../../../../shared/presentation/flow_date_picker.dart';
import '../../application/task_providers.dart';
import '../../domain/task_draft.dart';
import '../../domain/task_enums.dart';
import '../widgets/natural_language_task_input.dart';
import '../widgets/priority_sheet.dart';
import '../widgets/task_widgets.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  const TaskDetailScreen({required this.taskId, super.key});

  final String taskId;

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _seededTaskId;
  String _listId = AppDatabase.inboxListId;
  String? _groupId;
  DateTime? _dueDate;
  String? _dueTime;
  bool _isAllDay = true;
  bool _keepInToday = false;
  TaskPriority _priority = TaskPriority.none;
  bool _remindersChanged = false;
  List<TaskReminderDraft> _reminders = const [];
  bool _repeatChanged = false;
  TaskRepeatDraft? _repeatRule;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskAsync = ref.watch(taskByIdProvider(widget.taskId));
    final colors = context.colors;

    return ColoredBox(
      color: colors.bg,
      child: taskAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
        data: (task) {
          if (task == null) {
            return _MissingTask(onBack: () => context.go('/lists'));
          }
          if (_seededTaskId != task.id) {
            _seededTaskId = task.id;
            _titleController.text = task.title;
            _descriptionController.text = task.description ?? '';
            _listId = task.listId;
            _groupId = task.groupId;
            _dueDate = task.dueDate;
            _dueTime = task.dueTime;
            _isAllDay = task.isAllDay;
            _keepInToday = task.showInTodayUntilComplete;
            _priority = TaskPriority.fromValue(task.priority);
            _remindersChanged = false;
            _reminders = const [];
            _repeatChanged = false;
            _repeatRule = null;
          }

          final status = TaskStatus.fromValue(task.status);
          final lists = ref.watch(taskListsProvider).valueOrNull ?? const [];
          final groups =
              ref.watch(taskGroupsForListProvider(_listId)).valueOrNull ??
              const <ListGroup>[];
          final reminderEntries =
              ref.watch(taskRemindersProvider(task.id)).valueOrNull ??
              const <ReminderEntry>[];
          final repeatEntry = task.recurrenceRuleId == null
              ? null
              : ref
                    .watch(taskRepeatRuleProvider(task.recurrenceRuleId!))
                    .valueOrNull;
          final listName = _listName(lists, _listId);
          final groupName = _groupName(groups, _groupId);
          final reminderLabel = _remindersChanged
              ? taskInputReminderLabel(_reminders)
              : taskInputReminderEntryLabel(reminderEntries);
          final repeatLabel = taskInputRepeatLabel(
            _repeatChanged
                ? _repeatRule
                : taskInputRepeatDraftFromEntry(
                    repeatEntry,
                    task.recurrenceRuleId,
                  ),
          );
          return Column(
            children: [
              FlowTaskPageHeader(
                title: 'Task Detail',
                leading: FlowIconButton(
                  icon: Icons.arrow_back_rounded,
                  tooltip: 'Back',
                  onPressed: () => context.go('/today'),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 112),
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              TaskCheckBox(
                                checked: status == TaskStatus.completed,
                                onTap: () => _toggleStatus(status),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: InkWell(
                                  onTap: () => _pickList(lists),
                                  borderRadius: BorderRadius.circular(999),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          listName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: colors.textMuted,
                                            fontSize: 16.5,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.unfold_more_rounded,
                                        color: colors.iconMuted,
                                        size: 18,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              _InlineDateAction(
                                label: _dueDate == null
                                    ? 'No date'
                                    : compactDateLabel(
                                        _dueDate!,
                                        DateTime.now(),
                                      ),
                                onTap: _showDateMenu,
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          TextField(
                            controller: _titleController,
                            cursorColor: colors.primary,
                            style: TextStyle(
                              color: colors.textStrong,
                              fontSize: 27,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Title',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              isCollapsed: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _descriptionController,
                            cursorColor: colors.primary,
                            minLines: 2,
                            maxLines: 5,
                            style: TextStyle(color: colors.text, fontSize: 17),
                            decoration: const InputDecoration(
                              hintText: 'Description',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              isCollapsed: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _DetailActionChip(
                                icon: Icons.flag_outlined,
                                label: _priority.label,
                                active: _priority != TaskPriority.none,
                                onPressed: _showPriorityMenu,
                              ),
                              _DetailActionChip(
                                icon: Icons.access_time_rounded,
                                label: _isAllDay
                                    ? 'All day'
                                    : _dueTime ?? 'Time',
                                active: !_isAllDay,
                                onPressed: _showTimeMenu,
                              ),
                              _DetailActionChip(
                                icon: Icons.inbox_outlined,
                                label: listName,
                                active: _listId != AppDatabase.inboxListId,
                                onPressed: () => _pickList(lists),
                              ),
                              _DetailActionChip(
                                icon: Icons.account_tree_outlined,
                                label: groupName,
                                active: _groupId != null,
                                onPressed: () => _pickGroup(groups),
                              ),
                              _DetailActionChip(
                                icon: Icons.notifications_none_rounded,
                                label: reminderLabel,
                                active: reminderLabel != 'No reminder',
                                onPressed: _showReminderMenu,
                              ),
                              _DetailActionChip(
                                icon: Icons.repeat_rounded,
                                label: repeatLabel,
                                active: repeatLabel != 'No repeat',
                                onPressed: _showRepeatMenu,
                              ),
                              _DetailActionChip(
                                icon: Icons.push_pin_outlined,
                                label: _keepInToday
                                    ? 'Keep in Today'
                                    : 'Normal',
                                active: _keepInToday,
                                onPressed: () {
                                  setState(() {
                                    _keepInToday = !_keepInToday;
                                  });
                                },
                              ),
                              if (_keepInToday) const _PersistentHelperText(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    FlowActionButton(
                      primary: true,
                      icon: Icons.save_outlined,
                      label: 'Save Changes',
                      onPressed: _save,
                    ),
                    const SizedBox(height: 10),
                    if (status == TaskStatus.deleted) ...[
                      FlowActionButton(
                        icon: Icons.restore_rounded,
                        label: 'Restore Task',
                        onPressed: () async {
                          await ref
                              .read(taskRepositoryProvider)
                              .restoreTask(task.id);
                          if (context.mounted) {
                            context.go('/trash');
                            _showUndoSnackBar(
                              'Task restored.',
                              () => ref
                                  .read(taskRepositoryProvider)
                                  .moveTaskToTrash(task.id),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      FlowActionButton(
                        icon: Icons.delete_forever,
                        label: 'Delete Forever',
                        destructive: true,
                        onPressed: () => _confirmPermanentDelete(task.id),
                      ),
                    ] else ...[
                      FlowActionButton(
                        icon: status == TaskStatus.completed
                            ? Icons.replay_rounded
                            : Icons.check_rounded,
                        label: status == TaskStatus.completed
                            ? 'Reopen Task'
                            : 'Mark Complete',
                        onPressed: () => _toggleStatus(status),
                      ),
                      const SizedBox(height: 10),
                      FlowActionButton(
                        icon: Icons.delete_outline,
                        label: 'Move to Trash',
                        destructive: true,
                        onPressed: () async {
                          await ref
                              .read(taskRepositoryProvider)
                              .moveTaskToTrash(task.id);
                          if (context.mounted) {
                            context.go('/trash');
                            _showUndoSnackBar(
                              'Task moved to Trash.',
                              () => ref
                                  .read(taskRepositoryProvider)
                                  .restoreTask(task.id),
                            );
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _showDateMenu() async {
    final choice = await showFlowBottomSheet<_DateChoice>(
      context: context,
      builder: (context) => const _DateChoiceSheet(),
    );
    if (choice == null) {
      return;
    }

    final now = DateTime.now();
    if (choice == _DateChoice.none) {
      setState(() {
        _dueDate = null;
        _dueTime = null;
        _isAllDay = true;
      });
      return;
    }
    if (choice == _DateChoice.today) {
      setState(() => _dueDate = dateOnly(now));
      return;
    }
    if (choice == _DateChoice.tomorrow) {
      setState(() => _dueDate = tomorrowOf(now));
      return;
    }
    await _pickDate();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showFlowDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() => _dueDate = dateOnly(picked));
    }
  }

  Future<void> _showPriorityMenu() async {
    final selected = await showTaskPrioritySheet(
      context,
      selectedPriority: _priority,
    );
    if (selected != null) {
      setState(() => _priority = selected);
    }
  }

  Future<void> _showTimeMenu() async {
    final selected = await showFlowBottomSheet<String>(
      context: context,
      builder: (context) => const _TimeChoiceSheet(),
    );
    if (!mounted || selected == null) {
      return;
    }
    setState(() {
      if (selected.isEmpty) {
        _isAllDay = true;
        _dueTime = null;
      } else {
        _isAllDay = false;
        _dueTime = selected;
        _dueDate ??= dateOnly(DateTime.now());
      }
    });
  }

  Future<void> _pickList(List<TaskList> lists) async {
    final selected = await showFlowBottomSheet<String>(
      context: context,
      builder: (context) => _ListChoiceSheet(
        lists: lists.isEmpty
            ? [
                TaskList(
                  id: AppDatabase.inboxListId,
                  name: 'Inbox',
                  color: '#4774FA',
                  sortOrder: 0,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  isArchived: false,
                  isSystemList: true,
                ),
              ]
            : lists,
        selectedId: _listId,
      ),
    );
    if (selected == null || selected == _listId) {
      return;
    }
    setState(() {
      _listId = selected;
      _groupId = null;
    });
  }

  Future<void> _pickGroup(List<ListGroup> groups) async {
    final selected = await showFlowBottomSheet<String>(
      context: context,
      builder: (context) =>
          _GroupChoiceSheet(groups: groups, selectedId: _groupId),
    );
    if (!mounted || selected == null) {
      return;
    }
    setState(() => _groupId = selected.isEmpty ? null : selected);
  }

  Future<void> _showReminderMenu() async {
    final existing =
        ref
            .read(taskRemindersProvider(widget.taskId))
            .valueOrNull
            ?.map(
              (reminder) => TaskReminderDraft(
                remindAt: reminder.remindAt,
                reminderType: reminder.reminderType,
                offsetMinutes: reminder.offsetMinutes,
                isEnabled: reminder.isEnabled,
              ),
            )
            .toList(growable: false) ??
        const <TaskReminderDraft>[];
    final reminders = await showTaskReminderEditorSheet(
      context,
      initialReminders: _remindersChanged ? _reminders : existing,
      dueDate: _dueDate,
      dueTime: _dueTime,
    );
    if (reminders == null) {
      return;
    }
    setState(() {
      _remindersChanged = true;
      _reminders = reminders;
    });
  }

  Future<void> _showRepeatMenu() async {
    final task = ref.read(taskByIdProvider(widget.taskId)).valueOrNull;
    final entry = task?.recurrenceRuleId == null
        ? null
        : ref.read(taskRepeatRuleProvider(task!.recurrenceRuleId!)).valueOrNull;
    final result = await showTaskRepeatEditorSheet(
      context,
      initialRule: _repeatChanged
          ? _repeatRule
          : taskInputRepeatDraftFromEntry(entry, task?.recurrenceRuleId),
      dueDate: _dueDate,
    );
    if (result == null) {
      return;
    }
    setState(() {
      _repeatChanged = true;
      _repeatRule = result.repeatRule;
    });
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task title is required.')));
      return;
    }
    await ref
        .read(taskRepositoryProvider)
        .updateTask(
          id: widget.taskId,
          title: title,
          description: _descriptionController.text,
          priority: _priority,
          listId: _listId,
          updateGroup: true,
          groupId: _groupId,
          dueDate: _dueDate,
          dueTime: _dueTime,
          isAllDay: _isAllDay,
          isPersistent: _keepInToday,
          showInTodayUntilComplete: _keepInToday,
          updateReminders: _remindersChanged,
          reminders: _reminders,
          updateRepeatRule: _repeatChanged,
          repeatRule: _repeatRule,
        );
    if (mounted) {
      setState(() {
        _remindersChanged = false;
        _repeatChanged = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task saved.')));
    }
  }

  Future<void> _toggleStatus(TaskStatus status) async {
    final repository = ref.read(taskRepositoryProvider);
    if (status == TaskStatus.completed) {
      await repository.reopenTask(widget.taskId);
      if (mounted) {
        _showUndoSnackBar(
          'Task reopened.',
          () => repository.completeTask(widget.taskId),
        );
      }
    } else {
      await repository.completeTask(widget.taskId);
      if (mounted) {
        _showUndoSnackBar(
          'Task completed.',
          () => repository.reopenTask(widget.taskId),
        );
      }
    }
  }

  Future<void> _confirmPermanentDelete(String taskId) async {
    final confirmed = await showFlowBottomSheet<bool>(
      context: context,
      builder: (context) => const _DeleteForeverSheet(),
    );
    if (confirmed == true) {
      await ref.read(taskRepositoryProvider).permanentlyDeleteTask(taskId);
      if (mounted) {
        context.go('/trash');
      }
    }
  }

  void _showUndoSnackBar(String message, Future<void> Function() undo) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            undo();
          },
        ),
      ),
    );
  }
}

enum _DateChoice { none, today, tomorrow, pick }

String _listName(List<TaskList> lists, String selectedId) {
  for (final list in lists) {
    if (list.id == selectedId) {
      return list.name;
    }
  }
  return selectedId == AppDatabase.inboxListId ? 'Inbox' : 'List';
}

String _groupName(List<ListGroup> groups, String? selectedId) {
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

class _DateChoiceSheet extends StatelessWidget {
  const _DateChoiceSheet();

  @override
  Widget build(BuildContext context) {
    return _ChoiceSheet(
      title: 'Due date',
      children: [
        _ChoiceRow(
          icon: Icons.event_busy_rounded,
          label: 'No date',
          onTap: () => Navigator.of(context).pop(_DateChoice.none),
        ),
        _ChoiceRow(
          icon: Icons.today_rounded,
          label: 'Today',
          onTap: () => Navigator.of(context).pop(_DateChoice.today),
        ),
        _ChoiceRow(
          icon: Icons.event_rounded,
          label: 'Tomorrow',
          onTap: () => Navigator.of(context).pop(_DateChoice.tomorrow),
        ),
        _ChoiceRow(
          icon: Icons.calendar_month_outlined,
          label: 'Pick date',
          onTap: () => Navigator.of(context).pop(_DateChoice.pick),
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

class _DetailActionChip extends StatelessWidget {
  const _DetailActionChip({
    required this.icon,
    required this.label,
    required this.active,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = active ? colors.primary : colors.textMuted;
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 11),
        decoration: BoxDecoration(
          color: active ? colors.surfaceSelected : colors.surfaceRaised,
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
          ],
        ),
      ),
    );
  }
}

class _InlineDateAction extends StatelessWidget {
  const _InlineDateAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 35,
        constraints: const BoxConstraints(maxWidth: 122),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: colors.surfaceRaised,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: colors.primary,
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _DeleteForeverSheet extends StatelessWidget {
  const _DeleteForeverSheet();

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
            'Delete forever?',
            style: TextStyle(
              color: colors.textStrong,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'This permanently removes the task from FlowTask.',
            style: TextStyle(
              color: colors.textMuted,
              fontSize: 14.5,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: FlowActionButton(
                  icon: Icons.close_rounded,
                  label: 'Cancel',
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FlowActionButton(
                  icon: Icons.delete_forever,
                  label: 'Delete',
                  destructive: true,
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PersistentHelperText extends StatelessWidget {
  const _PersistentHelperText();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Text(
      'This task will stay in Today until completed.',
      style: TextStyle(color: colors.textMuted, fontSize: 13.5),
    );
  }
}

class _MissingTask extends StatelessWidget {
  const _MissingTask({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Task not found',
            style: TextStyle(color: colors.text, fontSize: 20),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 220,
            child: FlowActionButton(
              icon: Icons.arrow_back_rounded,
              label: 'Back to Lists',
              onPressed: onBack,
            ),
          ),
        ],
      ),
    );
  }
}
