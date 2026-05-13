import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/providers.dart';
import '../../../../app/theme.dart';
import '../../../../core/time/flow_date_utils.dart';
import '../../../../data/local/app_database.dart';
import '../../../../shared/presentation/flow_bottom_sheet.dart';
import '../../application/task_providers.dart';
import '../../domain/task_enums.dart';
import 'task_widgets.dart';

Future<void> showTaskDetailSheet(BuildContext context, String taskId) {
  return showFlowBottomSheet<void>(
    context: context,
    builder: (context) => TaskDetailSheet(taskId: taskId),
  );
}

class TaskDetailSheet extends ConsumerWidget {
  const TaskDetailSheet({required this.taskId, super.key});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final taskAsync = ref.watch(taskByIdProvider(taskId));
    return taskAsync.when(
      loading: () => _TaskDetailSheetFrame(
        child: Center(child: CircularProgressIndicator(color: colors.primary)),
      ),
      error: (error, _) => _TaskDetailSheetFrame(
        child: Center(
          child: Text(
            '$error',
            style: TextStyle(color: colors.text, fontSize: 16),
          ),
        ),
      ),
      data: (task) {
        if (task == null) {
          return _TaskDetailSheetFrame(
            child: Center(
              child: Text(
                'Task not found',
                style: TextStyle(color: colors.text, fontSize: 18),
              ),
            ),
          );
        }

        final isCompleted =
            TaskStatus.fromValue(task.status) == TaskStatus.completed;
        final priority = TaskPriority.fromValue(task.priority);
        final lists = ref.watch(taskListsProvider).valueOrNull ?? const [];
        final listName = _listName(lists, task.listId);
        final dateText = task.dueDate == null
            ? 'No date'
            : detailDateLabel(task.dueDate!, DateTime.now());

        return _TaskDetailSheetFrame(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      listName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.textStrong,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (priority != TaskPriority.none)
                    _SheetInfoPill(
                      icon: Icons.flag_outlined,
                      label: priority.label,
                    ),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  TaskCheckBox(
                    checked: isCompleted,
                    onTap: () {
                      if (isCompleted) {
                        ref.read(taskRepositoryProvider).reopenTask(task.id);
                      } else {
                        ref.read(taskRepositoryProvider).completeTask(task.id);
                      }
                    },
                  ),
                  const SizedBox(width: 20),
                  Text(
                    dateText,
                    style: TextStyle(
                      color: task.dueDate == null
                          ? colors.textMuted
                          : colors.dangerStrong,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                task.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.textStrong,
                  fontSize: 24.5,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: _SheetActionButton(
                      icon: Icons.open_in_new_rounded,
                      label: 'Open Details',
                      onTap: () {
                        final router = GoRouter.of(context);
                        Navigator.of(context).pop();
                        router.go('/task/${task.id}');
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SheetActionButton(
                      icon: isCompleted
                          ? Icons.replay_rounded
                          : Icons.check_rounded,
                      label: isCompleted ? 'Reopen' : 'Complete',
                      onTap: () async {
                        if (isCompleted) {
                          await ref
                              .read(taskRepositoryProvider)
                              .reopenTask(task.id);
                        } else {
                          await ref
                              .read(taskRepositoryProvider)
                              .completeTask(task.id);
                        }
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

String _listName(List<TaskList> lists, String selectedId) {
  for (final list in lists) {
    if (list.id == selectedId) {
      return list.name;
    }
  }
  return selectedId == AppDatabase.inboxListId ? 'Inbox' : 'List';
}

class _SheetInfoPill extends StatelessWidget {
  const _SheetInfoPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: colors.primary, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: colors.text,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetActionButton extends StatelessWidget {
  const _SheetActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 44,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: colors.surfaceRaised,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: colors.primary, size: 19),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskDetailSheetFrame extends StatelessWidget {
  const _TaskDetailSheetFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FlowBottomSheetSurface(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      height: MediaQuery.sizeOf(context).height * 0.34,
      useKeyboardInset: false,
      child: child,
    );
  }
}
