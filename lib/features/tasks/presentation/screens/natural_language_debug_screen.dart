import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme.dart';
import '../../../../core/time/flow_date_utils.dart';
import '../../domain/natural_language_task_parser.dart';
import '../../domain/task_enums.dart';
import '../widgets/task_widgets.dart';

class NaturalLanguageDebugScreen extends StatefulWidget {
  const NaturalLanguageDebugScreen({super.key});

  @override
  State<NaturalLanguageDebugScreen> createState() =>
      _NaturalLanguageDebugScreenState();
}

class _NaturalLanguageDebugScreenState
    extends State<NaturalLanguageDebugScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final parsed = NaturalLanguageTaskParser.parse(
      _controller.text,
      DateTime.now(),
    );
    return ColoredBox(
      color: colors.bg,
      child: Column(
        children: [
          FlowTaskPageHeader(
            title: 'NL Debug',
            leading: FlowIconButton(
              icon: Icons.arrow_back_rounded,
              tooltip: 'Back',
              onPressed: () => context.go('/settings'),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 112),
              children: [
                _DebugPanel(
                  title: 'Input',
                  children: [
                    TextField(
                      controller: _controller,
                      autofocus: true,
                      cursorColor: colors.primary,
                      minLines: 1,
                      maxLines: 4,
                      style: TextStyle(color: colors.textStrong, fontSize: 17),
                      decoration: const InputDecoration(
                        hintText: 'Raw task input',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isCollapsed: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _DebugPanel(
                  title: 'Parsed',
                  children: [
                    _DebugRow(label: 'Raw input', value: parsed.originalInput),
                    _DebugRow(label: 'Cleaned title', value: parsed.title),
                    _DebugRow(
                      label: 'Due date',
                      value: _dateValue(parsed.dueDate),
                    ),
                    _DebugRow(label: 'Due time', value: parsed.dueTime),
                    _DebugRow(
                      label: 'Start date',
                      value: _dateValue(parsed.startDate),
                    ),
                    _DebugRow(label: 'Start time', value: parsed.startTime),
                    _DebugRow(
                      label: 'Priority',
                      value: parsed.priority == TaskPriority.none
                          ? null
                          : parsed.priority.label,
                    ),
                    _DebugRow(label: 'List', value: parsed.listName),
                    _DebugRow(label: 'Group', value: parsed.groupName),
                    _DebugRow(
                      label: 'Repeat',
                      value: _repeatValue(parsed.recurrence),
                    ),
                    _DebugRow(
                      label: 'Reminder',
                      value: _reminderValue(parsed.reminder),
                    ),
                    _DebugRow(
                      label: 'Persistent',
                      value: parsed.isPersistent ? 'Yes' : 'No',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _DebugPanel(
                  title: 'Warnings',
                  children: parsed.warnings.isEmpty
                      ? const [_DebugMessage('No warnings')]
                      : [
                          for (final warning in parsed.warnings)
                            _DebugRow(
                              label: warning.code.name,
                              value: warning.message,
                              danger: true,
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

class _DebugPanel extends StatelessWidget {
  const _DebugPanel({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colors.text,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _DebugRow extends StatelessWidget {
  const _DebugRow({
    required this.label,
    required this.value,
    this.danger = false,
  });

  final String label;
  final String? value;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 112,
            child: Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colors.textMuted,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value == null || value!.isEmpty ? '-' : value!,
              style: TextStyle(
                color: danger ? colors.danger : colors.text,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DebugMessage extends StatelessWidget {
  const _DebugMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        message,
        style: TextStyle(
          color: context.colors.textMuted,
          fontSize: 15,
          height: 1.3,
        ),
      ),
    );
  }
}

String? _dateValue(DateTime? date) {
  if (date == null) {
    return null;
  }
  return taskListDateLabel(date, DateTime.now());
}

String? _repeatValue(ParsedRecurrence? recurrence) {
  if (recurrence == null) {
    return null;
  }
  final weekdays = recurrence.weekdays.isEmpty
      ? ''
      : ' on ${recurrence.weekdays.join(',')}';
  return '${recurrence.frequency.name} every ${recurrence.interval}$weekdays';
}

String? _reminderValue(ParsedReminder? reminder) {
  if (reminder == null) {
    return null;
  }
  return switch (reminder.kind) {
    ReminderKind.absolute => reminder.remindAt?.toIso8601String(),
    ReminderKind.relative => '${reminder.offsetMinutes} minutes before',
  };
}
