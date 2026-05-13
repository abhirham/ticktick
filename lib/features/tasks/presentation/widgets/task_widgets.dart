import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../core/time/flow_date_utils.dart';
import '../../../../data/local/app_database.dart';
import '../../domain/task_enums.dart';

class FlowTaskPageHeader extends StatelessWidget {
  const FlowTaskPageHeader({
    required this.title,
    this.leading,
    this.actions = const [],
    super.key,
  });

  final String title;
  final Widget? leading;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              leading ?? const SizedBox(width: 56),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.textStrong,
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ),
              ...actions,
            ],
          ),
        ),
      ),
    );
  }
}

class FlowIconButton extends StatelessWidget {
  const FlowIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.isActive = false,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      width: 44,
      height: 44,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 44, height: 44),
        iconSize: 27,
        color: isActive ? colors.primary : colors.icon,
        disabledColor: colors.icon,
        icon: Icon(icon),
      ),
    );
  }
}

class TaskSectionCard extends StatelessWidget {
  const TaskSectionCard({
    required this.title,
    required this.tasks,
    required this.emptyText,
    required this.onTaskTap,
    required this.onToggleTask,
    this.trailing,
    this.action,
    this.showChevron = true,
    this.showProjectMarkers = false,
    this.muted = false,
    super.key,
  });

  final String title;
  final List<TaskItem> tasks;
  final String emptyText;
  final ValueChanged<TaskItem> onTaskTap;
  final ValueChanged<TaskItem> onToggleTask;
  final Widget? trailing;
  final Widget? action;
  final bool showChevron;
  final bool showProjectMarkers;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: muted ? colors.textSubtle : colors.text,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
              ),
              if (action != null) action!,
              if (action != null) const SizedBox(width: 14),
              trailing ??
                  _HeaderCount(count: tasks.length, chevron: showChevron),
            ],
          ),
          if (tasks.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                emptyText,
                style: TextStyle(
                  color: colors.textMuted,
                  fontSize: 17,
                  height: 1.3,
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  if (showProjectMarkers && tasks.length > 2)
                    const Positioned(
                      left: -16,
                      top: 96,
                      child: _ProjectMarker(height: 44),
                    ),
                  if (showProjectMarkers && tasks.length > 4)
                    const Positioned(
                      left: -16,
                      top: 220,
                      child: _ProjectMarker(height: 44),
                    ),
                  if (showProjectMarkers && tasks.length > 6)
                    const Positioned(
                      left: -16,
                      bottom: 10,
                      child: _ProjectMarker(height: 44),
                    ),
                  Column(
                    children: [
                      for (final task in tasks)
                        TaskRow(
                          task: task,
                          muted: muted,
                          onTap: () => onTaskTap(task),
                          onToggle: () => onToggleTask(task),
                        ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class SectionTextAction extends StatelessWidget {
  const SectionTextAction({required this.label, this.onPressed, super.key});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: colors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        minimumSize: const Size(0, 40),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class TaskRow extends StatelessWidget {
  const TaskRow({
    required this.task,
    required this.onTap,
    required this.onToggle,
    this.muted = false,
    super.key,
  });

  final TaskItem task;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isCompleted =
        TaskStatus.fromValue(task.status) == TaskStatus.completed;
    final isPersistent = task.isPersistent && task.showInTodayUntilComplete;
    final metadata = _metadataLabel(task, DateTime.now());

    return Semantics(
      button: true,
      label: task.title,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 40),
          child: Row(
            children: [
              TaskCheckBox(
                checked: isCompleted,
                onTap: onToggle,
                muted: muted || isCompleted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: muted || isCompleted
                              ? colors.textSubtle
                              : colors.text,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          height: 1.28,
                        ),
                      ),
                    ),
                    if (isPersistent) ...[
                      const SizedBox(width: 6),
                      _PersistentBadge(muted: muted || isCompleted),
                    ],
                  ],
                ),
              ),
              if (metadata != null) ...[
                const SizedBox(width: 10),
                SizedBox(
                  width: 82,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        metadata.label,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: muted
                              ? colors.textSubtle
                              : metadata.color(colors),
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                      if (task.recurrenceRuleId != null) ...[
                        const SizedBox(height: 4),
                        Icon(
                          Icons.repeat_rounded,
                          color: colors.textSubtle,
                          size: 15,
                        ),
                      ],
                    ],
                  ),
                ),
              ] else if (task.recurrenceRuleId != null) ...[
                const SizedBox(width: 10),
                SizedBox(
                  width: 32,
                  child: Icon(
                    Icons.repeat_rounded,
                    color: colors.textSubtle,
                    size: 15,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  _TaskMetadata? _metadataLabel(TaskItem task, DateTime now) {
    if (task.dueTime != null && task.dueDate != null) {
      return _TaskMetadata(
        timeLabel(task.dueTime!),
        (colors) => colors.primary,
      );
    }
    if (task.isPersistent &&
        task.showInTodayUntilComplete &&
        task.dueDate == null) {
      final count = task.todayCarryForwardCount;
      return _TaskMetadata(count > 0 ? 'Carried ${count}d' : 'Persistent', (
        colors,
      ) {
        return colors.primary;
      });
    }
    if (task.dueDate == null) {
      return null;
    }
    final dueDate = task.dueDate!;
    final label = taskListDateLabel(dueDate, now);
    final isOverdue = dateOnly(dueDate).isBefore(dateOnly(now));
    return _TaskMetadata(label, (colors) {
      return isOverdue ? colors.danger : colors.textMuted;
    });
  }
}

class TaskCheckBox extends StatelessWidget {
  const TaskCheckBox({
    required this.checked,
    required this.onTap,
    this.muted = false,
    super.key,
  });

  final bool checked;
  final VoidCallback onTap;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: checked ? colors.textSubtle : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: checked || muted ? colors.textSubtle : colors.border,
            width: 1.4,
          ),
        ),
        child: checked
            ? Icon(Icons.check_rounded, size: 13, color: colors.surface)
            : null,
      ),
    );
  }
}

class _PersistentBadge extends StatelessWidget {
  const _PersistentBadge({required this.muted});

  final bool muted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: 19,
      height: 19,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: muted ? colors.surfaceRaised : colors.surfaceSelected,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Icon(
        Icons.push_pin_outlined,
        color: muted ? colors.textSubtle : colors.primary,
        size: 12,
      ),
    );
  }
}

class _HeaderCount extends StatelessWidget {
  const _HeaderCount({required this.count, required this.chevron});

  final int count;
  final bool chevron;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$count',
          style: TextStyle(color: colors.textMuted, fontSize: 14.5),
        ),
        if (chevron) ...[
          const SizedBox(width: 6),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: colors.textMuted,
            size: 22,
          ),
        ],
      ],
    );
  }
}

class _ProjectMarker extends StatelessWidget {
  const _ProjectMarker({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF55A8FF),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _TaskMetadata {
  const _TaskMetadata(this.label, this.color);

  final String label;
  final Color Function(FlowTaskColors colors) color;
}
