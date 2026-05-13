import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/time/flow_date_utils.dart';
import 'flow_bottom_sheet.dart';

Future<DateTime?> showFlowDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) {
  return showFlowBottomSheet<DateTime>(
    context: context,
    builder: (context) => _FlowDatePickerSheet(
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    ),
  );
}

class _FlowDatePickerSheet extends StatefulWidget {
  const _FlowDatePickerSheet({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<_FlowDatePickerSheet> createState() => _FlowDatePickerSheetState();
}

class _FlowDatePickerSheetState extends State<_FlowDatePickerSheet> {
  late final DateTime _first = dateOnly(widget.firstDate);
  late final DateTime _last = dateOnly(widget.lastDate);
  late DateTime _selected = _clampDate(
    dateOnly(widget.initialDate),
    _first,
    _last,
  );
  late DateTime _visibleMonth = DateTime(_selected.year, _selected.month);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final today = dateOnly(DateTime.now());
    final todayEnabled = _isInRange(today);

    return FlowBottomSheetSurface(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pick date',
            style: TextStyle(
              color: colors.textStrong,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _fullDateLabel(_selected, today),
            style: TextStyle(
              color: colors.textMuted,
              fontSize: 14.5,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _PickerIconButton(
                icon: Icons.chevron_left_rounded,
                tooltip: 'Previous month',
                onPressed: _monthIntersectsRange(_shiftedMonth(-1))
                    ? () => _showMonth(-1)
                    : null,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '${_monthName(_visibleMonth.month)} ${_visibleMonth.year}',
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
              _PickerIconButton(
                icon: Icons.chevron_right_rounded,
                tooltip: 'Next month',
                onPressed: _monthIntersectsRange(_shiftedMonth(1))
                    ? () => _showMonth(1)
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (final label in const ['S', 'M', 'T', 'W', 'T', 'F', 'S'])
                Expanded(
                  child: Center(
                    child: Text(
                      label,
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
          const SizedBox(height: 6),
          GridView.builder(
            itemCount: 42,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisExtent: 42,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              final day = _monthGridStart().add(Duration(days: index));
              return _DayButton(
                date: day,
                selected: isSameLocalDate(day, _selected),
                today: isSameLocalDate(day, today),
                currentMonth: day.month == _visibleMonth.month,
                enabled: _isInRange(day),
                onTap: () => setState(() => _selected = dateOnly(day)),
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _PickerTextAction(
                label: 'Cancel',
                onTap: () => Navigator.of(context).pop(),
              ),
              const Spacer(),
              _PickerTextAction(
                label: 'Today',
                onTap: todayEnabled
                    ? () {
                        setState(() {
                          _selected = today;
                          _visibleMonth = DateTime(today.year, today.month);
                        });
                      }
                    : null,
              ),
              const SizedBox(width: 10),
              _PickerFilledAction(
                label: 'Done',
                onTap: () => Navigator.of(context).pop(_selected),
              ),
            ],
          ),
        ],
      ),
    );
  }

  DateTime _shiftedMonth(int delta) {
    return DateTime(_visibleMonth.year, _visibleMonth.month + delta);
  }

  void _showMonth(int delta) {
    final next = _shiftedMonth(delta);
    if (_monthIntersectsRange(next)) {
      setState(() => _visibleMonth = next);
    }
  }

  DateTime _monthGridStart() {
    final firstOfMonth = DateTime(_visibleMonth.year, _visibleMonth.month);
    return firstOfMonth.subtract(Duration(days: firstOfMonth.weekday % 7));
  }

  bool _isInRange(DateTime date) {
    final day = dateOnly(date);
    return !day.isBefore(_first) && !day.isAfter(_last);
  }

  bool _monthIntersectsRange(DateTime month) {
    final start = DateTime(month.year, month.month);
    final end = DateTime(month.year, month.month + 1, 0);
    return !end.isBefore(_first) && !start.isAfter(_last);
  }
}

class _DayButton extends StatelessWidget {
  const _DayButton({
    required this.date,
    required this.selected,
    required this.today,
    required this.currentMonth,
    required this.enabled,
    required this.onTap,
  });

  final DateTime date;
  final bool selected;
  final bool today;
  final bool currentMonth;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = !enabled
        ? colors.textSubtle.withValues(alpha: 0.55)
        : selected
        ? colors.textStrong
        : currentMonth
        ? colors.text
        : colors.textSubtle;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(999),
      child: Center(
        child: Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? colors.primary : Colors.transparent,
            shape: BoxShape.circle,
            border: today && !selected
                ? Border.all(color: colors.primary, width: 1.2)
                : null,
          ),
          child: Text(
            '${date.day}',
            style: TextStyle(
              color: foreground,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _PickerIconButton extends StatelessWidget {
  const _PickerIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox.square(
      dimension: 42,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        color: onPressed == null ? colors.textSubtle : colors.icon,
        iconSize: 26,
        icon: Icon(icon),
      ),
    );
  }
}

class _PickerTextAction extends StatelessWidget {
  const _PickerTextAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Text(
          label,
          style: TextStyle(
            color: onTap == null ? colors.textSubtle : colors.primary,
            fontSize: 15.5,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}

class _PickerFilledAction extends StatelessWidget {
  const _PickerFilledAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 40,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: colors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: colors.textStrong,
            fontSize: 15.5,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}

DateTime _clampDate(DateTime date, DateTime first, DateTime last) {
  if (date.isBefore(first)) {
    return first;
  }
  if (date.isAfter(last)) {
    return last;
  }
  return date;
}

String _fullDateLabel(DateTime date, DateTime today) {
  final relative = compactDateLabel(date, today);
  if (relative == 'Today' || relative == 'Tomorrow') {
    return relative;
  }
  return '${_weekdayName(date.weekday)}, ${_monthName(date.month)} ${date.day}, ${date.year}';
}

String _weekdayName(int weekday) {
  const names = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  return names[weekday - 1];
}

String _monthName(int month) {
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
