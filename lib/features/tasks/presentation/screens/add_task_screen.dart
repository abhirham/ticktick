import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers.dart';
import '../../../../app/theme.dart';
import '../../../../core/time/flow_date_utils.dart';
import '../../../../data/local/app_database.dart';
import '../../../../shared/presentation/flow_action_button.dart';
import '../../../../shared/presentation/flow_date_picker.dart';
import '../../application/task_providers.dart';
import '../../domain/task_enums.dart';
import '../widgets/natural_language_task_input.dart';
import '../widgets/priority_sheet.dart';
import '../widgets/task_widgets.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final NaturalLanguageTaskFormState _form = NaturalLanguageTaskFormState();

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_handleTitleChanged);
  }

  @override
  void dispose() {
    _titleController.removeListener(_handleTitleChanged);
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleTitleChanged() {
    setState(() {
      _form.parse(_titleController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final listsAsync = ref.watch(taskListsProvider);
    final lists = taskInputListsOrInbox(listsAsync.valueOrNull ?? const []);
    final listId = _form.effectiveListId(lists);
    final groupsAsync = ref.watch(taskGroupsForListProvider(listId));
    final groups = groupsAsync.valueOrNull ?? const <ListGroup>[];
    final warnings = _form.warningMessages(
      lists: lists,
      groups: groups,
      listsLoaded: listsAsync.hasValue,
      groupsLoaded: groupsAsync.hasValue,
    );
    return ColoredBox(
      color: colors.bg,
      child: Column(
        children: [
          FlowTaskPageHeader(
            title: 'Add Task',
            leading: FlowIconButton(
              icon: Icons.close_rounded,
              tooltip: 'Close',
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
                      TextField(
                        controller: _titleController,
                        autofocus: true,
                        cursorColor: colors.primary,
                        style: TextStyle(
                          color: colors.textStrong,
                          fontSize: 23,
                          height: 1.25,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'What would you like to do?',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          isCollapsed: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _descriptionController,
                        cursorColor: colors.primary,
                        minLines: 1,
                        maxLines: 3,
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
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _metadataChips(
                          lists: lists,
                          groups: groups,
                          listsLoaded: listsAsync.hasValue,
                          groupsLoaded: groupsAsync.hasValue,
                        ),
                      ),
                      NaturalLanguageWarnings(messages: warnings),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                FlowActionButton(
                  primary: true,
                  icon: Icons.check_rounded,
                  label: 'Save Task',
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _metadataChips({
    required List<TaskList> lists,
    required List<ListGroup> groups,
    required bool listsLoaded,
    required bool groupsLoaded,
  }) {
    final listId = _form.effectiveListId(lists);
    final groupId = _form.effectiveGroupId(lists, groups);
    final listWarning = _form.isWarning(
      TaskInputMetadataKind.list,
      lists: lists,
      groups: groups,
      listsLoaded: listsLoaded,
      groupsLoaded: groupsLoaded,
    );
    final groupWarning = _form.isWarning(
      TaskInputMetadataKind.group,
      lists: lists,
      groups: groups,
      listsLoaded: listsLoaded,
      groupsLoaded: groupsLoaded,
    );
    return [
      _metadataChip(
        kind: TaskInputMetadataKind.date,
        icon: Icons.calendar_today_rounded,
        label: taskInputDateLabel(_form.dueDate),
        active: _form.dueDate != null,
        onTap: _showDateMenu,
      ),
      _metadataChip(
        kind: TaskInputMetadataKind.time,
        icon: Icons.access_time_rounded,
        label: taskInputTimeLabel(_form.dueTime),
        active: _form.dueTime != null,
        onTap: _showTimeMenu,
      ),
      _metadataChip(
        kind: TaskInputMetadataKind.repeat,
        icon: Icons.repeat_rounded,
        label: taskInputRepeatLabel(_form.repeatRule),
        active: _form.repeatRule != null,
        onTap: _showRepeatMenu,
      ),
      _metadataChip(
        kind: TaskInputMetadataKind.reminder,
        icon: Icons.notifications_none_rounded,
        label: taskInputReminderLabel(_form.reminders),
        active: _form.reminders.isNotEmpty,
        onTap: _showReminderMenu,
      ),
      _metadataChip(
        kind: TaskInputMetadataKind.priority,
        icon: Icons.flag_outlined,
        label: _form.priority.label,
        active: _form.priority != TaskPriority.none,
        onTap: _showPriorityMenu,
      ),
      _metadataChip(
        kind: TaskInputMetadataKind.list,
        icon: Icons.inbox_outlined,
        label: listWarning
            ? _form.parsed.listName!
            : taskInputListLabel(lists, listId),
        active: listWarning || listId != AppDatabase.inboxListId,
        warning: listWarning,
        onTap: () => _pickList(lists),
      ),
      _metadataChip(
        kind: TaskInputMetadataKind.group,
        icon: Icons.account_tree_outlined,
        label: groupWarning
            ? _form.parsed.groupName!
            : taskInputGroupLabel(groups, groupId),
        active: groupWarning || groupId != null,
        warning: groupWarning,
        onTap: () => _pickGroup(groups),
      ),
      _metadataChip(
        kind: TaskInputMetadataKind.persistent,
        icon: Icons.push_pin_outlined,
        label: _form.isPersistent ? 'Keep in Today' : 'Normal',
        active: _form.isPersistent,
        onTap: () {
          setState(() => _form.setPersistent(!_form.isPersistent));
        },
      ),
    ];
  }

  Widget _metadataChip({
    required TaskInputMetadataKind kind,
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
    bool warning = false,
  }) {
    return NaturalLanguageMetadataChip(
      icon: icon,
      label: label,
      active: active,
      warning: warning,
      onTap: onTap,
      deleteTooltip: 'Remove ${kind.name}',
      onDeleted: active || warning ? () => _removeMetadata(kind) : null,
    );
  }

  void _removeMetadata(TaskInputMetadataKind kind) {
    setState(() => _form.remove(kind));
  }

  Future<void> _showDateMenu() async {
    final choice = await showTaskInputDateChoiceSheet(context);
    if (choice == null) {
      return;
    }

    final now = DateTime.now();
    if (choice == TaskInputDateChoice.none) {
      setState(() => _form.remove(TaskInputMetadataKind.date));
      return;
    }
    if (choice == TaskInputDateChoice.today) {
      setState(() => _form.setDate(dateOnly(now)));
      return;
    }
    if (choice == TaskInputDateChoice.tomorrow) {
      setState(() => _form.setDate(tomorrowOf(now)));
      return;
    }
    await _pickDate();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showFlowDatePicker(
      context: context,
      initialDate: _form.dueDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() => _form.setDate(dateOnly(picked)));
    }
  }

  Future<void> _showTimeMenu() async {
    final selected = await showTaskInputTimeChoiceSheet(context);
    if (!mounted || selected == null) {
      return;
    }
    setState(() {
      if (selected.isEmpty) {
        _form.remove(TaskInputMetadataKind.time);
      } else {
        _form.setTime(selected);
        if (_form.dueDate == null) {
          _form.setDate(dateOnly(DateTime.now()));
        }
      }
    });
  }

  Future<void> _showPriorityMenu() async {
    final selected = await showTaskPrioritySheet(
      context,
      selectedPriority: _form.priority,
    );
    if (selected != null) {
      setState(() => _form.setPriority(selected));
    }
  }

  Future<void> _pickList(List<TaskList> lists) async {
    final selected = await showTaskInputListChoiceSheet(
      context,
      lists: taskInputListsOrInbox(lists),
      selectedId: _form.effectiveListId(lists),
    );
    if (selected == null || selected == _form.effectiveListId(lists)) {
      return;
    }
    setState(() => _form.setListId(selected));
  }

  Future<void> _pickGroup(List<ListGroup> groups) async {
    final selected = await showTaskInputGroupChoiceSheet(
      context,
      groups: groups,
      selectedId: _form.effectiveGroupId(
        taskInputListsOrInbox(
          ref.read(taskListsProvider).valueOrNull ?? const [],
        ),
        groups,
      ),
    );
    if (!mounted || selected == null) {
      return;
    }
    setState(() => _form.setGroupId(selected.isEmpty ? null : selected));
  }

  Future<void> _showReminderMenu() async {
    final choice = await showTaskInputReminderChoiceSheet(context);
    if (choice == null) {
      return;
    }
    setState(() {
      _form.setReminders(
        taskInputRemindersForChoice(
          choice,
          dueDate: _form.dueDate,
          dueTime: _form.dueTime,
        ),
      );
    });
  }

  Future<void> _showRepeatMenu() async {
    final choice = await showTaskInputRepeatChoiceSheet(context);
    if (choice == null) {
      return;
    }
    setState(() {
      _form.setRepeat(taskInputRepeatForChoice(choice, dueDate: _form.dueDate));
    });
  }

  Future<void> _save() async {
    final title = _form.titleForSave(_titleController.text);
    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task title is required.')));
      return;
    }

    final lists = taskInputListsOrInbox(
      ref.read(taskListsProvider).valueOrNull ?? const [],
    );
    final listId = _form.effectiveListId(lists);
    final groups =
        ref.read(taskGroupsForListProvider(listId)).valueOrNull ??
        const <ListGroup>[];
    await ref
        .read(taskRepositoryProvider)
        .createTask(
          _form.toDraft(
            rawInput: _titleController.text,
            description: _descriptionController.text,
            lists: lists,
            groups: groups,
          ),
        );
    if (mounted) {
      context.go('/today');
    }
  }
}
