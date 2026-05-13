import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../core/time/flow_date_utils.dart';
import '../../../data/local/app_database.dart';
import '../../../shared/presentation/flow_bottom_sheet.dart';
import '../../../shared/presentation/flow_date_picker.dart';
import '../../tasks/domain/task_enums.dart';
import '../../tasks/presentation/widgets/quick_add_sheet.dart';
import '../../tasks/presentation/widgets/task_detail_sheet.dart';
import '../../tasks/presentation/widgets/task_widgets.dart';
import '../application/calendar_providers.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _selectedDate = dateOnly(DateTime.now());
  _CalendarView _view = _CalendarView.month;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final range = _visibleRange(_view, _selectedDate);
    final tasks = ref.watch(
      calendarTasksForRangeProvider((start: range.start, end: range.end)),
    );

    return ColoredBox(
      color: colors.bg,
      child: Column(
        children: [
          FlowTaskPageHeader(
            title: _monthTitle(_selectedDate),
            leading: FlowIconButton(
              icon: Icons.menu_rounded,
              tooltip: 'Open navigation',
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            actions: [
              FlowIconButton(
                icon: _view.icon,
                tooltip: 'Calendar view',
                isActive: true,
                onPressed: _showViewSheet,
              ),
              FlowIconButton(
                icon: Icons.today_rounded,
                tooltip: 'Go to today',
                onPressed: _goToday,
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 112),
              children: [
                _PeriodNavigator(
                  label: _rangeLabel(_view, _selectedDate),
                  onPrevious: () => _shiftPeriod(-1),
                  onNext: () => _shiftPeriod(1),
                ),
                const SizedBox(height: 10),
                if (_view != _CalendarView.month) ...[
                  _WeekStrip(
                    selectedDate: _selectedDate,
                    taskCounts: tasks.maybeWhen(
                      data: (items) => _taskCountsByDate(items),
                      orElse: () => const <DateTime, int>{},
                    ),
                    onSelected: (date) {
                      setState(() => _selectedDate = dateOnly(date));
                    },
                  ),
                  const SizedBox(height: 14),
                ],
                tasks.when(
                  data: (items) => _CalendarViewBody(
                    view: _view,
                    selectedDate: _selectedDate,
                    range: range,
                    tasksByDate: groupTasksByCalendarDate(items),
                    onCreateTask: _createTaskForDate,
                    onTaskTap: (task) => showTaskDetailSheet(context, task.id),
                    onToggleTask: (task) {
                      ref.read(taskRepositoryProvider).completeTask(task.id);
                    },
                    onTaskActions: _showTaskDateActions,
                  ),
                  loading: () => const _CalendarMessageCard(
                    title: 'Calendar',
                    message: 'Loading...',
                  ),
                  error: (error, _) =>
                      _CalendarMessageCard(title: 'Error', message: '$error'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createTaskForDate(DateTime date) {
    final targetDate = dateOnly(date);
    setState(() => _selectedDate = targetDate);
    return showQuickAddSheet(
      context,
      initialDueDate: targetDate,
      dateLabel: compactDateLabel(targetDate, DateTime.now()),
    );
  }

  Future<void> _showTaskDateActions(TaskItem task) async {
    final action = await showFlowBottomSheet<_CalendarTaskAction>(
      context: context,
      builder: (context) => _TaskDateActionSheet(selectedDate: _selectedDate),
    );
    if (action == null || !mounted) {
      return;
    }

    final repository = ref.read(taskRepositoryProvider);
    switch (action) {
      case _CalendarTaskAction.moveToSelectedDate:
        await repository.moveTaskToDate(id: task.id, date: _selectedDate);
      case _CalendarTaskAction.chooseDate:
        final now = DateTime.now();
        final picked = await showFlowDatePicker(
          context: context,
          initialDate: calendarDateForTask(task) ?? _selectedDate,
          firstDate: DateTime(now.year - 1),
          lastDate: DateTime(now.year + 5),
        );
        if (picked != null) {
          await repository.moveTaskToDate(id: task.id, date: picked);
        }
      case _CalendarTaskAction.clearDate:
        await repository.clearTaskDate(task.id);
    }
  }

  Future<void> _showViewSheet() async {
    final selected = await showFlowBottomSheet<_CalendarView>(
      context: context,
      builder: (context) => _CalendarViewSheet(selected: _view),
    );
    if (selected != null && mounted) {
      setState(() => _view = selected);
    }
  }

  void _goToday() {
    setState(() => _selectedDate = dateOnly(DateTime.now()));
  }

  void _shiftPeriod(int direction) {
    setState(() {
      _selectedDate = switch (_view) {
        _CalendarView.month => _addMonthsClamped(_selectedDate, direction),
        _CalendarView.week => _selectedDate.add(Duration(days: direction * 7)),
        _CalendarView.day => _selectedDate.add(Duration(days: direction)),
        _CalendarView.agenda => _selectedDate.add(
          Duration(days: direction * 14),
        ),
      };
      _selectedDate = dateOnly(_selectedDate);
    });
  }

  String _monthTitle(DateTime date) {
    return _monthName(date.month);
  }
}

class _CalendarViewBody extends StatelessWidget {
  const _CalendarViewBody({
    required this.view,
    required this.selectedDate,
    required this.range,
    required this.tasksByDate,
    required this.onCreateTask,
    required this.onTaskTap,
    required this.onToggleTask,
    required this.onTaskActions,
  });

  final _CalendarView view;
  final DateTime selectedDate;
  final CalendarRange range;
  final Map<DateTime, List<TaskItem>> tasksByDate;
  final ValueChanged<DateTime> onCreateTask;
  final ValueChanged<TaskItem> onTaskTap;
  final ValueChanged<TaskItem> onToggleTask;
  final ValueChanged<TaskItem> onTaskActions;

  @override
  Widget build(BuildContext context) {
    return switch (view) {
      _CalendarView.month => _MonthView(
        selectedDate: selectedDate,
        range: range,
        tasksByDate: tasksByDate,
        onCreateTask: onCreateTask,
        onTaskTap: onTaskTap,
        onToggleTask: onToggleTask,
        onTaskActions: onTaskActions,
      ),
      _CalendarView.week => _StackedDaySections(
        dates: _datesBetween(range.start, range.end),
        tasksByDate: tasksByDate,
        onCreateTask: onCreateTask,
        onTaskTap: onTaskTap,
        onToggleTask: onToggleTask,
        onTaskActions: onTaskActions,
      ),
      _CalendarView.day => _StackedDaySections(
        dates: [selectedDate],
        tasksByDate: tasksByDate,
        onCreateTask: onCreateTask,
        onTaskTap: onTaskTap,
        onToggleTask: onToggleTask,
        onTaskActions: onTaskActions,
      ),
      _CalendarView.agenda => _StackedDaySections(
        dates: _agendaDates(range, tasksByDate, selectedDate),
        tasksByDate: tasksByDate,
        onCreateTask: onCreateTask,
        onTaskTap: onTaskTap,
        onToggleTask: onToggleTask,
        onTaskActions: onTaskActions,
      ),
    };
  }
}

class _MonthView extends StatelessWidget {
  const _MonthView({
    required this.selectedDate,
    required this.range,
    required this.tasksByDate,
    required this.onCreateTask,
    required this.onTaskTap,
    required this.onToggleTask,
    required this.onTaskActions,
  });

  final DateTime selectedDate;
  final CalendarRange range;
  final Map<DateTime, List<TaskItem>> tasksByDate;
  final ValueChanged<DateTime> onCreateTask;
  final ValueChanged<TaskItem> onTaskTap;
  final ValueChanged<TaskItem> onToggleTask;
  final ValueChanged<TaskItem> onTaskActions;

  @override
  Widget build(BuildContext context) {
    final selectedTasks = tasksByDate[dateOnly(selectedDate)] ?? const [];
    return Column(
      children: [
        _MonthGrid(
          selectedDate: selectedDate,
          range: range,
          tasksByDate: tasksByDate,
          onDateTap: onCreateTask,
        ),
        const SizedBox(height: 16),
        _CalendarDaySection(
          date: selectedDate,
          tasks: selectedTasks,
          onCreateTask: onCreateTask,
          onTaskTap: onTaskTap,
          onToggleTask: onToggleTask,
          onTaskActions: onTaskActions,
        ),
      ],
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.selectedDate,
    required this.range,
    required this.tasksByDate,
    required this.onDateTap,
  });

  final DateTime selectedDate;
  final CalendarRange range;
  final Map<DateTime, List<TaskItem>> tasksByDate;
  final ValueChanged<DateTime> onDateTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dates = _datesBetween(range.start, range.end);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
      child: Column(
        children: [
          Row(
            children: [
              for (final weekday in _weekdayLabels)
                Expanded(
                  child: Center(
                    child: Text(
                      weekday,
                      style: TextStyle(
                        color: colors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          GridView.builder(
            itemCount: dates.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisExtent: 78,
              crossAxisSpacing: 3,
              mainAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              final date = dates[index];
              return _MonthDayCell(
                date: date,
                selected: isSameLocalDate(date, selectedDate),
                today: isSameLocalDate(date, DateTime.now()),
                currentMonth: date.month == selectedDate.month,
                tasks: tasksByDate[dateOnly(date)] ?? const [],
                onTap: () => onDateTap(date),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MonthDayCell extends StatelessWidget {
  const _MonthDayCell({
    required this.date,
    required this.selected,
    required this.today,
    required this.currentMonth,
    required this.tasks,
    required this.onTap,
  });

  final DateTime date;
  final bool selected;
  final bool today;
  final bool currentMonth;
  final List<TaskItem> tasks;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final visibleTasks = tasks.take(2).toList();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? colors.surfaceSelected : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? colors.primary
                    : today
                    ? colors.textStrong
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${date.day}',
                style: TextStyle(
                  color: selected
                      ? colors.textStrong
                      : today
                      ? colors.primary
                      : currentMonth
                      ? colors.text
                      : colors.textSubtle,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ),
            const SizedBox(height: 4),
            if (tasks.isNotEmpty)
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                ),
              )
            else
              const SizedBox(height: 4),
            const SizedBox(height: 4),
            for (final task in visibleTasks)
              Text(
                task.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: currentMonth ? colors.textMuted : colors.textSubtle,
                  fontSize: 10.5,
                  height: 1.15,
                ),
              ),
            if (tasks.length > visibleTasks.length)
              Text(
                '+${tasks.length - visibleTasks.length}',
                style: TextStyle(
                  color: colors.primary,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StackedDaySections extends StatelessWidget {
  const _StackedDaySections({
    required this.dates,
    required this.tasksByDate,
    required this.onCreateTask,
    required this.onTaskTap,
    required this.onToggleTask,
    required this.onTaskActions,
  });

  final List<DateTime> dates;
  final Map<DateTime, List<TaskItem>> tasksByDate;
  final ValueChanged<DateTime> onCreateTask;
  final ValueChanged<TaskItem> onTaskTap;
  final ValueChanged<TaskItem> onToggleTask;
  final ValueChanged<TaskItem> onTaskActions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < dates.length; index++) ...[
          _CalendarDaySection(
            date: dates[index],
            tasks: tasksByDate[dateOnly(dates[index])] ?? const [],
            onCreateTask: onCreateTask,
            onTaskTap: onTaskTap,
            onToggleTask: onToggleTask,
            onTaskActions: onTaskActions,
          ),
          if (index != dates.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _CalendarDaySection extends StatelessWidget {
  const _CalendarDaySection({
    required this.date,
    required this.tasks,
    required this.onCreateTask,
    required this.onTaskTap,
    required this.onToggleTask,
    required this.onTaskActions,
  });

  final DateTime date;
  final List<TaskItem> tasks;
  final ValueChanged<DateTime> onCreateTask;
  final ValueChanged<TaskItem> onTaskTap;
  final ValueChanged<TaskItem> onToggleTask;
  final ValueChanged<TaskItem> onTaskActions;

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
          InkWell(
            onTap: () => onCreateTask(date),
            borderRadius: BorderRadius.circular(14),
            child: SizedBox(
              height: 40,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _daySectionTitle(date, DateTime.now()),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.text,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                  ),
                  Text(
                    '${tasks.length}',
                    style: TextStyle(color: colors.textMuted, fontSize: 14.5),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.add_rounded, color: colors.primary, size: 22),
                ],
              ),
            ),
          ),
          if (tasks.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 10),
              child: Text(
                'No tasks scheduled.',
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
              child: Column(
                children: [
                  for (final task in tasks)
                    _CalendarTaskRow(
                      task: task,
                      onTap: () => onTaskTap(task),
                      onToggle: () => onToggleTask(task),
                      onActions: () => onTaskActions(task),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _CalendarTaskRow extends StatelessWidget {
  const _CalendarTaskRow({
    required this.task,
    required this.onTap,
    required this.onToggle,
    required this.onActions,
  });

  final TaskItem task;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onActions;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isCompleted =
        TaskStatus.fromValue(task.status) == TaskStatus.completed;
    return Semantics(
      button: true,
      label: task.title,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: Row(
            children: [
              TaskCheckBox(
                checked: isCompleted,
                onTap: onToggle,
                muted: isCompleted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  task.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isCompleted ? colors.textSubtle : colors.text,
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    height: 1.28,
                  ),
                ),
              ),
              if (task.dueTime != null) ...[
                const SizedBox(width: 8),
                Text(
                  timeLabel(task.dueTime!),
                  style: TextStyle(
                    color: colors.primary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
              ],
              if (task.recurrenceRuleId != null) ...[
                const SizedBox(width: 8),
                Icon(Icons.repeat_rounded, color: colors.textSubtle, size: 15),
              ],
              SizedBox.square(
                dimension: 40,
                child: IconButton(
                  tooltip: 'Task date actions',
                  onPressed: onActions,
                  padding: EdgeInsets.zero,
                  iconSize: 22,
                  color: colors.iconMuted,
                  icon: const Icon(Icons.more_horiz_rounded),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeekStrip extends StatelessWidget {
  const _WeekStrip({
    required this.selectedDate,
    required this.taskCounts,
    required this.onSelected,
  });

  final DateTime selectedDate;
  final Map<DateTime, int> taskCounts;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    final start = _startOfWeek(selectedDate);
    return SizedBox(
      height: 68,
      child: Row(
        children: [
          for (var index = 0; index < 7; index++)
            Expanded(
              child: _DatePill(
                date: start.add(Duration(days: index)),
                selected: isSameLocalDate(
                  selectedDate,
                  start.add(Duration(days: index)),
                ),
                today: isSameLocalDate(
                  DateTime.now(),
                  start.add(Duration(days: index)),
                ),
                hasTasks:
                    (taskCounts[dateOnly(start.add(Duration(days: index)))] ??
                        0) >
                    0,
                onTap: () => onSelected(start.add(Duration(days: index))),
              ),
            ),
        ],
      ),
    );
  }
}

class _DatePill extends StatelessWidget {
  const _DatePill({
    required this.date,
    required this.selected,
    required this.today,
    required this.hasTasks,
    required this.onTap,
  });

  final DateTime date;
  final bool selected;
  final bool today;
  final bool hasTasks;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: SizedBox(
        height: 68,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _weekdayLabels[date.weekday % 7],
              style: TextStyle(
                color: selected ? colors.primary : colors.textMuted,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? colors.primary
                    : today
                    ? colors.textStrong
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${date.day}',
                style: TextStyle(
                  color: selected
                      ? colors.textStrong
                      : today
                      ? colors.primary
                      : colors.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: hasTasks ? colors.primary : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PeriodNavigator extends StatelessWidget {
  const _PeriodNavigator({
    required this.label,
    required this.onPrevious,
    required this.onNext,
  });

  final String label;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        FlowIconButton(
          icon: Icons.chevron_left_rounded,
          tooltip: 'Previous',
          onPressed: onPrevious,
        ),
        Expanded(
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colors.text,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ),
        ),
        FlowIconButton(
          icon: Icons.chevron_right_rounded,
          tooltip: 'Next',
          onPressed: onNext,
        ),
      ],
    );
  }
}

class _CalendarViewSheet extends StatelessWidget {
  const _CalendarViewSheet({required this.selected});

  final _CalendarView selected;

  @override
  Widget build(BuildContext context) {
    return FlowBottomSheetSurface(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final view in _CalendarView.values)
            _SheetActionRow(
              icon: view.icon,
              label: view.label,
              selected: view == selected,
              onTap: () => Navigator.of(context).pop(view),
            ),
        ],
      ),
    );
  }
}

class _TaskDateActionSheet extends StatelessWidget {
  const _TaskDateActionSheet({required this.selectedDate});

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final selectedLabel = compactDateLabel(selectedDate, DateTime.now());
    return FlowBottomSheetSurface(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SheetActionRow(
            icon: Icons.drive_file_move_outline,
            label: 'Move to $selectedLabel',
            onTap: () => Navigator.of(
              context,
            ).pop(_CalendarTaskAction.moveToSelectedDate),
          ),
          _SheetActionRow(
            icon: Icons.event_outlined,
            label: 'Choose date',
            onTap: () =>
                Navigator.of(context).pop(_CalendarTaskAction.chooseDate),
          ),
          _SheetActionRow(
            icon: Icons.event_busy_outlined,
            label: 'Clear date',
            destructive: true,
            onTap: () =>
                Navigator.of(context).pop(_CalendarTaskAction.clearDate),
          ),
        ],
      ),
    );
  }
}

class _SheetActionRow extends StatelessWidget {
  const _SheetActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = destructive
        ? colors.dangerStrong
        : selected
        ? colors.primary
        : colors.text;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            SizedBox(width: 42, child: Icon(icon, color: color, size: 23)),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check_rounded, color: colors.primary, size: 22),
          ],
        ),
      ),
    );
  }
}

class _CalendarMessageCard extends StatelessWidget {
  const _CalendarMessageCard({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return TaskSectionCard(
      title: title,
      tasks: const [],
      emptyText: message,
      onTaskTap: (_) {},
      onToggleTask: (_) {},
    );
  }
}

enum _CalendarTaskAction { moveToSelectedDate, chooseDate, clearDate }

enum _CalendarView {
  month('Month', Icons.calendar_view_month_rounded),
  week('Week', Icons.view_week_rounded),
  day('Day', Icons.calendar_view_day_rounded),
  agenda('Agenda', Icons.view_agenda_rounded);

  const _CalendarView(this.label, this.icon);

  final String label;
  final IconData icon;
}

CalendarRange _visibleRange(_CalendarView view, DateTime selectedDate) {
  final selected = dateOnly(selectedDate);
  return switch (view) {
    _CalendarView.month => (
      start: _startOfWeek(DateTime(selected.year, selected.month)),
      end: _endOfWeek(DateTime(selected.year, selected.month + 1, 0)),
    ),
    _CalendarView.week => (
      start: _startOfWeek(selected),
      end: _startOfWeek(selected).add(const Duration(days: 6)),
    ),
    _CalendarView.day => (start: selected, end: selected),
    _CalendarView.agenda => (
      start: selected,
      end: selected.add(const Duration(days: 13)),
    ),
  };
}

DateTime _startOfWeek(DateTime date) {
  final day = dateOnly(date);
  return day.subtract(Duration(days: day.weekday % 7));
}

DateTime _endOfWeek(DateTime date) {
  return _startOfWeek(date).add(const Duration(days: 6));
}

DateTime _addMonthsClamped(DateTime date, int months) {
  final targetMonth = DateTime(date.year, date.month + months);
  final day = date.day.clamp(
    1,
    _daysInMonth(targetMonth.year, targetMonth.month),
  );
  return DateTime(targetMonth.year, targetMonth.month, day);
}

int _daysInMonth(int year, int month) {
  return DateTime(year, month + 1, 0).day;
}

List<DateTime> _datesBetween(DateTime start, DateTime end) {
  final dates = <DateTime>[];
  var cursor = dateOnly(start);
  final last = dateOnly(end);
  while (!cursor.isAfter(last)) {
    dates.add(cursor);
    cursor = cursor.add(const Duration(days: 1));
  }
  return dates;
}

List<DateTime> _agendaDates(
  CalendarRange range,
  Map<DateTime, List<TaskItem>> tasksByDate,
  DateTime selectedDate,
) {
  final dates = _datesBetween(range.start, range.end);
  final withTasks = dates
      .where((date) => (tasksByDate[dateOnly(date)] ?? const []).isNotEmpty)
      .toList();
  if (withTasks.isEmpty) {
    return [dateOnly(selectedDate)];
  }
  return withTasks;
}

Map<DateTime, int> _taskCountsByDate(List<TaskItem> tasks) {
  final counts = <DateTime, int>{};
  for (final task in tasks) {
    final date = calendarDateForTask(task);
    if (date == null) {
      continue;
    }
    counts[date] = (counts[date] ?? 0) + 1;
  }
  return counts;
}

String _rangeLabel(_CalendarView view, DateTime selectedDate) {
  final range = _visibleRange(view, selectedDate);
  return switch (view) {
    _CalendarView.month =>
      '${_monthName(selectedDate.month)} ${selectedDate.year}',
    _CalendarView.week => _dateSpanLabel(range.start, range.end),
    _CalendarView.day => _fullDateLabel(selectedDate),
    _CalendarView.agenda => _dateSpanLabel(range.start, range.end),
  };
}

String _dateSpanLabel(DateTime start, DateTime end) {
  if (start.year == end.year && start.month == end.month) {
    return '${_shortMonthName(start.month)} ${start.day}-${end.day}, ${start.year}';
  }
  if (start.year == end.year) {
    return '${_shortMonthName(start.month)} ${start.day} - ${_shortMonthName(end.month)} ${end.day}, ${start.year}';
  }
  return '${_shortMonthName(start.month)} ${start.day}, ${start.year} - ${_shortMonthName(end.month)} ${end.day}, ${end.year}';
}

String _daySectionTitle(DateTime date, DateTime now) {
  return '${_weekdayName(date.weekday)}, ${taskListDateLabel(date, now)}';
}

String _fullDateLabel(DateTime date) {
  return '${_monthName(date.month)} ${date.day}, ${date.year}';
}

String _weekdayName(int weekday) {
  const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return names[weekday - 1];
}

String _monthName(int month) {
  const names = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return names[month - 1];
}

String _shortMonthName(int month) {
  const names = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return names[month - 1];
}

const _weekdayLabels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
