import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as timezone_data;
import 'package:timezone/timezone.dart' as timezone;

import '../../../core/time/flow_date_utils.dart';
import '../../../data/local/app_database.dart';

abstract class TaskReminderScheduler {
  Future<void> scheduleTaskReminders(
    TaskItem task,
    List<ReminderEntry> reminders,
  );

  Future<void> cancelTaskReminders(
    String taskId, {
    List<ReminderEntry> reminders = const [],
  });

  Future<void> snoozeTaskReminder(TaskItem task, Duration duration);
}

class FlowNotificationStatus {
  const FlowNotificationStatus({
    required this.notificationsEnabled,
    required this.exactAlarmsEnabled,
  });

  final bool? notificationsEnabled;
  final bool? exactAlarmsEnabled;

  String get label {
    final notificationLabel = notificationsEnabled == null
        ? 'Unknown'
        : notificationsEnabled!
        ? 'Allowed'
        : 'Blocked';
    final exactLabel = exactAlarmsEnabled == null
        ? 'inexact alarms'
        : exactAlarmsEnabled!
        ? 'exact alarms'
        : 'inexact alarms';
    return '$notificationLabel, $exactLabel';
  }
}

class FlowNotificationResponse {
  const FlowNotificationResponse({
    required this.action,
    required this.taskId,
    this.reminderId,
  });

  final String action;
  final String taskId;
  final String? reminderId;
}

typedef FlowNotificationResponseHandler =
    Future<void> Function(FlowNotificationResponse response);

class ReminderNotificationService implements TaskReminderScheduler {
  ReminderNotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const actionOpen = 'flowtask_open_task';
  static const actionComplete = 'flowtask_complete_task';
  static const actionSnooze10 = 'flowtask_snooze_10';
  static const notificationCategory = 'flowtask_task_reminder';
  static const channelId = 'flowtask_task_reminders';
  static const channelName = 'Task reminders';
  static const channelDescription = 'Alerts for FlowTask task reminders.';

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  Future<void> initialize({FlowNotificationResponseHandler? onResponse}) async {
    if (_initialized) {
      return;
    }
    timezone_data.initializeTimeZones();

    await _plugin.initialize(
      settings: InitializationSettings(
        android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestSoundPermission: false,
          requestBadgePermission: false,
          notificationCategories: [
            DarwinNotificationCategory(
              notificationCategory,
              actions: [
                DarwinNotificationAction.plain(
                  actionComplete,
                  'Complete',
                  options: {DarwinNotificationActionOption.foreground},
                ),
                DarwinNotificationAction.plain(
                  actionSnooze10,
                  'Snooze 10 min',
                  options: {DarwinNotificationActionOption.foreground},
                ),
                DarwinNotificationAction.plain(
                  actionOpen,
                  'Open',
                  options: {DarwinNotificationActionOption.foreground},
                ),
              ],
            ),
          ],
        ),
      ),
      onDidReceiveNotificationResponse: (response) {
        final parsed = _parseResponse(response);
        if (parsed != null && onResponse != null) {
          unawaited(onResponse(parsed));
        }
      },
    );
    _initialized = true;
  }

  Future<FlowNotificationStatus> checkStatus() async {
    await initialize();
    bool? notificationsEnabled;
    bool? exactAlarmsEnabled;

    try {
      notificationsEnabled = await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.areNotificationsEnabled();
      exactAlarmsEnabled = await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.canScheduleExactNotifications();
      final iosStatus = await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.checkPermissions();
      notificationsEnabled ??= iosStatus?.isEnabled;
      final macStatus = await _plugin
          .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin
          >()
          ?.checkPermissions();
      notificationsEnabled ??= macStatus?.isEnabled;
    } catch (_) {}

    return FlowNotificationStatus(
      notificationsEnabled: notificationsEnabled,
      exactAlarmsEnabled: exactAlarmsEnabled,
    );
  }

  Future<FlowNotificationStatus> requestPermissions() async {
    await initialize();
    try {
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestExactAlarmsPermission();
      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, sound: true, badge: true);
      await _plugin
          .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, sound: true, badge: true);
    } catch (_) {
      // Permission APIs are platform-channel backed and can be absent in tests.
    }
    return checkStatus();
  }

  Future<void> showTestNotification() async {
    await initialize();
    final scheduled = DateTime.now().add(const Duration(seconds: 5));
    await _schedule(
      id: _stableNotificationId('flowtask-test-notification'),
      title: 'FlowTask test',
      body: 'Reminder notifications are ready.',
      scheduledAt: scheduled,
      payload: _payload(actionOpen, 'test'),
    );
  }

  @override
  Future<void> scheduleTaskReminders(
    TaskItem task,
    List<ReminderEntry> reminders,
  ) async {
    await initialize();
    await cancelTaskReminders(task.id, reminders: reminders);
    for (final reminder in reminders.where((reminder) => reminder.isEnabled)) {
      if (!reminder.remindAt.isAfter(DateTime.now())) {
        continue;
      }
      await _schedule(
        id: _notificationId(reminder),
        title: task.title,
        body: _notificationBody(task, reminder),
        scheduledAt: reminder.remindAt,
        payload: _payload(actionOpen, task.id, reminder.id),
      );
    }
  }

  @override
  Future<void> cancelTaskReminders(
    String taskId, {
    List<ReminderEntry> reminders = const [],
  }) async {
    await initialize();
    if (reminders.isEmpty) {
      return;
    }
    for (final reminder in reminders) {
      await _cancel(_notificationId(reminder));
    }
  }

  @override
  Future<void> snoozeTaskReminder(TaskItem task, Duration duration) async {
    await initialize();
    final scheduledAt = DateTime.now().add(duration);
    await _schedule(
      id: _stableNotificationId('${task.id}:snooze:${duration.inMinutes}'),
      title: task.title,
      body: 'Snoozed for ${duration.inMinutes} minutes.',
      scheduledAt: scheduledAt,
      payload: _payload(actionOpen, task.id),
    );
  }

  Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    required String payload,
  }) async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    final macos = _plugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >();
    if (android == null && ios == null && macos == null && kIsWeb) {
      return;
    }

    final exact = await android?.canScheduleExactNotifications();
    final scheduleMode = exact == false
        ? AndroidScheduleMode.inexactAllowWhileIdle
        : AndroidScheduleMode.exactAllowWhileIdle;
    final scheduledDate = timezone.TZDateTime.from(scheduledAt, timezone.local);

    try {
      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        androidScheduleMode: scheduleMode,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            channelDescription: channelDescription,
            importance: Importance.high,
            priority: Priority.high,
            category: AndroidNotificationCategory.reminder,
            actions: [
              AndroidNotificationAction(
                actionComplete,
                'Complete',
                showsUserInterface: true,
              ),
              AndroidNotificationAction(
                actionSnooze10,
                'Snooze 10 min',
                showsUserInterface: true,
              ),
              AndroidNotificationAction(
                actionOpen,
                'Open',
                showsUserInterface: true,
              ),
            ],
          ),
          iOS: DarwinNotificationDetails(
            categoryIdentifier: notificationCategory,
          ),
          macOS: DarwinNotificationDetails(
            categoryIdentifier: notificationCategory,
          ),
        ),
        payload: payload,
      );
    } catch (_) {
      if (scheduleMode == AndroidScheduleMode.inexactAllowWhileIdle) {
        return;
      }
      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            channelDescription: channelDescription,
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority,
            category: AndroidNotificationCategory.reminder,
          ),
          iOS: DarwinNotificationDetails(
            categoryIdentifier: notificationCategory,
          ),
          macOS: DarwinNotificationDetails(
            categoryIdentifier: notificationCategory,
          ),
        ),
        payload: payload,
      );
    }
  }

  Future<void> _cancel(int id) async {
    try {
      await _plugin.cancel(id: id);
    } catch (_) {
      // Unit tests and unsupported platforms may not have a registered plugin.
    }
  }

  String _notificationBody(TaskItem task, ReminderEntry reminder) {
    if (reminder.offsetMinutes == 0) {
      return 'Due now';
    }
    if (reminder.offsetMinutes != null && reminder.offsetMinutes! < 0) {
      final minutes = reminder.offsetMinutes!.abs();
      if (minutes >= 1440 && minutes % 1440 == 0) {
        return 'Due in ${minutes ~/ 1440} day${minutes == 1440 ? '' : 's'}';
      }
      if (minutes >= 60 && minutes % 60 == 0) {
        return 'Due in ${minutes ~/ 60} hour${minutes == 60 ? '' : 's'}';
      }
      return 'Due in $minutes minutes';
    }
    if (task.dueDate != null) {
      return 'Due ${compactDateLabel(task.dueDate!, DateTime.now())}';
    }
    return 'Task reminder';
  }

  int _notificationId(ReminderEntry reminder) {
    return _stableNotificationId(reminder.id);
  }

  int _stableNotificationId(String value) {
    var hash = 0x811c9dc5;
    for (final unit in value.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0x7fffffff;
    }
    return hash == 0 ? 1 : hash;
  }

  String _payload(String action, String taskId, [String? reminderId]) {
    return jsonEncode({
      'action': action,
      'taskId': taskId,
      if (reminderId != null) 'reminderId': reminderId,
    });
  }

  FlowNotificationResponse? _parseResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) {
      return null;
    }
    final decoded = jsonDecode(payload);
    if (decoded is! Map) {
      return null;
    }
    final taskId = decoded['taskId'];
    if (taskId is! String || taskId.isEmpty) {
      return null;
    }
    final payloadAction = decoded['action'];
    return FlowNotificationResponse(
      action:
          response.actionId ??
          (payloadAction is String ? payloadAction : actionOpen),
      taskId: taskId,
      reminderId: decoded['reminderId'] is String
          ? decoded['reminderId'] as String
          : null,
    );
  }
}
