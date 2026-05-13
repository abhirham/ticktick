import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../app/theme.dart';
import '../../../../core/time/flow_date_utils.dart';
import '../../application/task_providers.dart';
import '../../domain/task_enums.dart';
import 'task_widgets.dart';

Future<void> showTaskDetailSheet(BuildContext context, String taskId) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: false,
    useRootNavigator: true,
    barrierColor: Colors.black.withValues(alpha: 0.82),
    backgroundColor: Colors.transparent,
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
      loading: () => const SizedBox(
        height: 260,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) =>
          SizedBox(height: 260, child: Center(child: Text('$error'))),
      data: (task) {
        if (task == null) {
          return SizedBox(
            height: 260,
            child: Center(
              child: Text(
                'Task not found',
                style: TextStyle(color: colors.text, fontSize: 22),
              ),
            ),
          );
        }

        final isCompleted =
            TaskStatus.fromValue(task.status) == TaskStatus.completed;
        final dateText = task.dueDate == null
            ? 'No date'
            : detailDateLabel(task.dueDate!, DateTime.now());

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 24,
                offset: Offset(0, -8),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(16, 26, 16, 28),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.38,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Inbox',
                        style: TextStyle(
                          color: colors.textStrong,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.unfold_more_rounded,
                        color: colors.iconMuted,
                        size: 25,
                      ),
                      const Spacer(),
                      Icon(Icons.flag_outlined, color: colors.icon, size: 28),
                      const SizedBox(width: 22),
                      Icon(
                        Icons.more_vert_rounded,
                        color: colors.icon,
                        size: 30,
                      ),
                    ],
                  ),
                  const SizedBox(height: 34),
                  Row(
                    children: [
                      TaskCheckBox(
                        checked: isCompleted,
                        onTap: () {
                          if (isCompleted) {
                            ref
                                .read(taskRepositoryProvider)
                                .reopenTask(task.id);
                          } else {
                            ref
                                .read(taskRepositoryProvider)
                                .completeTask(task.id);
                          }
                        },
                      ),
                      const SizedBox(width: 24),
                      Text(
                        dateText,
                        style: TextStyle(
                          color: task.dueDate == null
                              ? colors.textMuted
                              : colors.dangerStrong,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  Text(
                    task.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colors.textStrong,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(
                        Icons.local_offer_outlined,
                        color: colors.iconMuted,
                        size: 28,
                      ),
                      const SizedBox(width: 24),
                      Icon(
                        Icons.format_list_bulleted_rounded,
                        color: colors.iconMuted,
                        size: 28,
                      ),
                      const SizedBox(width: 24),
                      Icon(
                        Icons.attach_file_rounded,
                        color: colors.iconMuted,
                        size: 28,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
