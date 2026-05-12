enum TaskStatus {
  open('open'),
  completed('completed'),
  deleted('deleted');

  const TaskStatus(this.value);

  final String value;

  static TaskStatus fromValue(String value) {
    return TaskStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => TaskStatus.open,
    );
  }
}

enum TaskPriority {
  none('none'),
  low('low'),
  medium('medium'),
  high('high');

  const TaskPriority(this.value);

  final String value;

  static TaskPriority fromValue(String value) {
    return TaskPriority.values.firstWhere(
      (priority) => priority.value == value,
      orElse: () => TaskPriority.none,
    );
  }
}

extension TaskPriorityLabel on TaskPriority {
  String get label {
    return switch (this) {
      TaskPriority.none => 'None',
      TaskPriority.low => 'Low',
      TaskPriority.medium => 'Medium',
      TaskPriority.high => 'High',
    };
  }
}
