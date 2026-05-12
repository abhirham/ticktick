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
  final String? originalInput;
  final int sortOrder;
}
