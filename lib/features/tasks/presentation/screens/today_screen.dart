import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../app/theme.dart';
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
            actions: [
              FlowIconButton(
                icon: Icons.tips_and_updates_outlined,
                tooltip: 'Ideas',
                onPressed: () {},
              ),
              FlowIconButton(
                icon: Icons.more_vert_rounded,
                tooltip: 'Today options',
                onPressed: () {},
              ),
            ],
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
                    action: SectionTextAction(
                      label: 'Postpone',
                      onPressed: () {},
                    ),
                    showProjectMarkers: true,
                    onTaskTap: (task) => showTaskDetailSheet(context, task.id),
                    onToggleTask: (task) {
                      ref.read(taskRepositoryProvider).completeTask(task.id);
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
                    onTaskTap: (task) => showTaskDetailSheet(context, task.id),
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
