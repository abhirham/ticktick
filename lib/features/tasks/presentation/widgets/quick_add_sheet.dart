import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers.dart';
import '../../../../app/theme.dart';
import '../../../../core/time/flow_date_utils.dart';
import '../../domain/task_draft.dart';

Future<void> showQuickAddSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: false,
    barrierColor: Colors.black.withValues(alpha: 0.82),
    backgroundColor: Colors.transparent,
    builder: (context) => const QuickAddSheet(),
  );
}

class QuickAddSheet extends ConsumerStatefulWidget {
  const QuickAddSheet({super.key});

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
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
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
        padding: const EdgeInsets.fromLTRB(16, 28, 16, 22),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                autofocus: true,
                cursorColor: colors.primary,
                style: TextStyle(
                  color: colors.textStrong,
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                ),
                decoration: const InputDecoration(
                  hintText: 'What would you like to do?',
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _save(),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _descriptionController,
                cursorColor: colors.primary,
                style: TextStyle(
                  color: colors.text,
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  height: 1.25,
                ),
                decoration: const InputDecoration(hintText: 'Description'),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _save(),
              ),
              const SizedBox(height: 44),
              Row(
                children: [
                  _ToolbarAction(
                    icon: Icons.calendar_month_outlined,
                    label: 'Today',
                    active: true,
                    onTap: () {},
                  ),
                  const SizedBox(width: 24),
                  _ToolbarIcon(icon: Icons.flag_outlined, onTap: () {}),
                  const SizedBox(width: 24),
                  _ToolbarIcon(icon: Icons.local_offer_outlined, onTap: () {}),
                  const SizedBox(width: 24),
                  _ToolbarIcon(icon: Icons.inbox_outlined, onTap: () {}),
                  const SizedBox(width: 24),
                  _ToolbarIcon(icon: Icons.more_horiz_rounded, onTap: () {}),
                  const Spacer(),
                  _ToolbarIcon(icon: Icons.mic_none_rounded, onTap: () {}),
                ],
              ),
            ],
          ),
        ),
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
            dueDate: dateOnly(DateTime.now()),
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
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Icon(icon, color: context.colors.iconMuted, size: 30),
    );
  }
}
