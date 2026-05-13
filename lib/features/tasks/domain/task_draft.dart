import 'task_enums.dart';

class TaskDraft {
  const TaskDraft({
    required this.title,
    this.description,
    this.priority = TaskPriority.none,
    this.listId,
    this.groupId,
    this.dueDate,
    this.dueTime,
    this.startDate,
    this.startTime,
    this.timeZone = 'local',
    this.isAllDay = true,
    this.isPersistent = false,
    this.showInTodayUntilComplete = false,
    this.reminders = const [],
    this.repeatRule,
    this.originalInput,
    this.sortOrder = 0,
  });

  final String title;
  final String? description;
  final TaskPriority priority;
  final String? listId;
  final String? groupId;
  final DateTime? dueDate;
  final String? dueTime;
  final DateTime? startDate;
  final String? startTime;
  final String timeZone;
  final bool isAllDay;
  final bool isPersistent;
  final bool showInTodayUntilComplete;
  final List<TaskReminderDraft> reminders;
  final TaskRepeatDraft? repeatRule;
  final String? originalInput;
  final int sortOrder;
}

class TaskReminderDraft {
  const TaskReminderDraft({
    required this.remindAt,
    this.reminderType = 'absolute',
    this.offsetMinutes,
    this.isEnabled = true,
  });

  final DateTime remindAt;
  final String reminderType;
  final int? offsetMinutes;
  final bool isEnabled;
}

class TaskRepeatDraft {
  const TaskRepeatDraft({
    required this.frequency,
    this.interval = 1,
    this.weekdays,
    this.monthDay,
    this.endType = 'never',
    this.endDate,
    this.occurrenceCount,
  });

  final TaskRepeatFrequency frequency;
  final int interval;
  final String? weekdays;
  final int? monthDay;
  final String endType;
  final DateTime? endDate;
  final int? occurrenceCount;
}
