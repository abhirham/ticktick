import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../tasks/application/task_providers.dart';
import '../../tasks/presentation/widgets/task_widgets.dart';

class ListsScreen extends ConsumerWidget {
  const ListsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final inboxCount = ref.watch(inboxOpenCountProvider).valueOrNull ?? 0;
    final openCount = ref.watch(openTaskCountProvider).valueOrNull ?? 0;
    final completedCount =
        ref.watch(completedTaskCountProvider).valueOrNull ?? 0;
    final trashCount = ref.watch(trashTaskCountProvider).valueOrNull ?? 0;
    final lists = ref.watch(taskListsProvider);

    return ColoredBox(
      color: colors.bg,
      child: Column(
        children: [
          FlowTaskPageHeader(
            title: 'Lists',
            leading: FlowIconButton(
              icon: Icons.menu_rounded,
              tooltip: 'Open navigation',
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
            actions: [
              FlowIconButton(
                icon: Icons.add_box_outlined,
                tooltip: 'List creation arrives in Phase 2',
                onPressed: null,
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 112),
              children: [
                _ListPanel(
                  title: 'Smart Views',
                  children: [
                    _ListTileRow(
                      icon: Icons.checklist_rounded,
                      label: 'All Tasks',
                      count: openCount,
                      onTap: () => context.go('/all'),
                    ),
                    _ListTileRow(
                      icon: Icons.check_circle_outline_rounded,
                      label: 'Completed',
                      count: completedCount,
                      onTap: () => context.go('/completed'),
                    ),
                    _ListTileRow(
                      icon: Icons.delete_outline_rounded,
                      label: 'Trash',
                      count: trashCount,
                      onTap: () => context.go('/trash'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _ListPanel(
                  title: 'Lists',
                  children: [
                    _ListTileRow(
                      icon: Icons.inbox_outlined,
                      label: 'Inbox',
                      count: inboxCount,
                      onTap: () => context.go('/all'),
                    ),
                    lists.when(
                      data: (items) => Column(
                        children: [
                          for (final list in items)
                            if (list.id != 'inbox')
                              _ListTileRow(
                                icon: Icons.list_alt_rounded,
                                label: list.name,
                                count: 0,
                                onTap: () => context.go('/all'),
                              ),
                        ],
                      ),
                      loading: () => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Loading lists...',
                          style: TextStyle(
                            color: colors.textMuted,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      error: (error, _) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          '$error',
                          style: TextStyle(color: colors.danger, fontSize: 18),
                        ),
                      ),
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

class _ListPanel extends StatelessWidget {
  const _ListPanel({required this.title, required this.children});

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
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colors.text,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _ListTileRow extends StatelessWidget {
  const _ListTileRow({
    required this.icon,
    required this.label,
    required this.count,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: SizedBox(
        height: 62,
        child: Row(
          children: [
            Icon(icon, color: colors.icon, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: colors.text,
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              '$count',
              style: TextStyle(color: colors.textMuted, fontSize: 22),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded, color: colors.textMuted),
          ],
        ),
      ),
    );
  }
}
