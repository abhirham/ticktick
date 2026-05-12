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
      onToggleTask: (task) {
        ref.read(taskRepositoryProvider).completeTask(task.id);
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
      onToggleTask: (task) {
        ref.read(taskRepositoryProvider).reopenTask(task.id);
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
      onToggleTask: (task) {
        ref.read(taskRepositoryProvider).restoreTask(task.id);
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
  final ValueChanged<TaskItem> onToggleTask;
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
                    onToggleTask: onToggleTask,
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
