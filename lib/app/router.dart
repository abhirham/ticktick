import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/calendar/presentation/calendar_screen.dart';
import '../features/lists/presentation/lists_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/tasks/presentation/screens/add_task_screen.dart';
import '../features/tasks/presentation/screens/natural_language_debug_screen.dart';
import '../features/tasks/presentation/screens/task_collection_screen.dart';
import '../features/tasks/presentation/screens/task_detail_screen.dart';
import '../features/tasks/presentation/screens/today_screen.dart';
import '../shared/presentation/flow_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/today',
    redirect: (context, state) {
      final uri = state.uri;
      if (uri.scheme != 'flowtask') {
        return null;
      }
      return _flowTaskRouteForDeepLink(uri);
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return FlowShell(location: state.uri.path, child: child);
        },
        routes: [
          GoRoute(
            path: '/today',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: TodayScreen()),
          ),
          GoRoute(
            path: '/calendar',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: CalendarScreen()),
          ),
          GoRoute(
            path: '/lists',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ListsScreen()),
          ),
          GoRoute(
            path: '/add',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AddTaskScreen()),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SettingsScreen()),
          ),
          GoRoute(
            path: '/natural-language-debug',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: NaturalLanguageDebugScreen()),
          ),
          GoRoute(
            path: '/all',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AllTasksScreen()),
          ),
          GoRoute(
            path: '/completed',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: CompletedScreen()),
          ),
          GoRoute(
            path: '/trash',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: TrashScreen()),
          ),
          GoRoute(
            path: '/task/:id',
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: TaskDetailScreen(taskId: state.pathParameters['id']!),
              );
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const TodayScreen(),
  );
});

String? _flowTaskRouteForDeepLink(Uri uri) {
  if (uri.host == 'today' || uri.path == '/today') {
    return '/today';
  }
  if (uri.host == 'add' || uri.path == '/add') {
    return '/add';
  }
  if (uri.host == 'calendar' || uri.path == '/calendar') {
    return '/calendar';
  }
  if (uri.host == 'task') {
    final taskId = uri.pathSegments.isEmpty ? null : uri.pathSegments.first;
    return taskId == null || taskId.isEmpty ? '/today' : '/task/$taskId';
  }
  if (uri.pathSegments.length >= 2 && uri.pathSegments.first == 'task') {
    return '/task/${uri.pathSegments[1]}';
  }
  return '/today';
}
