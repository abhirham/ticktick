import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers.dart';
import '../../../../app/theme.dart';
import '../../../../data/local/app_database.dart';
import '../../application/task_providers.dart';
import '../widgets/task_widgets.dart';

class AllTasksScreen extends ConsumerWidget {
  const AllTasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _TaskCollectionScreen(
      title: 'All Tasks',
      tasks: ref.watch(allOpenTasksProvider),
      emptyText: 'Open tasks will appear here.',
      onToggleTask: (context, task) async {
        final repository = ref.read(taskRepositoryProvider);
        await repository.completeTask(task.id);
        if (context.mounted) {
          _showUndoSnackBar(
            context,
            'Task completed.',
            () => repository.reopenTask(task.id),
          );
        }
      },
    );
  }
}

class CompletedScreen extends ConsumerWidget {
  const CompletedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _TaskCollectionScreen(
      title: 'Completed',
      tasks: ref.watch(completedTasksProvider),
      emptyText: 'Completed tasks will appear here.',
      muted: true,
      onToggleTask: (context, task) async {
        final repository = ref.read(taskRepositoryProvider);
        await repository.reopenTask(task.id);
        if (context.mounted) {
          _showUndoSnackBar(
            context,
            'Task reopened.',
            () => repository.completeTask(task.id),
          );
        }
      },
    );
  }
}

class TrashScreen extends ConsumerWidget {
  const TrashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _TaskCollectionScreen(
      title: 'Trash',
      tasks: ref.watch(trashTasksProvider),
      emptyText: 'Deleted tasks will appear here.',
      muted: true,
      onToggleTask: (context, task) async {
        final repository = ref.read(taskRepositoryProvider);
        await repository.restoreTask(task.id);
        if (context.mounted) {
          _showUndoSnackBar(
            context,
            'Task restored.',
            () => repository.moveTaskToTrash(task.id),
          );
        }
      },
    );
  }
}

class _TaskCollectionScreen extends StatelessWidget {
  const _TaskCollectionScreen({
    required this.title,
    required this.tasks,
    required this.emptyText,
    required this.onToggleTask,
    this.muted = false,
  });

  final String title;
  final AsyncValue<List<TaskItem>> tasks;
  final String emptyText;
  final Future<void> Function(BuildContext context, TaskItem task) onToggleTask;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ColoredBox(
      color: colors.bg,
      child: Column(
        children: [
          FlowTaskPageHeader(
            title: title,
            leading: FlowIconButton(
              icon: Icons.arrow_back_rounded,
              tooltip: 'Back to lists',
              onPressed: () => context.go('/lists'),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 112),
              children: [
                tasks.when(
                  data: (items) => TaskSectionCard(
                    title: title,
                    tasks: items,
                    emptyText: emptyText,
                    muted: muted,
                    onTaskTap: (task) => context.go('/task/${task.id}'),
                    onToggleTask: (task) => onToggleTask(context, task),
                  ),
                  loading: () => TaskSectionCard(
                    title: title,
                    tasks: const [],
                    emptyText: 'Loading...',
                    onTaskTap: (_) {},
                    onToggleTask: (_) {},
                  ),
                  error: (error, _) => TaskSectionCard(
                    title: 'Error',
                    tasks: const [],
                    emptyText: '$error',
                    onTaskTap: (_) {},
                    onToggleTask: (_) {},
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

void _showUndoSnackBar(
  BuildContext context,
  String message,
  Future<void> Function() undo,
) {
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
