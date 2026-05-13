import 'package:flutter/material.dart';

import '../../../../app/theme.dart';
import '../../../../shared/presentation/flow_bottom_sheet.dart';
import '../../domain/task_enums.dart';

Future<TaskPriority?> showTaskPrioritySheet(
  BuildContext context, {
  required TaskPriority selectedPriority,
}) {
  return showFlowBottomSheet<TaskPriority>(
    context: context,
    builder: (context) => _PrioritySheet(selectedPriority: selectedPriority),
  );
}

class _PrioritySheet extends StatelessWidget {
  const _PrioritySheet({required this.selectedPriority});

  final TaskPriority selectedPriority;

  @override
  Widget build(BuildContext context) {
    return FlowBottomSheetSurface(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final priority in TaskPriority.values)
            _PriorityRow(
              priority: priority,
              selected: priority == selectedPriority,
              onTap: () => Navigator.of(context).pop(priority),
            ),
        ],
      ),
    );
  }
}

class _PriorityRow extends StatelessWidget {
  const _PriorityRow({
    required this.priority,
    required this.selected,
    required this.onTap,
  });

  final TaskPriority priority;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = selected ? colors.primary : colors.iconMuted;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            SizedBox(
              width: 44,
              child: Icon(Icons.flag_outlined, color: color, size: 23),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                priority.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colors.text,
                  fontSize: 16.5,
                  fontWeight: FontWeight.w400,
                  height: 1.25,
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
