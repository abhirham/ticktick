import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers.dart';
import '../../../../app/theme.dart';
import '../../../../core/time/flow_date_utils.dart';
import '../../../../shared/presentation/flow_action_button.dart';
import '../../../../shared/presentation/flow_bottom_sheet.dart';
import '../../../../shared/presentation/flow_date_picker.dart';
import '../../application/task_providers.dart';
import '../../domain/task_enums.dart';
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
  DateTime? _dueDate;
  String? _dueTime;
  bool _isAllDay = true;
  TaskPriority _priority = TaskPriority.none;

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
            _dueDate = task.dueDate;
            _dueTime = task.dueTime;
            _isAllDay = task.isAllDay;
            _priority = TaskPriority.fromValue(task.priority);
          }

          final status = TaskStatus.fromValue(task.status);
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
                                child: Text(
                                  'Inbox',
                                  style: TextStyle(
                                    color: colors.textMuted,
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.w700,
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
                                onTap: _pickDate,
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
                                onPressed: _toggleTime,
                              ),
                              if (task.isPersistent)
                                const _PersistentHelperText(),
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
                          if (context.mounted) context.go('/trash');
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
                          if (context.mounted) context.go('/trash');
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

  void _toggleTime() {
    setState(() {
      if (_isAllDay) {
        _isAllDay = false;
        _dueTime = '09:00';
      } else {
        _isAllDay = true;
        _dueTime = null;
      }
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
          dueDate: _dueDate,
          dueTime: _dueTime,
          isAllDay: _isAllDay,
        );
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task saved.')));
    }
  }

  Future<void> _toggleStatus(TaskStatus status) async {
    final repository = ref.read(taskRepositoryProvider);
    if (status == TaskStatus.completed) {
      await repository.reopenTask(widget.taskId);
    } else {
      await repository.completeTask(widget.taskId);
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
