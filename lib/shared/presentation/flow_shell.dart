import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
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
        width: 64,
        height: 64,
        margin: const EdgeInsets.only(right: 6, bottom: 58),
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
          onPressed: () => showQuickAddSheet(context),
          child: const Icon(Icons.add_rounded, size: 38),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        height: 88 + MediaQuery.paddingOf(context).bottom,
        color: colors.bg,
        padding: EdgeInsets.only(
          left: 42,
          right: 42,
          bottom: MediaQuery.paddingOf(context).bottom + 8,
          top: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              icon: Icons.hexagon_rounded,
              active: _isActive('/lists') || _isActive('/settings'),
              tooltip: 'Lists',
              onPressed: () => context.go('/lists'),
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
      width: 56,
      height: 56,
      child: IconButton(
        tooltip: tooltip,
        iconSize: active ? 34 : 32,
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
    final todayCount = ref.watch(todayTasksProvider).valueOrNull?.length ?? 0;
    final inboxCount = ref.watch(inboxOpenCountProvider).valueOrNull ?? 0;
    final currentPath = GoRouterState.of(context).uri.path;

    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.86,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 18),
          child: Column(
            children: [
              Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: colors.primary,
                        child: Text(
                          'A',
                          style: TextStyle(
                            color: colors.textStrong,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Positioned(
                        top: -4,
                        right: -7,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: Color(0xFFD9D9D9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.workspace_premium_rounded,
                            color: colors.surface,
                            size: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      'Abhirham Savarap',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.textStrong,
                        fontWeight: FontWeight.w700,
                        fontSize: 25,
                        height: 1.2,
                      ),
                    ),
                  ),
                  Icon(Icons.search_rounded, color: colors.icon, size: 32),
                  const SizedBox(width: 22),
                  Icon(
                    Icons.notifications_none_rounded,
                    color: colors.icon,
                    size: 32,
                  ),
                  const SizedBox(width: 22),
                  Icon(Icons.hexagon_outlined, color: colors.icon, size: 32),
                ],
              ),
              const SizedBox(height: 48),
              _DrawerItem(
                icon: Icons.calendar_month_rounded,
                label: 'Today',
                count: todayCount,
                active: currentPath == '/today',
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
                icon: Icons.subject_rounded,
                label: 'today only',
                count: 1,
                active: false,
                blueIcon: true,
                onTap: () => _go(context, '/lists'),
              ),
              _DrawerItem(
                icon: Icons.menu_rounded,
                label: 'Skin care',
                count: 3,
                active: false,
                onTap: () => _go(context, '/lists'),
              ),
              _DrawerItem(
                icon: Icons.menu_rounded,
                label: 'Utilities',
                count: 6,
                active: false,
                onTap: () => _go(context, '/lists'),
              ),
              _DrawerItem(
                icon: Icons.menu_rounded,
                label: 'Bank',
                count: 9,
                active: false,
                onTap: () => _go(context, '/lists'),
              ),
              const Spacer(),
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
                    icon: Icon(Icons.manage_search_rounded, color: colors.icon),
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
    this.blueIcon = false,
  });

  final IconData icon;
  final String label;
  final int count;
  final bool active;
  final VoidCallback onTap;
  final bool blueIcon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: active ? colors.surfaceSelected : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: active || blueIcon ? colors.primary : colors.icon,
                size: 28,
              ),
              const SizedBox(width: 20),
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
