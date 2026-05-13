import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../core/time/flow_date_utils.dart';
import '../../tasks/application/task_providers.dart';
import '../../tasks/presentation/widgets/quick_add_sheet.dart';
import '../../tasks/presentation/widgets/task_widgets.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _selectedDate = dateOnly(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final tasks = ref.watch(tasksForDateProvider(_selectedDate));

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
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 112),
              children: [
                _WeekStrip(
                  selectedDate: _selectedDate,
                  onSelected: (date) {
                    setState(() => _selectedDate = dateOnly(date));
                  },
                ),
                const SizedBox(height: 16),
                tasks.when(
                  data: (items) => TaskSectionCard(
                    title: compactDateLabel(_selectedDate, DateTime.now()),
                    tasks: items,
                    emptyText: 'No tasks due on this date.',
                    onTaskTap: (task) => context.go('/task/${task.id}'),
                    onToggleTask: (task) {
                      ref.read(taskRepositoryProvider).completeTask(task.id);
                    },
                  ),
                  loading: () => TaskSectionCard(
                    title: 'Calendar',
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
                const SizedBox(height: 16),
                _CalendarAddRow(
                  date: _selectedDate,
                  onTap: _createTaskForSelectedDate,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createTaskForSelectedDate() {
    return showQuickAddSheet(
      context,
      initialDueDate: _selectedDate,
      dateLabel: compactDateLabel(_selectedDate, DateTime.now()),
    );
  }

  String _monthTitle(DateTime date) {
    const months = [
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
    return months[date.month - 1];
  }
}

class _WeekStrip extends StatelessWidget {
  const _WeekStrip({required this.selectedDate, required this.onSelected});

  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    final today = dateOnly(DateTime.now());
    final start = today.subtract(Duration(days: today.weekday % 7));
    return SizedBox(
      height: 64,
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
                today: isSameLocalDate(today, start.add(Duration(days: index))),
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
    required this.onTap,
  });

  final DateTime date;
  final bool selected;
  final bool today;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: SizedBox(
        height: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weekdays[date.weekday % 7],
              style: TextStyle(
                color: selected ? colors.primary : colors.textMuted,
                fontWeight: FontWeight.w700,
                fontSize: 13,
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarAddRow extends StatelessWidget {
  const _CalendarAddRow({required this.date, required this.onTap});

  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(Icons.add_box_outlined, color: colors.icon, size: 23),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Add task',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.text,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              compactDateLabel(date, DateTime.now()),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: colors.textMuted, fontSize: 14.5),
            ),
          ],
        ),
      ),
    );
  }
}
