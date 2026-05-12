import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/calendar/presentation/calendar_screen.dart';
import '../features/lists/presentation/lists_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/tasks/presentation/screens/add_task_screen.dart';
import '../features/tasks/presentation/screens/task_collection_screen.dart';
import '../features/tasks/presentation/screens/task_detail_screen.dart';
import '../features/tasks/presentation/screens/today_screen.dart';
import '../shared/presentation/flow_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/today',
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
