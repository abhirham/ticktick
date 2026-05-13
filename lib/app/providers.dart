import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/app_database.dart';
import '../features/reminders/data/reminder_notification_service.dart';
import '../features/tasks/data/task_repository.dart';
import '../features/widget/data/native_widget_bridge.dart';
import '../features/widget/data/widget_data_service.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final widgetDataServiceProvider = Provider<WidgetDataService>((ref) {
  return WidgetDataService(
    ref.watch(appDatabaseProvider),
    nativeBridge: const NativeWidgetBridge(),
  );
});

final reminderNotificationServiceProvider =
    Provider<ReminderNotificationService>((ref) {
      return ReminderNotificationService();
    });

final notificationStatusProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(reminderNotificationServiceProvider).checkStatus();
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final widgetDataService = ref.watch(widgetDataServiceProvider);
  return TaskRepository(
    ref.watch(appDatabaseProvider),
    reminderScheduler: ref.watch(reminderNotificationServiceProvider),
    widgetSnapshotRefresher: () async {
      await widgetDataService.refreshTodaySnapshot();
    },
  );
});
