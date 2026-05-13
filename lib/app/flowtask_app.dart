import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';
import '../features/reminders/data/reminder_notification_service.dart';
import '../features/settings/application/settings_providers.dart';
import 'router.dart';
import 'theme.dart';

class FlowTaskApp extends ConsumerStatefulWidget {
  const FlowTaskApp({super.key});

  @override
  ConsumerState<FlowTaskApp> createState() => _FlowTaskAppState();
}

class _FlowTaskAppState extends ConsumerState<FlowTaskApp> {
  @override
  void initState() {
    super.initState();
    Future.microtask(_initializeNotifications);
  }

  Future<void> _initializeNotifications() async {
    await ref.read(widgetDataServiceProvider).refreshTodaySnapshot();
    final notificationService = ref.read(reminderNotificationServiceProvider);
    await notificationService.initialize(onResponse: _handleNotification);
  }

  Future<void> _handleNotification(FlowNotificationResponse response) async {
    final repository = ref.read(taskRepositoryProvider);
    if (response.action == ReminderNotificationService.actionComplete) {
      await repository.completeTask(response.taskId);
      return;
    }
    if (response.action == ReminderNotificationService.actionSnooze10) {
      final task = await repository.readTask(response.taskId);
      if (task != null) {
        await ref
            .read(reminderNotificationServiceProvider)
            .snoozeTaskReminder(task, const Duration(minutes: 10));
      }
      return;
    }
    if (!mounted || response.taskId == 'test') {
      return;
    }
    ref.read(appRouterProvider).go('/task/${response.taskId}');
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(flowTaskThemeModeProvider);
    return MaterialApp.router(
      title: 'FlowTask',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: buildFlowTaskTheme(Brightness.light),
      darkTheme: buildFlowTaskTheme(Brightness.dark),
      routerConfig: router,
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: const _FlowTaskScrollBehavior(),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

class _FlowTaskScrollBehavior extends MaterialScrollBehavior {
  const _FlowTaskScrollBehavior();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
