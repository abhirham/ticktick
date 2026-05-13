import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../app/theme.dart';
import '../../../../core/time/flow_date_utils.dart';
import '../../../../data/local/app_database.dart';
import '../../application/task_providers.dart';
import '../widgets/task_detail_sheet.dart';
import '../widgets/task_widgets.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overdueTasks = ref.watch(overdueTasksProvider);
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
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 124),
              children: [
                overdueTasks.when(
                  data: (tasks) => TaskSectionCard(
                    title: 'Overdue',
                    tasks: tasks,
                    emptyText: 'No overdue tasks.',
                    action: tasks.isEmpty
                        ? null
                        : SectionTextAction(
                            label: 'Postpone',
                            onPressed: () =>
                                _postponeOverdueTasks(context, ref, tasks),
                          ),
                    showProjectMarkers: true,
                    onTaskTap: (task) => showTaskDetailSheet(context, task.id),
                    onToggleTask: (task) async {
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
                  ),
                  loading: () => const _LoadingCard(title: 'Overdue'),
                  error: (error, _) => _ErrorCard(message: '$error'),
                ),
                const SizedBox(height: 16),
                todayTasks.when(
                  data: (tasks) => TaskSectionCard(
                    title: 'Today',
                    tasks: tasks,
                    emptyText: 'No tasks due today.',
                    onTaskTap: (task) => showTaskDetailSheet(context, task.id),
                    onToggleTask: (task) async {
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
                    onTaskTap: (task) => showTaskDetailSheet(context, task.id),
                    onToggleTask: (task) async {
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

Future<void> _postponeOverdueTasks(
  BuildContext context,
  WidgetRef ref,
  List<TaskItem> tasks,
) async {
  final originalDueDates = {
    for (final task in tasks)
      if (task.dueDate != null) task.id: task.dueDate!,
  };
  if (originalDueDates.isEmpty) {
    return;
  }

  final repository = ref.read(taskRepositoryProvider);
  final today = dateOnly(ref.read(todayDateProvider));
  for (final id in originalDueDates.keys) {
    await repository.moveTaskToDate(id: id, date: today);
  }

  if (context.mounted) {
    _showUndoSnackBar(
      context,
      originalDueDates.length == 1
          ? 'Task postponed to today.'
          : '${originalDueDates.length} tasks postponed to today.',
      () async {
        for (final entry in originalDueDates.entries) {
          await repository.moveTaskToDate(id: entry.key, date: entry.value);
        }
      },
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
