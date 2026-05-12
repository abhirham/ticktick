import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers.dart';
import '../../../../app/theme.dart';
import '../../../../core/time/flow_date_utils.dart';
import '../../application/task_providers.dart';
import '../../domain/task_draft.dart';
import '../widgets/task_widgets.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayTasks = ref.watch(todayTasksProvider);
    final completedTasks = ref.watch(completedTasksProvider);
    final colors = context.colors;

    return ColoredBox(
      color: colors.bg,
      child: Column(
        children: [
          FlowTaskPageHeader(
            title: 'Today',
            leading: FlowIconButton(
              icon: Icons.menu_rounded,
              tooltip: 'Open lists',
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            actions: [
              FlowIconButton(
                icon: Icons.lightbulb_outline_rounded,
                tooltip: 'Natural Language Debug opens in Phase 3',
                onPressed: null,
              ),
              FlowIconButton(
                icon: Icons.more_vert_rounded,
                tooltip: 'Today options open in Phase 4',
                onPressed: null,
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 112),
              children: [
                const _QuickAddTodayField(),
                const SizedBox(height: 16),
                todayTasks.when(
                  data: (tasks) => TaskSectionCard(
                    title: 'Today',
                    tasks: tasks,
                    emptyText: 'No tasks due today.',
                    onTaskTap: (task) => context.go('/task/${task.id}'),
                    onToggleTask: (task) {
                      ref.read(taskRepositoryProvider).completeTask(task.id);
                    },
                  ),
                  loading: () => const _LoadingCard(title: 'Today'),
                  error: (error, _) => _ErrorCard(message: '$error'),
                ),
                const SizedBox(height: 16),
                completedTasks.when(
                  data: (tasks) => TaskSectionCard(
                    title: 'Completed',
                    tasks: tasks.take(3).toList(),
                    emptyText: 'Completed tasks will collect here.',
                    muted: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${tasks.length}',
                          style: TextStyle(
                            color: colors.textMuted,
                            fontSize: 22,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: colors.textMuted,
                        ),
                      ],
                    ),
                    onTaskTap: (task) => context.go('/task/${task.id}'),
                    onToggleTask: (task) {
                      ref.read(taskRepositoryProvider).reopenTask(task.id);
                    },
                  ),
                  loading: () => const _LoadingCard(title: 'Completed'),
                  error: (error, _) => _ErrorCard(message: '$error'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAddTodayField extends ConsumerStatefulWidget {
  const _QuickAddTodayField();

  @override
  ConsumerState<_QuickAddTodayField> createState() =>
      _QuickAddTodayFieldState();
}

class _QuickAddTodayFieldState extends ConsumerState<_QuickAddTodayField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Icon(Icons.add_rounded, color: colors.primary, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              cursorColor: colors.primary,
              style: TextStyle(color: colors.text, fontSize: 22),
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: 'Add a task for today',
              ),
              onSubmitted: _createTask,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createTask(String value) async {
    final title = value.trim();
    if (title.isEmpty) {
      return;
    }
    try {
      await ref
          .read(taskRepositoryProvider)
          .createTask(
            TaskDraft(title: title, dueDate: dateOnly(DateTime.now())),
          );
      _controller.clear();
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not create task: $error')));
    }
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return TaskSectionCard(
      title: title,
      tasks: const [],
      emptyText: 'Loading...',
      onTaskTap: (_) {},
      onToggleTask: (_) {},
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return TaskSectionCard(
      title: 'Error',
      tasks: const [],
      emptyText: message,
      onTaskTap: (_) {},
      onToggleTask: (_) {},
    );
  }
}
