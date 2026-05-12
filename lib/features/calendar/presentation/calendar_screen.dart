import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../core/time/flow_date_utils.dart';
import '../../tasks/application/task_providers.dart';
import '../../tasks/domain/task_draft.dart';
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
            title: 'Calendar',
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
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primaryBright,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _createTaskForSelectedDate,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Create Task on Date'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createTaskForSelectedDate() async {
    final controller = TextEditingController();
    final title = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final colors = context.colors;
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            28,
            16,
            MediaQuery.viewInsetsOf(context).bottom + 24,
          ),
          child: TextField(
            controller: controller,
            autofocus: true,
            cursorColor: colors.primary,
            style: TextStyle(color: colors.textStrong, fontSize: 28),
            decoration: const InputDecoration(
              hintText: 'What would you like to do?',
            ),
            onSubmitted: (value) => Navigator.of(context).pop(value),
          ),
        );
      },
    );
    controller.dispose();
    if (title == null || title.trim().isEmpty) {
      return;
    }
    await ref
        .read(taskRepositoryProvider)
        .createTask(TaskDraft(title: title, dueDate: _selectedDate));
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
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(12),
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
    required this.onTap,
  });

  final DateTime date;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        height: 64,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: selected ? colors.surfaceSelected : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              weekdays[date.weekday % 7],
              style: TextStyle(
                color: selected ? colors.primary : colors.textMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${date.day}',
              style: TextStyle(
                color: selected ? colors.textStrong : colors.text,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
