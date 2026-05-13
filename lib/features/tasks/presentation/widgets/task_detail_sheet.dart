import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../app/theme.dart';
import '../../../../core/time/flow_date_utils.dart';
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
      loading: () => const _TaskDetailSheetFrame(
        child: Center(child: CircularProgressIndicator()),
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
        final dateText = task.dueDate == null
            ? 'No date'
            : detailDateLabel(task.dueDate!, DateTime.now());

        return _TaskDetailSheetFrame(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Inbox',
                    style: TextStyle(
                      color: colors.textStrong,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.unfold_more_rounded,
                    color: colors.iconMuted,
                    size: 22,
                  ),
                  const Spacer(),
                  Icon(Icons.flag_outlined, color: colors.icon, size: 24),
                  const SizedBox(width: 18),
                  Icon(Icons.more_vert_rounded, color: colors.icon, size: 26),
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
                  Icon(
                    Icons.local_offer_outlined,
                    color: colors.iconMuted,
                    size: 24,
                  ),
                  const SizedBox(width: 22),
                  Icon(
                    Icons.format_list_bulleted_rounded,
                    color: colors.iconMuted,
                    size: 24,
                  ),
                  const SizedBox(width: 22),
                  Icon(
                    Icons.attach_file_rounded,
                    color: colors.iconMuted,
                    size: 24,
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
