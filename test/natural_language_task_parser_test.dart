import 'package:flutter_test/flutter_test.dart';

import 'package:flowtask/features/tasks/domain/natural_language_task_parser.dart';
import 'package:flowtask/features/tasks/domain/task_enums.dart';

void main() {
  final now = DateTime(2026, 5, 12, 14, 30);

  ParsedTaskInput parse(String input) {
    return NaturalLanguageTaskParser.parse(input, now);
  }

  test('cleans persistent phrases from title', () {
    final result = parse('Keep in today: send builder email');

    expect(result.title, 'send builder email');
    expect(result.isPersistent, isTrue);
    expect(result.originalInput, 'Keep in today: send builder email');
  });

  test('extracts priority aliases', () {
    expect(parse('pay insurance p1').priority, TaskPriority.high);
    expect(parse('pay insurance !medium').priority, TaskPriority.medium);
    expect(parse('pay insurance !low').priority, TaskPriority.low);
    expect(parse('pay insurance p4').priority, TaskPriority.none);
    expect(parse('urgent call builder').priority, TaskPriority.high);
  });

  test('extracts list and group syntax', () {
    final result = parse('Book plumber /House > Builder tomorrow');

    expect(result.title, 'Book plumber');
    expect(result.listName, 'House');
    expect(result.groupName, 'Builder');
    expect(result.dueDate, DateTime(2026, 5, 13));
  });

  test('extracts due dates and times', () {
    final result = parse('Submit claim tomorrow at 9:15pm');

    expect(result.title, 'Submit claim');
    expect(result.dueDate, DateTime(2026, 5, 13));
    expect(result.dueTime, '21:15');
  });

  test('uses the next upcoming year when month date has no year', () {
    final result = parse('Renew policy May 8');

    expect(result.title, 'Renew policy');
    expect(result.dueDate, DateTime(2027, 5, 8));
    expect(
      result.warnings.map((warning) => warning.code),
      contains(ParserWarningCode.missingYear),
    );
  });

  test('warns for time without date', () {
    final result = parse('Call bank at 5pm');

    expect(result.title, 'Call bank');
    expect(result.dueDate, isNull);
    expect(result.dueTime, '17:00');
    expect(
      result.warnings.map((warning) => warning.code),
      contains(ParserWarningCode.timeWithoutDate),
    );
  });

  test('extracts relative and absolute reminders', () {
    final relative = parse('Submit report remind me 10 minutes before');
    expect(relative.title, 'Submit report');
    expect(relative.reminder?.kind, ReminderKind.relative);
    expect(relative.reminder?.offsetMinutes, 10);

    final absolute = parse('Submit report alert me tomorrow morning');
    expect(absolute.title, 'Submit report');
    expect(absolute.reminder?.kind, ReminderKind.absolute);
    expect(absolute.reminder?.remindAt, DateTime(2026, 5, 13, 9));
  });

  test('extracts recurrence phrases', () {
    final weekdays = parse('Review inbox every weekday');
    expect(weekdays.title, 'Review inbox');
    expect(weekdays.recurrence?.frequency, RecurrenceFrequency.weekly);
    expect(weekdays.recurrence?.weekdays, [
      DateTime.monday,
      DateTime.tuesday,
      DateTime.wednesday,
      DateTime.thursday,
      DateTime.friday,
    ]);

    final everyOther = parse('Water plants every other Saturday');
    expect(everyOther.recurrence?.frequency, RecurrenceFrequency.weekly);
    expect(everyOther.recurrence?.interval, 2);
    expect(everyOther.recurrence?.weekdays, [DateTime.saturday]);
  });

  test('extracts start date and time separately from due metadata', () {
    final result = parse('Draft proposal starting tomorrow at 8am due Friday');

    expect(result.title, 'Draft proposal');
    expect(result.startDate, DateTime(2026, 5, 13));
    expect(result.startTime, '08:00');
    expect(result.dueDate, DateTime(2026, 5, 15));
  });

  test('creates a task draft with parsed metadata', () {
    final result = parse('until done Pay tax /Home p2 tomorrow by noon');
    final draft = result.toDraft(listId: 'home');

    expect(draft.title, 'Pay tax');
    expect(draft.priority, TaskPriority.medium);
    expect(draft.listId, 'home');
    expect(draft.dueDate, DateTime(2026, 5, 13));
    expect(draft.dueTime, '12:00');
    expect(draft.isPersistent, isTrue);
    expect(draft.showInTodayUntilComplete, isTrue);
    expect(draft.originalInput, 'until done Pay tax /Home p2 tomorrow by noon');
  });
}
