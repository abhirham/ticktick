import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../features/tasks/application/task_providers.dart';

class FlowShell extends ConsumerWidget {
  const FlowShell({required this.location, required this.child, super.key});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final isAdd = location == '/add';

    return Scaffold(
      backgroundColor: colors.bg,
      drawer: const FlowDrawer(),
      body: child,
      floatingActionButton: isAdd
          ? null
          : Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withValues(alpha: 0.28),
                    blurRadius: 28,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: FloatingActionButton(
                heroTag: 'add-task',
                tooltip: 'Add task',
                backgroundColor: colors.primaryBright,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: const CircleBorder(),
                onPressed: () => context.go('/add'),
                child: const Icon(Icons.add_rounded, size: 34),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        color: colors.bg,
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          bottom: MediaQuery.paddingOf(context).bottom + 8,
          top: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BottomNavIcon(
              icon: Icons.check_box_rounded,
              active: _isActive('/today'),
              tooltip: 'Today',
              onPressed: () => context.go('/today'),
            ),
            _BottomNavIcon(
              icon: Icons.calendar_today_rounded,
              active: _isActive('/calendar'),
              tooltip: 'Calendar',
              onPressed: () => context.go('/calendar'),
            ),
            _BottomNavIcon(
              icon: Icons.view_list_rounded,
              active: _isActive('/lists'),
              tooltip: 'Lists',
              onPressed: () => context.go('/lists'),
            ),
            _BottomNavIcon(
              icon: Icons.add_circle_outline_rounded,
              active: _isActive('/add'),
              tooltip: 'Add Task',
              onPressed: () => context.go('/add'),
            ),
            _BottomNavIcon(
              icon: Icons.settings_outlined,
              active: _isActive('/settings'),
              tooltip: 'Settings',
              onPressed: () => context.go('/settings'),
            ),
          ],
        ),
      ),
    );
  }

  bool _isActive(String path) {
    if (path == '/lists') {
      return location == '/lists' ||
          location == '/all' ||
          location == '/completed' ||
          location == '/trash';
    }
    return location == path;
  }
}

class _BottomNavIcon extends StatelessWidget {
  const _BottomNavIcon({
    required this.icon,
    required this.active,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final bool active;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return IconButton(
      tooltip: tooltip,
      iconSize: 30,
      onPressed: onPressed,
      color: active ? colors.primary : colors.iconMuted,
      icon: Icon(icon),
    );
  }
}

class FlowDrawer extends ConsumerWidget {
  const FlowDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final lists = ref.watch(taskListsProvider).valueOrNull ?? const [];
    final todayCount = ref.watch(todayTasksProvider).valueOrNull?.length ?? 0;
    final inboxCount = ref.watch(inboxOpenCountProvider).valueOrNull ?? 0;
    final openCount = ref.watch(openTaskCountProvider).valueOrNull ?? 0;
    final completedCount =
        ref.watch(completedTaskCountProvider).valueOrNull ?? 0;
    final trashCount = ref.watch(trashTaskCountProvider).valueOrNull ?? 0;

    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.86,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: colors.primary,
                    child: Text(
                      'F',
                      style: TextStyle(
                        color: colors.textStrong,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'FlowTask',
                      style: TextStyle(
                        color: colors.textStrong,
                        fontWeight: FontWeight.w700,
                        fontSize: 25,
                        height: 1.2,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Settings',
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.go('/settings');
                    },
                    icon: Icon(Icons.settings_outlined, color: colors.icon),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              _DrawerItem(
                icon: Icons.calendar_today_rounded,
                label: 'Today',
                count: todayCount,
                active: GoRouterState.of(context).uri.path == '/today',
                onTap: () => _go(context, '/today'),
              ),
              _DrawerItem(
                icon: Icons.inbox_outlined,
                label: 'Inbox',
                count: inboxCount,
                active: false,
                onTap: () => _go(context, '/all'),
              ),
              _DrawerItem(
                icon: Icons.checklist_rounded,
                label: 'All Tasks',
                count: openCount,
                active: GoRouterState.of(context).uri.path == '/all',
                onTap: () => _go(context, '/all'),
              ),
              _DrawerItem(
                icon: Icons.check_circle_outline_rounded,
                label: 'Completed',
                count: completedCount,
                active: GoRouterState.of(context).uri.path == '/completed',
                onTap: () => _go(context, '/completed'),
              ),
              _DrawerItem(
                icon: Icons.delete_outline_rounded,
                label: 'Trash',
                count: trashCount,
                active: GoRouterState.of(context).uri.path == '/trash',
                onTap: () => _go(context, '/trash'),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    for (final list in lists)
                      if (list.id != 'inbox')
                        _DrawerItem(
                          icon: Icons.list_alt_rounded,
                          label: list.name,
                          count: 0,
                          active: false,
                          onTap: () => _go(context, '/lists'),
                        ),
                  ],
                ),
              ),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => _go(context, '/lists'),
                    icon: const Icon(Icons.add_box_outlined),
                    label: const Text('Add'),
                    style: TextButton.styleFrom(
                      foregroundColor: colors.text,
                      textStyle: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Manage lists',
                    onPressed: () => _go(context, '/lists'),
                    icon: Icon(Icons.tune_rounded, color: colors.icon),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _go(BuildContext context, String path) {
    Navigator.of(context).pop();
    context.go(path);
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.count,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final int count;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: active ? colors.surfaceSelected : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: active ? colors.primary : colors.icon,
                size: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
            ],
          ),
        ),
      ),
    );
  }
}
