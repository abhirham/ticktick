import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../features/lists/application/list_group_providers.dart';
import '../../features/tasks/application/task_providers.dart';
import '../../features/tasks/presentation/widgets/quick_add_sheet.dart';

class FlowShell extends ConsumerWidget {
  const FlowShell({required this.location, required this.child, super.key});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      drawer: const FlowDrawer(),
      body: child,
      floatingActionButton: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.only(right: 6, bottom: 10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: 0.28),
              blurRadius: 22,
              offset: const Offset(0, 7),
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
          onPressed: () => showQuickAddSheet(context),
          child: const Icon(Icons.add_rounded, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        height: 50 + MediaQuery.paddingOf(context).bottom,
        color: colors.bg,
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        child: Row(
          children: [
            Expanded(
              child: _BottomNavIcon(
                icon: Icons.check_box_rounded,
                active: _isActive('/today'),
                tooltip: 'Today',
                onPressed: () => context.go('/today'),
              ),
            ),
            Expanded(
              child: _BottomNavIcon(
                icon: Icons.calendar_today_rounded,
                active: _isActive('/calendar'),
                tooltip: 'Calendar',
                onPressed: () => context.go('/calendar'),
              ),
            ),
            Expanded(
              child: _BottomNavIcon(
                icon: Icons.hexagon_rounded,
                active: _isActive('/lists') || _isActive('/settings'),
                tooltip: 'Lists',
                onPressed: () => context.go('/lists'),
              ),
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
    return SizedBox(
      width: 50,
      height: 50,
      child: IconButton(
        tooltip: tooltip,
        iconSize: active ? 30 : 26,
        onPressed: onPressed,
        color: active ? colors.primary : colors.iconMuted,
        icon: Icon(icon),
      ),
    );
  }
}

class FlowDrawer extends ConsumerWidget {
  const FlowDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final routerState = GoRouterState.of(context);
    final currentPath = routerState.uri.path;
    final selectedListId = routerState.uri.queryParameters['list'];
    final todayCount = ref.watch(todayTasksProvider).valueOrNull?.length ?? 0;
    final openCount = ref.watch(openTaskCountProvider).valueOrNull ?? 0;
    final completedCount =
        ref.watch(completedTaskCountProvider).valueOrNull ?? 0;
    final trashCount = ref.watch(trashTaskCountProvider).valueOrNull ?? 0;
    final summariesAsync = ref.watch(listSummariesProvider);
    final summaries = summariesAsync.valueOrNull ?? const [];

    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.86,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 17,
                          backgroundColor: colors.primary,
                          child: Text(
                            'A',
                            style: TextStyle(
                              color: colors.textStrong,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Positioned(
                          top: -3,
                          right: -5,
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD9D9D9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.workspace_premium_rounded,
                              color: colors.surface,
                              size: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Abhirham Savarap',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colors.textStrong,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          height: 1.2,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Settings',
                      onPressed: () => _go(context, '/settings'),
                      color: currentPath == '/settings'
                          ? colors.primary
                          : colors.icon,
                      icon: const Icon(Icons.settings_outlined),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _DrawerItem(
                icon: Icons.calendar_month_rounded,
                label: 'Today',
                count: todayCount,
                active: currentPath == '/today',
                onTap: () => _go(context, '/today'),
              ),
              _DrawerItem(
                icon: Icons.calendar_today_rounded,
                label: 'Calendar',
                active: currentPath == '/calendar',
                blueIcon: true,
                onTap: () => _go(context, '/calendar'),
              ),
              _DrawerItem(
                icon: Icons.checklist_rounded,
                label: 'All Tasks',
                count: openCount,
                active: currentPath == '/all',
                blueIcon: true,
                onTap: () => _go(context, '/all'),
              ),
              _DrawerItem(
                icon: Icons.check_circle_outline_rounded,
                label: 'Completed',
                count: completedCount,
                active: currentPath == '/completed',
                onTap: () => _go(context, '/completed'),
              ),
              _DrawerItem(
                icon: Icons.delete_outline_rounded,
                label: 'Trash',
                count: trashCount,
                active: currentPath == '/trash',
                onTap: () => _go(context, '/trash'),
              ),
              _DrawerItem(
                icon: Icons.settings_outlined,
                label: 'Settings',
                active: currentPath == '/settings',
                onTap: () => _go(context, '/settings'),
              ),
              const SizedBox(height: 10),
              const _DrawerSectionLabel(label: 'Lists'),
              if (summariesAsync.isLoading)
                const _DrawerMessage(text: 'Loading lists...')
              else if (summaries.isEmpty)
                const _DrawerMessage(text: 'No lists yet.')
              else
                for (final summary in summaries)
                  _DrawerItem(
                    icon: summary.list.isSystemList
                        ? Icons.inbox_outlined
                        : Icons.menu_rounded,
                    iconColor: _colorFromHex(summary.list.color, colors.icon),
                    label: summary.list.name,
                    count: summary.openTaskCount,
                    active:
                        currentPath == '/lists' &&
                        selectedListId == summary.list.id,
                    onTap: () => _go(
                      context,
                      '/lists?list=${Uri.encodeComponent(summary.list.id)}',
                    ),
                  ),
              if (summariesAsync.hasError)
                const _DrawerMessage(text: 'Lists unavailable.', danger: true),
              _DrawerItem(
                icon: Icons.view_list_outlined,
                label: 'Manage Lists',
                active: currentPath == '/lists' && selectedListId == null,
                onTap: () => _go(context, '/lists'),
              ),
              const Spacer(),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => _openQuickAdd(context),
                    icon: const Icon(Icons.add_box_outlined),
                    label: const Text('Add Task'),
                    style: TextButton.styleFrom(
                      foregroundColor: colors.text,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Manage lists',
                    onPressed: () => _go(context, '/lists'),
                    icon: Icon(Icons.view_list_outlined, color: colors.icon),
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

  void _openQuickAdd(BuildContext context) {
    Navigator.of(context).pop();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        showQuickAddSheet(context);
      }
    });
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    this.count,
    this.blueIcon = false,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final int? count;
  final bool active;
  final VoidCallback onTap;
  final bool blueIcon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          decoration: BoxDecoration(
            color: active ? colors.surfaceSelected : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: active || blueIcon
                    ? colors.primary
                    : iconColor ?? colors.icon,
                size: 20,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (count != null)
                Text(
                  '$count',
                  style: TextStyle(color: colors.textMuted, fontSize: 14.5),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerSectionLabel extends StatelessWidget {
  const _DrawerSectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(13, 8, 13, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: TextStyle(
            color: colors.textMuted,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}

class _DrawerMessage extends StatelessWidget {
  const _DrawerMessage({required this.text, this.danger = false});

  final String text;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            color: danger ? colors.danger : colors.textMuted,
            fontSize: 14.5,
            height: 1.25,
          ),
        ),
      ),
    );
  }
}

Color _colorFromHex(String value, Color fallback) {
  final sanitized = value.replaceFirst('#', '');
  if (sanitized.length != 6) {
    return fallback;
  }
  final color = int.tryParse('FF$sanitized', radix: 16);
  return color == null ? fallback : Color(color);
}
