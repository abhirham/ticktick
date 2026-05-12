import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers.dart';
import '../../../../app/theme.dart';
import '../../../../core/time/flow_date_utils.dart';
import '../../application/task_providers.dart';
import '../../domain/task_enums.dart';
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
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: _pickDate,
                                child: Text(
                                  _dueDate == null
                                      ? 'No date'
                                      : compactDateLabel(
                                          _dueDate!,
                                          DateTime.now(),
                                        ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          TextField(
                            controller: _titleController,
                            cursorColor: colors.primary,
                            style: TextStyle(
                              color: colors.textStrong,
                              fontSize: 34,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Title',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _descriptionController,
                            cursorColor: colors.primary,
                            minLines: 2,
                            maxLines: 5,
                            style: TextStyle(color: colors.text, fontSize: 21),
                            decoration: const InputDecoration(
                              hintText: 'Description',
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
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primaryBright,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: _save,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Save Changes'),
                    ),
                    const SizedBox(height: 10),
                    if (status == TaskStatus.deleted) ...[
                      OutlinedButton.icon(
                        onPressed: () async {
                          await ref
                              .read(taskRepositoryProvider)
                              .restoreTask(task.id);
                          if (context.mounted) context.go('/trash');
                        },
                        icon: const Icon(Icons.restore_rounded),
                        label: const Text('Restore Task'),
                      ),
                      const SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: () => _confirmPermanentDelete(task.id),
                        icon: Icon(Icons.delete_forever, color: colors.danger),
                        label: Text(
                          'Delete Forever',
                          style: TextStyle(color: colors.danger),
                        ),
                      ),
                    ] else ...[
                      OutlinedButton.icon(
                        onPressed: () => _toggleStatus(status),
                        icon: Icon(
                          status == TaskStatus.completed
                              ? Icons.replay_rounded
                              : Icons.check_rounded,
                        ),
                        label: Text(
                          status == TaskStatus.completed
                              ? 'Reopen Task'
                              : 'Mark Complete',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: () async {
                          await ref
                              .read(taskRepositoryProvider)
                              .moveTaskToTrash(task.id);
                          if (context.mounted) context.go('/trash');
                        },
                        icon: Icon(Icons.delete_outline, color: colors.danger),
                        label: Text(
                          'Move to Trash',
                          style: TextStyle(color: colors.danger),
                        ),
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
    final picked = await showDatePicker(
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
    final selected = await showModalBottomSheet<TaskPriority>(
      context: context,
      builder: (context) {
        final colors = context.colors;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final priority in TaskPriority.values)
                  ListTile(
                    textColor: colors.text,
                    iconColor: colors.iconMuted,
                    leading: const Icon(Icons.flag_outlined),
                    title: Text(priority.label),
                    onTap: () => Navigator.of(context).pop(priority),
                  ),
              ],
            ),
          ),
        );
      },
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete forever?'),
          content: const Text(
            'This permanently removes the task from FlowTask.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
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
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: active ? colors.primary : colors.textMuted,
        backgroundColor: active ? colors.surfaceSelected : colors.surfaceRaised,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      icon: Icon(icon, size: 20),
      label: Text(label),
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
      style: TextStyle(color: colors.textMuted, fontSize: 16),
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
            style: TextStyle(color: colors.text, fontSize: 24),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onBack, child: const Text('Back to Lists')),
        ],
      ),
    );
  }
}
