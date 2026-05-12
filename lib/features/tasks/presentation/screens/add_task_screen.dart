import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers.dart';
import '../../../../app/theme.dart';
import '../../../../core/time/flow_date_utils.dart';
import '../../domain/task_draft.dart';
import '../../domain/task_enums.dart';
import '../widgets/task_widgets.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _dueDate;
  TaskPriority _priority = TaskPriority.none;
  bool _isPersistent = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
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
                          fontSize: 28,
                          height: 1.25,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'What would you like to do?',
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _descriptionController,
                        cursorColor: colors.primary,
                        minLines: 1,
                        maxLines: 3,
                        style: TextStyle(color: colors.text, fontSize: 21),
                        decoration: const InputDecoration(
                          hintText: 'Description',
                        ),
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _ChipButton(
                            icon: Icons.calendar_today_rounded,
                            label: _dueDate == null
                                ? 'No date'
                                : compactDateLabel(_dueDate!, DateTime.now()),
                            active: _dueDate != null,
                            onPressed: _pickDate,
                          ),
                          _ChipButton(
                            icon: Icons.flag_outlined,
                            label: _priority.label,
                            active: _priority != TaskPriority.none,
                            onPressed: _showPriorityMenu,
                          ),
                          _ChipButton(
                            icon: Icons.push_pin_outlined,
                            label: _isPersistent ? 'Stays Today' : 'Normal',
                            active: _isPersistent,
                            onPressed: () {
                              setState(() => _isPersistent = !_isPersistent);
                            },
                          ),
                          _ChipButton(
                            icon: Icons.inbox_outlined,
                            label: 'Inbox',
                            active: false,
                            onPressed: null,
                          ),
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
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Save Task'),
                ),
              ],
            ),
          ),
        ],
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
        .createTask(
          TaskDraft(
            title: title,
            description: _descriptionController.text,
            dueDate: _dueDate,
            priority: _priority,
            isPersistent: _isPersistent,
            showInTodayUntilComplete: _isPersistent,
          ),
        );
    if (mounted) {
      context.go('/today');
    }
  }
}

class _ChipButton extends StatelessWidget {
  const _ChipButton({
    required this.icon,
    required this.label,
    required this.active,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onPressed;

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
