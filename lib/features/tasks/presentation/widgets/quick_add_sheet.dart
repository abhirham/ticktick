import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../app/theme.dart';
import '../../../../core/time/flow_date_utils.dart';
import '../../../../shared/presentation/flow_bottom_sheet.dart';
import '../../domain/task_draft.dart';

Future<void> showQuickAddSheet(
  BuildContext context, {
  DateTime? initialDueDate,
  String? dateLabel,
}) {
  return showFlowBottomSheet<void>(
    context: context,
    builder: (context) =>
        QuickAddSheet(initialDueDate: initialDueDate, dateLabel: dateLabel),
  );
}

class QuickAddSheet extends ConsumerStatefulWidget {
  const QuickAddSheet({this.initialDueDate, this.dateLabel, super.key});

  final DateTime? initialDueDate;
  final String? dateLabel;

  @override
  ConsumerState<QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends ConsumerState<QuickAddSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dueDate = dateOnly(widget.initialDueDate ?? DateTime.now());
    final label = widget.dateLabel ?? compactDateLabel(dueDate, DateTime.now());
    return FlowBottomSheetSurface(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            autofocus: true,
            cursorColor: colors.primary,
            maxLines: 1,
            style: TextStyle(
              color: colors.textStrong,
              fontSize: 20.5,
              fontWeight: FontWeight.w400,
              height: 1.25,
            ),
            decoration: const InputDecoration(
              hintText: 'What would you like to do?',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              isCollapsed: true,
              contentPadding: EdgeInsets.zero,
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _descriptionController,
            cursorColor: colors.primary,
            maxLines: 1,
            style: TextStyle(
              color: colors.text,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              height: 1.25,
            ),
            decoration: const InputDecoration(
              hintText: 'Description',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              isCollapsed: true,
              contentPadding: EdgeInsets.zero,
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 108),
                child: _ToolbarAction(
                  icon: Icons.calendar_month_outlined,
                  label: label,
                  active: true,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 4),
              _ToolbarIcon(icon: Icons.flag_outlined, onTap: () {}),
              _ToolbarIcon(icon: Icons.local_offer_outlined, onTap: () {}),
              _ToolbarIcon(icon: Icons.inbox_outlined, onTap: () {}),
              _ToolbarIcon(icon: Icons.more_horiz_rounded, onTap: () {}),
              const Spacer(),
              _ToolbarIcon(icon: Icons.mic_none_rounded, onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      return;
    }
    await ref
        .read(taskRepositoryProvider)
        .createTask(
          TaskDraft(
            title: title,
            description: _descriptionController.text,
            dueDate: dateOnly(widget.initialDueDate ?? DateTime.now()),
          ),
        );
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}

class _ToolbarAction extends StatelessWidget {
  const _ToolbarAction({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = active ? colors.primary : colors.iconMuted;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 44,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolbarIcon extends StatelessWidget {
  const _ToolbarIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 44,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Icon(icon, color: context.colors.iconMuted, size: 24),
      ),
    );
  }
}
