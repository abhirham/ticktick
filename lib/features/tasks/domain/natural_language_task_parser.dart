import 'task_draft.dart';
import 'task_enums.dart';

class NaturalLanguageTaskParser {
  const NaturalLanguageTaskParser._();

  static ParsedTaskInput parse(
    String input,
    DateTime now, {
    String timeZone = 'local',
    String locale = 'en_US',
  }) {
    final working = _WorkingInput(input);
    final warnings = <ParserResultWarning>[];
    final today = DateTime(now.year, now.month, now.day);

    final listAndGroup = _extractListAndGroup(working);
    final priority = _extractPriority(working);
    final persistent = _extractPersistent(working);
    final recurrence = _extractRecurrence(working);
    final reminder = _extractReminder(working, today, warnings);
    final start = _extractStart(working, today, warnings);
    final due = _extractDue(working, today, warnings);

    if (due.time != null && due.date == null) {
      warnings.add(
        const ParserResultWarning(
          code: ParserWarningCode.timeWithoutDate,
          message: 'A time was found without a due date.',
        ),
      );
    }

    final cleanedTitle = _cleanTitle(working.value);
    if (cleanedTitle.isEmpty && input.trim().isNotEmpty) {
      warnings.add(
        const ParserResultWarning(
          code: ParserWarningCode.emptyTitleAfterParsing,
          message: 'Parsed metadata removed all title text.',
        ),
      );
    }

    return ParsedTaskInput(
      originalInput: input,
      title: cleanedTitle,
      dueDate: due.date,
      dueTime: due.time,
      startDate: start.date,
      startTime: start.time,
      recurrence: recurrence,
      reminder: reminder,
      priority: priority,
      listName: listAndGroup.listName,
      groupName: listAndGroup.groupName,
      isPersistent: persistent,
      timeZone: timeZone,
      locale: locale,
      warnings: warnings,
    );
  }

  static _ListAndGroup _extractListAndGroup(_WorkingInput working) {
    final pattern = RegExp(
      r'(?:^|\s)/([A-Za-z0-9][A-Za-z0-9 _-]*?)(?:\s*>\s*([A-Za-z0-9][A-Za-z0-9 _-]*?))?(?=$|\s+(?:p[1-4]\b|![a-z]+\b|today\b|tomorrow\b|tonight\b|at\b|by\b|on\b|every\b|daily\b|weekly\b|monthly\b|yearly\b|annually\b|remind\b|alert\b|keep\b|until\b|carry\b|persistent\b|stay\b|start\b|starting\b))',
      caseSensitive: false,
    );
    final match = pattern.firstMatch(working.value);
    if (match == null) {
      return const _ListAndGroup();
    }

    final listName = match.group(1)?.trim();
    final groupName = match.group(2)?.trim();
    working.removeRange(match.start, match.end);
    return _ListAndGroup(
      listName: _emptyToNull(listName),
      groupName: _emptyToNull(groupName),
    );
  }

  static TaskPriority _extractPriority(_WorkingInput working) {
    final patterns = <RegExp, TaskPriority>{
      RegExp(
        r'(?:^|\s)(?:p1|!high|urgent|important|high priority)\b',
        caseSensitive: false,
      ): TaskPriority.high,
      RegExp(r'(?:^|\s)(?:p2|!medium|medium priority)\b', caseSensitive: false):
          TaskPriority.medium,
      RegExp(r'(?:^|\s)(?:p3|!low|low priority)\b', caseSensitive: false):
          TaskPriority.low,
      RegExp(r'(?:^|\s)(?:p4|!none|no priority)\b', caseSensitive: false):
          TaskPriority.none,
    };

    for (final entry in patterns.entries) {
      final match = entry.key.firstMatch(working.value);
      if (match != null) {
        working.removeRange(match.start, match.end);
        return entry.value;
      }
    }
    return TaskPriority.none;
  }

  static bool _extractPersistent(_WorkingInput working) {
    final pattern = RegExp(
      r'(?:^|\s|:\s*)(keep in today|until complete|until done|carry forward|persistent task|keep showing|stay in today)(?::)?',
      caseSensitive: false,
    );
    var found = false;
    while (true) {
      final match = pattern.firstMatch(working.value);
      if (match == null) break;
      found = true;
      working.removeRange(match.start, match.end);
    }
    return found;
  }

  static ParsedRecurrence? _extractRecurrence(_WorkingInput working) {
    final custom = RegExp(
      r'(?:^|\s)every\s+(other|\d+)\s+(day|week|month|year|monday|tuesday|wednesday|thursday|friday|saturday|sunday)s?\b',
      caseSensitive: false,
    ).firstMatch(working.value);
    if (custom != null) {
      final intervalText = custom.group(1)!.toLowerCase();
      final target = custom.group(2)!.toLowerCase();
      final interval = intervalText == 'other' ? 2 : int.parse(intervalText);
      final weekday = _weekdayFromName(target);
      working.removeRange(custom.start, custom.end);
      return ParsedRecurrence(
        frequency: weekday == null
            ? _recurrenceFrequencyForUnit(target)
            : RecurrenceFrequency.weekly,
        interval: interval,
        weekdays: weekday == null ? const [] : [weekday],
      );
    }

    final patterns = <RegExp, ParsedRecurrence>{
      RegExp(r'(?:^|\s)(?:every day|daily)\b', caseSensitive: false):
          const ParsedRecurrence(frequency: RecurrenceFrequency.daily),
      RegExp(r'(?:^|\s)(?:every week|weekly)\b', caseSensitive: false):
          const ParsedRecurrence(frequency: RecurrenceFrequency.weekly),
      RegExp(r'(?:^|\s)(?:every month|monthly)\b', caseSensitive: false):
          const ParsedRecurrence(frequency: RecurrenceFrequency.monthly),
      RegExp(r'(?:^|\s)(?:every year|yearly|annually)\b', caseSensitive: false):
          const ParsedRecurrence(frequency: RecurrenceFrequency.yearly),
      RegExp(
        r'(?:^|\s)(?:every weekday|weekdays)\b',
        caseSensitive: false,
      ): const ParsedRecurrence(
        frequency: RecurrenceFrequency.weekly,
        weekdays: [
          DateTime.monday,
          DateTime.tuesday,
          DateTime.wednesday,
          DateTime.thursday,
          DateTime.friday,
        ],
      ),
      RegExp(
        r'(?:^|\s)(?:every weekend|weekends)\b',
        caseSensitive: false,
      ): const ParsedRecurrence(
        frequency: RecurrenceFrequency.weekly,
        weekdays: [DateTime.saturday, DateTime.sunday],
      ),
    };

    for (final entry in patterns.entries) {
      final match = entry.key.firstMatch(working.value);
      if (match != null) {
        working.removeRange(match.start, match.end);
        return entry.value;
      }
    }

    final weekday = RegExp(
      r'(?:^|\s)every\s+(monday|tuesday|wednesday|thursday|friday|saturday|sunday)\b',
      caseSensitive: false,
    ).firstMatch(working.value);
    if (weekday != null) {
      final day = _weekdayFromName(weekday.group(1)!);
      working.removeRange(weekday.start, weekday.end);
      return ParsedRecurrence(
        frequency: RecurrenceFrequency.weekly,
        weekdays: day == null ? const [] : [day],
      );
    }

    return null;
  }

  static ParsedReminder? _extractReminder(
    _WorkingInput working,
    DateTime today,
    List<ParserResultWarning> warnings,
  ) {
    final offsetPattern = RegExp(
      r'(?:^|\s)(?:remind me|alert me)\s+(\d+)\s+(minute|minutes|hour|hours|day|days)\s+before\b',
      caseSensitive: false,
    );
    final offsetMatch = offsetPattern.firstMatch(working.value);
    if (offsetMatch != null) {
      final amount = int.parse(offsetMatch.group(1)!);
      final unit = offsetMatch.group(2)!.toLowerCase();
      final minutes = switch (unit) {
        'hour' || 'hours' => amount * 60,
        'day' || 'days' => amount * 24 * 60,
        _ => amount,
      };
      working.removeRange(offsetMatch.start, offsetMatch.end);
      return ParsedReminder(
        kind: ReminderKind.relative,
        offsetMinutes: minutes,
      );
    }

    final reminderPattern = RegExp(
      r'(?:^|\s)(?:remind me|alert me)(?:\s+(today|tomorrow|tonight))?(?:\s+(morning|afternoon|evening))?(?:\s+(?:at|by))?\s*(noon|midnight|\d{1,2}(?::\d{2})?\s*(?:am|pm)?|\d{1,2}:\d{2})?',
      caseSensitive: false,
    );
    final match = reminderPattern.firstMatch(working.value);
    if (match == null) {
      return null;
    }

    final dateWord = match.group(1)?.toLowerCase();
    final dayPart = match.group(2)?.toLowerCase();
    final timeText = match.group(3);
    final reminderDate = switch (dateWord) {
      'tomorrow' => today.add(const Duration(days: 1)),
      _ => today,
    };
    final time =
        _parseTime(timeText) ??
        _timeForDayPart(dayPart) ??
        _timeForDayPart(dateWord) ??
        '09:00';
    working.removeRange(match.start, match.end);
    return ParsedReminder(
      kind: ReminderKind.absolute,
      remindAt: _combineDateAndTime(reminderDate, time),
    );
  }

  static _ParsedDateTime _extractStart(
    _WorkingInput working,
    DateTime today,
    List<ParserResultWarning> warnings,
  ) {
    final pattern = RegExp(
      r'(?:^|\s)(?:start|starting)\s+(today|tomorrow|next\s+(?:monday|tuesday|wednesday|thursday|friday|saturday|sunday)|this\s+(?:monday|tuesday|wednesday|thursday|friday|saturday|sunday)|monday|tuesday|wednesday|thursday|friday|saturday|sunday|\d{4}-\d{1,2}-\d{1,2}|[A-Za-z]{3,9}\s+\d{1,2}(?:,\s*\d{4})?|\d{1,2}/\d{1,2}(?:/\d{2,4})?)(?:\s+(?:at|by)\s+(noon|midnight|\d{1,2}(?::\d{2})?\s*(?:am|pm)?|\d{1,2}:\d{2}))?',
      caseSensitive: false,
    );
    final match = pattern.firstMatch(working.value);
    if (match == null) return const _ParsedDateTime();

    final date = _parseDatePhrase(match.group(1)!, today, warnings);
    final time = _parseTime(match.group(2));
    working.removeRange(match.start, match.end);
    return _ParsedDateTime(date: date, time: time);
  }

  static _ParsedDateTime _extractDue(
    _WorkingInput working,
    DateTime today,
    List<ParserResultWarning> warnings,
  ) {
    DateTime? date;
    String? time;

    final datePattern = RegExp(
      r'(?:^|\s)(?:on|due)?\s*(today|tomorrow|tonight|next\s+(?:monday|tuesday|wednesday|thursday|friday|saturday|sunday)|this\s+(?:monday|tuesday|wednesday|thursday|friday|saturday|sunday)|monday|tuesday|wednesday|thursday|friday|saturday|sunday|\d{4}-\d{1,2}-\d{1,2}|[A-Za-z]{3,9}\s+\d{1,2}(?:,\s*\d{4})?|\d{1,2}/\d{1,2}(?:/\d{2,4})?)\b',
      caseSensitive: false,
    );
    final dateMatch = datePattern.firstMatch(working.value);
    if (dateMatch != null) {
      date = _parseDatePhrase(dateMatch.group(1)!, today, warnings);
      if (dateMatch.group(1)!.toLowerCase() == 'tonight') {
        time = '18:00';
      }
      working.removeRange(dateMatch.start, dateMatch.end);
    }

    final timePattern = RegExp(
      r'(?:^|\s)(?:at|by)\s+(noon|midnight|\d{1,2}(?::\d{2})?\s*(?:am|pm)?|\d{1,2}:\d{2})\b',
      caseSensitive: false,
    );
    final timeMatch = timePattern.firstMatch(working.value);
    if (timeMatch != null) {
      time = _parseTime(timeMatch.group(1)) ?? time;
      working.removeRange(timeMatch.start, timeMatch.end);
    }

    return _ParsedDateTime(date: date, time: time);
  }

  static DateTime? _parseDatePhrase(
    String phrase,
    DateTime today,
    List<ParserResultWarning> warnings,
  ) {
    final normalized = phrase.trim().toLowerCase().replaceAll(',', '');
    if (normalized == 'today' || normalized == 'tonight') return today;
    if (normalized == 'tomorrow') return today.add(const Duration(days: 1));

    final weekdayMatch = RegExp(
      r'^(?:(next|this)\s+)?(monday|tuesday|wednesday|thursday|friday|saturday|sunday)$',
    ).firstMatch(normalized);
    if (weekdayMatch != null) {
      final modifier = weekdayMatch.group(1);
      final weekday = _weekdayFromName(weekdayMatch.group(2)!);
      if (weekday == null) return null;
      return _dateForWeekday(today, weekday, next: modifier == 'next');
    }

    final iso = RegExp(r'^(\d{4})-(\d{1,2})-(\d{1,2})$').firstMatch(normalized);
    if (iso != null) {
      return _validDate(
        int.parse(iso.group(1)!),
        int.parse(iso.group(2)!),
        int.parse(iso.group(3)!),
      );
    }

    final slash = RegExp(
      r'^(\d{1,2})/(\d{1,2})(?:/(\d{2,4}))?$',
    ).firstMatch(normalized);
    if (slash != null) {
      final month = int.parse(slash.group(1)!);
      final day = int.parse(slash.group(2)!);
      final year = _yearOrNextUpcoming(slash.group(3), month, day, today);
      if (slash.group(3) == null) {
        warnings.add(
          const ParserResultWarning(
            code: ParserWarningCode.missingYear,
            message: 'A numeric date was parsed without an explicit year.',
          ),
        );
      }
      return _validDate(year, month, day);
    }

    final month = RegExp(
      r'^(jan|january|feb|february|mar|march|apr|april|may|jun|june|jul|july|aug|august|sep|sept|september|oct|october|nov|november|dec|december)\s+(\d{1,2})(?:\s+(\d{4}))?$',
    ).firstMatch(normalized);
    if (month != null) {
      final monthNumber = _monthFromName(month.group(1)!);
      final day = int.parse(month.group(2)!);
      final year = _yearOrNextUpcoming(month.group(3), monthNumber, day, today);
      if (month.group(3) == null) {
        warnings.add(
          const ParserResultWarning(
            code: ParserWarningCode.missingYear,
            message:
                'A month-and-day date was parsed without an explicit year.',
          ),
        );
      }
      return _validDate(year, monthNumber, day);
    }

    warnings.add(
      ParserResultWarning(
        code: ParserWarningCode.unrecognizedDate,
        message: 'Could not parse date phrase "$phrase".',
      ),
    );
    return null;
  }

  static String? _parseTime(String? value) {
    if (value == null) return null;
    final normalized = value.trim().toLowerCase().replaceAll(' ', '');
    if (normalized.isEmpty) return null;
    if (normalized == 'noon') return '12:00';
    if (normalized == 'midnight') return '00:00';

    final match = RegExp(
      r'^(\d{1,2})(?::(\d{2}))?(am|pm)?$',
    ).firstMatch(normalized);
    if (match == null) return null;

    var hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2) ?? '0');
    final suffix = match.group(3);
    if (suffix == 'am' && hour == 12) hour = 0;
    if (suffix == 'pm' && hour < 12) hour += 12;
    if (hour > 23 || minute > 59) return null;
    return '${hour.toString().padLeft(2, '0')}:'
        '${minute.toString().padLeft(2, '0')}';
  }

  static String? _timeForDayPart(String? value) {
    return switch (value) {
      'morning' => '09:00',
      'afternoon' => '13:00',
      'evening' || 'tonight' => '18:00',
      _ => null,
    };
  }

  static DateTime _combineDateAndTime(DateTime date, String time) {
    final parts = time.split(':');
    return DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  static DateTime _dateForWeekday(
    DateTime today,
    int weekday, {
    required bool next,
  }) {
    var delta = weekday - today.weekday;
    if (delta < 0 || (next && delta == 0)) {
      delta += 7;
    }
    if (next && delta < 7) {
      delta += 7;
    }
    return today.add(Duration(days: delta));
  }

  static int _yearOrNextUpcoming(
    String? yearText,
    int month,
    int day,
    DateTime today,
  ) {
    if (yearText != null) {
      final year = int.parse(yearText);
      return year < 100 ? 2000 + year : year;
    }
    final candidate = _validDate(today.year, month, day);
    if (candidate != null && !candidate.isBefore(today)) {
      return today.year;
    }
    return today.year + 1;
  }

  static DateTime? _validDate(int year, int month, int day) {
    final date = DateTime(year, month, day);
    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }
    return date;
  }

  static int _monthFromName(String name) {
    return const {
      'jan': 1,
      'january': 1,
      'feb': 2,
      'february': 2,
      'mar': 3,
      'march': 3,
      'apr': 4,
      'april': 4,
      'may': 5,
      'jun': 6,
      'june': 6,
      'jul': 7,
      'july': 7,
      'aug': 8,
      'august': 8,
      'sep': 9,
      'sept': 9,
      'september': 9,
      'oct': 10,
      'october': 10,
      'nov': 11,
      'november': 11,
      'dec': 12,
      'december': 12,
    }[name]!;
  }

  static int? _weekdayFromName(String name) {
    return const {
      'monday': DateTime.monday,
      'tuesday': DateTime.tuesday,
      'wednesday': DateTime.wednesday,
      'thursday': DateTime.thursday,
      'friday': DateTime.friday,
      'saturday': DateTime.saturday,
      'sunday': DateTime.sunday,
    }[name.toLowerCase()];
  }

  static RecurrenceFrequency _recurrenceFrequencyForUnit(String unit) {
    return switch (unit.toLowerCase()) {
      'week' => RecurrenceFrequency.weekly,
      'month' => RecurrenceFrequency.monthly,
      'year' => RecurrenceFrequency.yearly,
      _ => RecurrenceFrequency.daily,
    };
  }

  static String _cleanTitle(String value) {
    return value
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'\s+([:;,])'), r'$1')
        .replaceAll(RegExp(r'^[\s:;,-]+|[\s:;,-]+$'), '')
        .trim();
  }

  static String? _emptyToNull(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}

class ParsedTaskInput {
  const ParsedTaskInput({
    required this.originalInput,
    required this.title,
    this.dueDate,
    this.dueTime,
    this.startDate,
    this.startTime,
    this.recurrence,
    this.reminder,
    this.priority = TaskPriority.none,
    this.listName,
    this.groupName,
    this.isPersistent = false,
    this.timeZone = 'local',
    this.locale = 'en_US',
    this.warnings = const [],
  });

  final String originalInput;
  final String title;
  final DateTime? dueDate;
  final String? dueTime;
  final DateTime? startDate;
  final String? startTime;
  final ParsedRecurrence? recurrence;
  final ParsedReminder? reminder;
  final TaskPriority priority;
  final String? listName;
  final String? groupName;
  final bool isPersistent;
  final String timeZone;
  final String locale;
  final List<ParserResultWarning> warnings;

  TaskDraft toDraft({String? listId, String? groupId}) {
    return TaskDraft(
      title: title,
      priority: priority,
      listId: listId,
      groupId: groupId,
      dueDate: dueDate,
      dueTime: dueTime,
      startDate: startDate,
      startTime: startTime,
      timeZone: timeZone,
      isAllDay: dueTime == null,
      isPersistent: isPersistent,
      showInTodayUntilComplete: isPersistent,
      originalInput: originalInput,
    );
  }
}

class ParsedRecurrence {
  const ParsedRecurrence({
    required this.frequency,
    this.interval = 1,
    this.weekdays = const [],
  });

  final RecurrenceFrequency frequency;
  final int interval;
  final List<int> weekdays;
}

class ParsedReminder {
  const ParsedReminder({required this.kind, this.remindAt, this.offsetMinutes});

  final ReminderKind kind;
  final DateTime? remindAt;
  final int? offsetMinutes;
}

class ParserResultWarning {
  const ParserResultWarning({required this.code, required this.message});

  final ParserWarningCode code;
  final String message;
}

enum RecurrenceFrequency { daily, weekly, monthly, yearly }

enum ReminderKind { absolute, relative }

enum ParserWarningCode {
  missingYear,
  timeWithoutDate,
  unrecognizedDate,
  emptyTitleAfterParsing,
}

class _WorkingInput {
  _WorkingInput(String value) : value = value.trim();

  String value;

  void removeRange(int start, int end) {
    value = '${value.substring(0, start)} ${value.substring(end)}';
  }
}

class _ParsedDateTime {
  const _ParsedDateTime({this.date, this.time});

  final DateTime? date;
  final String? time;
}

class _ListAndGroup {
  const _ListAndGroup({this.listName, this.groupName});

  final String? listName;
  final String? groupName;
}
